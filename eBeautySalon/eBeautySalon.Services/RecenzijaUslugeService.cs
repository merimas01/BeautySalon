using AutoMapper;
using eBeautySalon.Models;
using eBeautySalon.Models.Requests;
using eBeautySalon.Models.SearchObjects;
using eBeautySalon.Services.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBeautySalon.Services
{
    public class RecenzijaUslugeService : BaseCRUDService<Models.RecenzijaUsluge, Database.RecenzijaUsluge, RecenzijaUslugeSearchObject, RecenzijaUslugeInsertRequest, RecenzijaUslugeUpdateRequest>, IRecenzijaUslugeService
    {
        public RecenzijaUslugeService(Ib200070Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Database.RecenzijaUsluge> AddFilter(IQueryable<Database.RecenzijaUsluge> query, RecenzijaUslugeSearchObject? search = null)
        {
            if (!string.IsNullOrEmpty(search.FTS))
            {
                query = query.Where(x => x.Usluga.Naziv.Contains(search.FTS)
                || x.Korisnik.Ime.Contains(search.FTS)
                || x.Korisnik.Prezime.Contains(search.FTS)
                || x.Ocjena.ToString().StartsWith(search.FTS)
                || x.Komentar.StartsWith(search.FTS));
            }
            return base.AddFilter(query, search);
        }
        public override IQueryable<Database.RecenzijaUsluge> AddInclude(IQueryable<Database.RecenzijaUsluge> query, RecenzijaUslugeSearchObject? search = null)
        {
            if (search?.isKorisnikIncluded == true)
            {
                query = query.Include(x => x.Korisnik.SlikaProfila);
            }
            if (search?.isUslugeIncluded == true)
            {
                query = query.Include(x => x.Usluga);
            }
            return base.AddInclude(query, search);
        }
        public override async Task<bool> AddValidationInsert(RecenzijaUslugeInsertRequest request)
        {
            //ne smiju zaposlenici recenzirati
            //ne smiju postojati dvije recenzije sa istim korisnikom i uslugom
            //usluga i korisnik trebaju biti validni

            var korisnik_zaposlenik = await _context.Zaposleniks.FirstOrDefaultAsync(x => x.KorisnikId == request.KorisnikId);
            var recenzija_usluge = await _context.RecenzijaUsluges.Where(x => x.KorisnikId == request.KorisnikId && x.UslugaId == request.UslugaId).FirstOrDefaultAsync();
            var usluge = await _context.Uslugas.Select(x => x.UslugaId).ToListAsync();
            var korisnici = await _context.Korisniks.Where(x => x.KorisnikUlogas.Count() == 0).Select(x => x.KorisnikId).ToListAsync();

            if (korisnik_zaposlenik != null) return false;
            if (recenzija_usluge != null) return false;
            else if(!usluge.Contains(request.UslugaId) || !korisnici.Contains(request.KorisnikId)) return false;
            return true;

        }

        public override async Task<bool> AddValidationUpdate(int id, RecenzijaUslugeUpdateRequest request)
        {
            var korisnik_zaposlenik = await _context.Zaposleniks.FirstOrDefaultAsync(x => x.KorisnikId == request.KorisnikId);
            var recenzija_usluge = await _context.RecenzijaUsluges.Where(x => (x.KorisnikId == request.KorisnikId && x.UslugaId == request.UslugaId) && x.RecenzijaUslugeId != id).FirstOrDefaultAsync();
            var usluge = await _context.Uslugas.Select(x => x.UslugaId).ToListAsync();
            var korisnici = await _context.Korisniks.Where(x => x.KorisnikUlogas.Count() == 0).Select(x => x.KorisnikId).ToListAsync();

            if (korisnik_zaposlenik != null) return false;
            if (recenzija_usluge != null) return false;
            else if (!usluge.Contains(request.UslugaId) || !korisnici.Contains(request.KorisnikId)) return false;
            return true;
        }

        public async Task<List<dynamic>> GetProsjecneOcjeneUsluga()
        {
            var recenzijeUsluga = await _context.RecenzijaUsluges.Include(x=>x.Korisnik.SlikaProfila).Include(x=>x.Usluga).ToListAsync();
            var uslugaIdDistinct = await _context.RecenzijaUsluges.Select(x => x.UslugaId).Distinct().ToListAsync();          
            var prosjecneOcjene_usluge = new List<dynamic>();

            foreach (var index in uslugaIdDistinct)
            {
                string usluga = "";
                double suma = 0.0;
                double prosjek = 0.0;
                int brojac = 0;
                List<int> ocjene = new List<int>();
                foreach (var ru in recenzijeUsluga)
                {
                    if(ru.UslugaId == index)
                    {
                        ocjene.Add(ru.Ocjena);
                        usluga = ru.Usluga.Naziv;
                        suma += ru.Ocjena;
                        brojac++;
                    }                 
                }
                prosjek = suma / brojac;
                var obj = new { uslugaId = index, nazivUsluge = usluga, prosjecnaOcjena = prosjek, sveOcjene = ocjene };
                prosjecneOcjene_usluge.Add(obj);
            }
          
            return prosjecneOcjene_usluge;
        }
    }
}
