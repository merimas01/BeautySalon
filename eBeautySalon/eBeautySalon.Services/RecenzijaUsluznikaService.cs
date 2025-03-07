﻿using AutoMapper;
using eBeautySalon.Models;
using eBeautySalon.Models.Requests;
using eBeautySalon.Models.SearchObjects;
using eBeautySalon.Models.Utils;
using eBeautySalon.Services.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection.Metadata;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory;

namespace eBeautySalon.Services
{
    public class RecenzijaUsluznikaService : BaseCRUDService<Models.RecenzijaUsluznika, Database.RecenzijaUsluznika, RecenzijaUsluznikaSearchObject, RecenzijaUsluznikaInsertRequest, RecenzijaUsluznikaUpdateRequest>, IRecenzijaUsluznikaService
    {
        public RecenzijaUsluznikaService(Ib200070Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Database.RecenzijaUsluznika> AddFilter(IQueryable<Database.RecenzijaUsluznika> query, RecenzijaUsluznikaSearchObject? search = null)
        {
            query = query.OrderByDescending(x => x.RecenzijaUsluznikaId);
            if (!string.IsNullOrEmpty(search.FTS))
            {
                query = query.Where(x => x.Korisnik.Ime.Contains(search.FTS)
                || x.Korisnik.Prezime.Contains(search.FTS)
                || x.Usluznik.Korisnik.Ime.Contains(search.FTS) 
                || x.Usluznik.Korisnik.Prezime.Contains(search.FTS)
                || x.Ocjena.ToString().StartsWith(search.FTS)
                || x.Komentar.StartsWith(search.FTS)
               // || x.Usluznik.Korisnik.Sifra.Contains(search.FTS)
                );
            }
            if (search.UsluznikId != null)
            {
                query = query.Where(x => x.UsluznikId == search.UsluznikId);
            }
            if (search.KorisnikId != null)
            {
                query = query.Where(x => x.KorisnikId == search.KorisnikId);
            }
            if (search.UslugaId != null)
            {
                query = query.Where(x => x.Usluznik.ZaposlenikUslugas.Where(y => y.UslugaId == search.UslugaId).Count() != 0);
            }
            return base.AddFilter(query, search);
        }
        public override IQueryable<Database.RecenzijaUsluznika> AddInclude(IQueryable<Database.RecenzijaUsluznika> query, RecenzijaUsluznikaSearchObject? search = null)
        {
            if (search?.isKorisnikIncluded == true)
            {
                query = query.Include(x => x.Korisnik.SlikaProfila);
            }
            if (search?.isZaposlenikIncluded == true)
            {
                query = query.Include(x => x.Usluznik.Korisnik.SlikaProfila);
                query = query.Include("Usluznik.ZaposlenikUslugas.Usluga");
            }
            return base.AddInclude(query, search);
        }

        public override async Task<bool> AddValidationInsert(RecenzijaUsluznikaInsertRequest request)
        {
            // ne smije korisnikId biti zaposlenik
            // zaposlenik mora biti usluznik
            // ne smije se dodati vec postojeca recenzija (isti usluznik i korisnik)
            // mora postojati validan usluznikId i korisnikId
            var brojRijeciKomentar = request.Komentar?.Trim().Split(new[] { ' ', '\t', '\n', '\r' }, StringSplitOptions.RemoveEmptyEntries).Length ?? 0;

            var korisnik_zaposlenik = await _context.Zaposleniks.FirstOrDefaultAsync(x => x.KorisnikId == request.KorisnikId);         
            var korisnikId = _context.Zaposleniks.Where(x => x.ZaposlenikId == request.UsluznikId).Select(x => x.KorisnikId).FirstOrDefault();
            var korisnik_uloga_usluznik = _context.KorisnikUlogas.Where(x => x.UlogaId == Constants.DEFAULT_Uloga_Usluznik && x.KorisnikId == korisnikId).FirstOrDefault();
            var recenzija_usluznika = await _context.RecenzijaUsluznikas.FirstOrDefaultAsync(x => x.UsluznikId == request.UsluznikId && x.KorisnikId == request.KorisnikId);
            var usluznici = await _context.Zaposleniks.Where(x => x.ZaposlenikUslugas.Count() != 0).Select(x=>x.ZaposlenikId).ToListAsync();
            var korisnici = await _context.Korisniks.Where(x => x.KorisnikUlogas.Count() == 0).Select(x=>x.KorisnikId).ToListAsync();

            if (korisnik_zaposlenik != null) return false; //korisnik u requestu je zaposlenik (zaposlenik ne smije recenzirati)
            else if (korisnik_uloga_usluznik == null) return false; // zaposlenik nije usluznik
            else if (recenzija_usluznika != null) return false; //postoji vec isti objekat
            else if (brojRijeciKomentar > 15) return false; //ako je broj rijeci veci od 15
            else if (request.Komentar != null && request.Komentar.Trim() == "") return false; //ne smije biti prazan string
            else if (!usluznici.Contains(request.UsluznikId) || !korisnici.Contains(request.KorisnikId)) return false; //nije validan usluznik ili korisnik
            return true; 
        }
        public override async Task<bool> AddValidationUpdate(int id, RecenzijaUsluznikaUpdateRequest request)
        {
            var korisnik_zaposlenik = await _context.Zaposleniks.FirstOrDefaultAsync(x => x.KorisnikId == request.KorisnikId);
            var korisnikId = _context.Zaposleniks.Where(x => x.ZaposlenikId == request.UsluznikId).Select(x => x.KorisnikId).FirstOrDefault();
            var korisnik_uloga_usluznik = _context.KorisnikUlogas.Where(x => x.UlogaId == Constants.DEFAULT_Uloga_Usluznik && x.KorisnikId == korisnikId).FirstOrDefault();
            var recenzija_usluznika = await _context.RecenzijaUsluznikas.FirstOrDefaultAsync(x => (x.UsluznikId == request.UsluznikId && x.KorisnikId == request.KorisnikId) && x.RecenzijaUsluznikaId != id);
            var usluznici = await _context.Zaposleniks.Where(x => x.ZaposlenikUslugas.Count() != 0).Select(x => x.ZaposlenikId).ToListAsync();
            var korisnici = await _context.Korisniks.Where(x => x.KorisnikUlogas.Count() == 0).Select(x => x.KorisnikId).ToListAsync();
            var brojRijeciKomentar = request.Komentar?.Trim().Split(new[] { ' ', '\t', '\n', '\r' }, StringSplitOptions.RemoveEmptyEntries).Length ?? 0;

            if (korisnik_zaposlenik != null) return false; //korisnik u requestu je zaposlenik (zaposlenik ne smije recenzirati)
            else if (korisnik_uloga_usluznik == null) return false; // zaposlenik nije usluznik
            else if (recenzija_usluznika != null) return false; //postoji vec isti objekat
            else if (brojRijeciKomentar > 15) return false;
            else if (request.Komentar != null && request.Komentar.Trim() == "") return false;
            else if (!usluznici.Contains(request.UsluznikId) || !korisnici.Contains(request.KorisnikId)) return false; //nije validan usluznik ili korisnik
            return true;
        }

        public async Task<List<dynamic>> GetProsjecneOcjeneUsluznika()
        {
            var recenzijeUsluznika = await _context.RecenzijaUsluznikas.Include(x => x.Usluznik.Korisnik.SlikaProfila).Include(x => x.Korisnik.SlikaProfila).ToListAsync();
            var usluznikIdDistinct = await _context.RecenzijaUsluznikas.Select(x => x.UsluznikId).Distinct().ToListAsync();
            var prosjecneOcjene_usluznik = new List<dynamic>();

            foreach (var index in usluznikIdDistinct)
            {
                string usluznik = "";
                string sifra = "";
                double suma = 0.0;
                double prosjek = 0.0;
                int brojac = 0;
                List<int> ocjene = new List<int>();
                foreach (var ru in recenzijeUsluznika)
                {
                    if (ru.UsluznikId == index)
                    {
                        ocjene.Add(ru.Ocjena);
                        usluznik = ru.Usluznik.Korisnik.Ime + " " + ru.Usluznik.Korisnik.Prezime;
                        sifra = ru.Usluznik.Korisnik.Sifra;
                        suma += ru.Ocjena;
                        brojac++;
                    }
                }
                prosjek = Math.Round((suma / brojac), 1);
                var obj = new { usluznikId = index, nazivUsluznik = usluznik, sifraUsluznik = sifra, prosjecnaOcjena = prosjek, sveOcjene = ocjene };
                prosjecneOcjene_usluznik.Add(obj);
            }

            return prosjecneOcjene_usluznik;
        }

        public override async Task<Database.RecenzijaUsluznika> AddIncludeForGetById(IQueryable<Database.RecenzijaUsluznika> query, int id)
        {
            query = query.Include(x => x.Korisnik.SlikaProfila);
            query = query.Include(x => x.Usluznik.Korisnik.SlikaProfila);
            query = query.Include("Usluznik.ZaposlenikUslugas.Usluga");
            var entity = await query.FirstOrDefaultAsync(x => x.RecenzijaUsluznikaId == id);
            return entity;
        }
    }
}
