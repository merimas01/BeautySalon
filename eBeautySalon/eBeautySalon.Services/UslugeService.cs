﻿using AutoMapper;
using eBeautySalon.Models;
using eBeautySalon.Models.Requests;
using eBeautySalon.Models.SearchObjects;
using eBeautySalon.Services.Database;
using eBeautySalon.Models.Utils;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory;
using Microsoft.ML;
using Microsoft.ML.Data;
using Microsoft.ML.Trainers;
using Microsoft.EntityFrameworkCore.Metadata.Internal;

namespace eBeautySalon.Services
{
    public class UslugeService : BaseCRUDService<Usluge, Usluga, UslugeSearchObject, UslugeInsertRequest, UslugeUpdateRequest>, IUslugeService
    {
        public UslugeService(Ib200070Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public override async Task BeforeInsert(Usluga entity, UslugeInsertRequest insert)
        {
            if (insert.SlikaUslugeId == null || insert.SlikaUslugeId == 0)
                entity.SlikaUslugeId = _context.SlikaUsluges.Select(x => x.SlikaUslugeId).First();          
        }

        public override async Task BeforeDelete(Usluga entity)
        {
            var slikaUslugeId = entity.SlikaUslugeId;
            var slikaUsluge = slikaUslugeId!=null? await _context.SlikaUsluges.Where(x => x.SlikaUslugeId == slikaUslugeId).FirstAsync():null;
            var recenzije_usluga = await _context.RecenzijaUsluges.Where(x => x.UslugaId == entity.UslugaId).ToListAsync();
            var usluga_termini = await _context.UslugaTermins.Where(x => x.UslugaId == entity.UslugaId).ToListAsync();
            var zaposlenici_usluge = await _context.ZaposlenikUslugas.Where(x => x.UslugaId == entity.UslugaId).ToListAsync();
            var rezervacija_usluge = await _context.Rezervacijas.Where(x => x.UslugaId == entity.UslugaId).ToListAsync();
            var favoritiUsluge = await _context.FavoritiUsluges.Where(x => x.UslugaId == entity.UslugaId).ToListAsync();

            if (slikaUsluge != null && slikaUslugeId != Constants.DEFAULT_SlikaUslugeId) { 
                _context.Remove(slikaUsluge); //deleta se ovaj objekat jer se nece koristiti vise
            }
            foreach (var item in recenzije_usluga)
            {
                _context.Remove(item);
            }
            foreach (var item in usluga_termini)
            {
                _context.Remove(item);
            }
            foreach (var item in zaposlenici_usluge)
            {
                _context.Remove(item);
            }
            foreach (var item in rezervacija_usluge)
            {
                _context.Remove(item);
            }
            foreach (var item in favoritiUsluge)
            {
                _context.Remove(item);
            }
        }

        public override async Task<bool> AddValidationInsert(UslugeInsertRequest insert)
        {
            var usluga_nazivi = await _context.Uslugas.Select(x => x.Naziv.ToLower()).ToListAsync();
            if (usluga_nazivi.Contains(insert.Naziv.ToLower())) return false; else return true;
        }

        public override async Task<bool> AddValidationUpdate(int id, UslugeUpdateRequest request)
        {
            var usluga_nazivi = await _context.Uslugas.Where(x => x.UslugaId != id).Select(x => x.Naziv.ToLower()).ToListAsync();
            if (usluga_nazivi.Contains(request.Naziv.ToLower())) return false; else return true;
        }

        public override IQueryable<Usluga> AddFilter(IQueryable<Usluga> query, UslugeSearchObject? search = null)
        {
            query = query.OrderByDescending(x => x.UslugaId);
            if (!string.IsNullOrWhiteSpace(search?.FTS))
            {
                query = query.Where(x => (x.Naziv != null && x.Naziv.ToLower().Contains(search.FTS.ToLower())) 
                || (x.Opis!=null && x.Opis.ToLower().Contains(search.FTS.ToLower())
                || (x.Cijena.ToString().Contains(search.FTS)) 
                || (x.Kategorija.Naziv != null && x.Kategorija.Naziv.Contains(search.FTS))
                || (x.Sifra != null && x.Sifra.Contains(search.FTS))
                ));
            }
            if (search.KategorijaId != null)
            {
                query = query.Where(x => x.KategorijaId == search.KategorijaId);
            }
            if (!string.IsNullOrWhiteSpace(search?.Naziv))
            {
                query = query.Where(x => x.Naziv != null && x.Naziv.StartsWith(search.Naziv));
            }
            if (!string.IsNullOrWhiteSpace(search?.Opis))
            {
                query = query.Where(x => x.Opis != null && x.Opis.Contains(search.Opis));
            }
            if (search?.Cijena != null)
            {
                query = query.Where(x => x.Cijena == search.Cijena);
            }
            query = query.Include("FavoritiUsluges.Korisnik");
            return base.AddFilter(query, search);
        }

        public override IQueryable<Usluga> AddInclude(IQueryable<Usluga> query, UslugeSearchObject? search = null)
        {
            if (search?.isKategorijaIncluded == true)
            {
                query = query.Include(c => c.Kategorija);
            }
            if (search?.isSlikaIncluded == true)
            {
                query = query.Include(c => c.SlikaUsluge);
            }
            return base.AddInclude(query, search);
        }

        public override async Task<Usluga> AddIncludeForGetById(IQueryable<Usluga> query, int id)
        {
            query = query.Include(c => c.Kategorija);
            query = query.Include(c => c.SlikaUsluge);
            query = query.Include("FavoritiUsluges.Korisnik");
            var entity = await query.FirstOrDefaultAsync(x => x.UslugaId == id);
            return entity;
        }

        public override async Task AfterInsert(Usluga entity, UslugeInsertRequest insert)
        {
            entity.Sifra = "U" + entity.UslugaId.ToString("D6");
        }

        static MLContext mLContext = null;
        static object isLocked = new object();
        static ITransformer model = null;

        public List<Models.Usluge> Recommend(int uslugaId, int korisnikId)
        {
            lock (isLocked)
            {
                if (mLContext == null)
                {
                    mLContext = new MLContext();
                    var tmp = _context.Rezervacijas.Include(x => x.Usluga).ToList();
                    var tempData = _context.RecenzijaUsluges.Include(x => x.Korisnik).Include(x => x.Usluga.Kategorija).ToList();
                    var uslugeList = _context.Uslugas.ToList();
                    var data = new List<UslugaEntry>();
                 
                    foreach (var rec in tempData)
                    {
                        if (rec.KorisnikId == korisnikId)
                        {
                            foreach (var item in uslugeList)
                            {
                                if (item.UslugaId != rec.UslugaId && item.KategorijaId == rec.Usluga.KategorijaId)
                                {
                                    data.Add(new UslugaEntry { UslugaId = (uint)rec.UslugaId, CoUsluga_Id = (uint)item.UslugaId });
                                }
                            }
                        }                      
                    }

                    if (data.Count != 0) {
                        var trainData = mLContext.Data.LoadFromEnumerable(data);

                        MatrixFactorizationTrainer.Options options = new MatrixFactorizationTrainer.Options();
                        options.MatrixColumnIndexColumnName = nameof(UslugaEntry.UslugaId);
                        options.MatrixRowIndexColumnName = nameof(UslugaEntry.CoUsluga_Id);
                        options.LabelColumnName = "Label";
                        options.LossFunction = MatrixFactorizationTrainer.LossFunctionType.SquareLossOneClass;
                        options.Alpha = 0.01;
                        options.Lambda = 0.025;
                        // For better results use the following parameters
                        options.NumberOfIterations = 100;
                        options.C = 0.00001;

                        var est = mLContext.Recommendation().Trainers.MatrixFactorization(options);
                        model = est.Fit(trainData);
                    }             
                }
            }

            //prediction

            var usluge = _context.Uslugas.Include(x => x.SlikaUsluge).Include("FavoritiUsluges").Include(x => x.Kategorija).Where(x => x.UslugaId != uslugaId);
            var predictionResult = new List<Tuple<Database.Usluga, float>>(); //onaj koji ima najveci score, njega uzimamo

            if (model != null)
            {               
                foreach (var usluga in usluge)
                {
                    var predictionengine = mLContext.Model.CreatePredictionEngine<UslugaEntry, CoUsluga_Prediction>(model);

                    var prediction = predictionengine.Predict(
                                             new UslugaEntry()
                                             {
                                                 UslugaId = (uint)uslugaId,
                                                 CoUsluga_Id = (uint)usluga.UslugaId
                                             });


                    predictionResult.Add(new Tuple<Database.Usluga, float>(usluga, prediction.Score));

                }

                //order by score - najveci skor ce biti u prvom redu
                var result = predictionResult;
                var finalResult = predictionResult.OrderByDescending(x => x.Item2).Select(x => x.Item1);
                var res = finalResult.Take(3).ToList();

                mLContext = null;
                model = null;
                return _mapper.Map<List<Models.Usluge>>(res);
            }
            else
            {
                mLContext = null;
                model = null;
                return new List<Usluge>();
            }

        }
    }

    public class CoUsluga_Prediction
    {
        public float Score { get; set; }
    }

    public class UslugaEntry
    {
        [KeyType(count:100)] //daje hint ml .netu koliku matricu treba da napravi, 10x10
        public uint UslugaId { get; set; }

        [KeyType(count: 100)]
        public uint CoUsluga_Id { get; set; }

        public float Label { get; set; } 
    }
}
