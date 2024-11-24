using AutoMapper;
using eBeautySalon.Models;
using eBeautySalon.Models.Requests;
using eBeautySalon.Models.SearchObjects;
using eBeautySalon.Models.Utils;
using eBeautySalon.Services.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBeautySalon.Services
{
    public class ZaposleniciService : BaseCRUDService<Zaposlenici, Zaposlenik, ZaposleniciSearchObject, ZaposleniciInsertRequest, ZaposleniciUpdateRequest>, IZaposleniciService
    {
        public ZaposleniciService(Ib200070Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Zaposlenik> AddFilter(IQueryable<Zaposlenik> query, ZaposleniciSearchObject? search = null)
        {
            if (!string.IsNullOrWhiteSpace(search?.FTS))
            {
                query = query.Where(x => (x.Korisnik.Ime != null && x.Korisnik.Ime.Contains(search.FTS))
                || (x.Korisnik.Prezime != null && x.Korisnik.Prezime.Contains(search.FTS)
                || (x.Korisnik.KorisnickoIme != null && x.Korisnik.KorisnickoIme.Contains(search.FTS))
                || (x.Korisnik.Sifra != null && x.Korisnik.Sifra.Contains(search.FTS))
                || (x.Korisnik.KorisnikUlogas !=null && x.Korisnik.KorisnikUlogas.Select(y=>y.Uloga.Naziv).Contains(search.FTS))
                || (x.ZaposlenikUslugas != null && x.ZaposlenikUslugas.Select(z => z.Usluga.Naziv).Contains(search.FTS))
               ));
            }
            if(search.isUsluznik == true)
            {
                query = query.Where(x => x.ZaposlenikUslugas.Count() != 0).Include(x=>x.Korisnik.SlikaProfila);
            }
            return base.AddFilter(query, search);
        }
        public override IQueryable<Zaposlenik> AddInclude(IQueryable<Zaposlenik> query, ZaposleniciSearchObject? search = null)
        {
            if (search?.isKorisnikIncluded == true)
            {
                query = query.Include("Korisnik.KorisnikUlogas.Uloga");
                query = query.Include("Korisnik.SlikaProfila");
            }
            if (search?.isUslugeIncluded == true)
            {
                query = query.Include("ZaposlenikUslugas.Usluga");
            }
            return base.AddInclude(query, search);
        }

        public override Task BeforeDelete(Zaposlenik entity)
        {
            var zaposlenikId = entity.ZaposlenikId;
            var korisnikId = entity.KorisnikId;
            var korisnik = _context.Korisniks.First(x => x.KorisnikId == korisnikId);
            var slikaProfilaId =korisnik.SlikaProfilaId;
            var slikaProfila = _context.SlikaProfilas.Where(x => x.SlikaProfilaId == slikaProfilaId).First();
            var korisnik_uloge = _context.KorisnikUlogas.Where(x => x.KorisnikId == korisnikId).ToList();
            var zaposlenik_usluge = _context.ZaposlenikUslugas.Where(x => x.ZaposlenikId == zaposlenikId).ToList();
            var recenzije_usluznika = _context.RecenzijaUsluznikas.Where(x => x.UsluznikId == zaposlenikId).ToList();
          
            foreach(var zu in zaposlenik_usluge)
            {
                _context.Remove(zu); 
            }
            foreach (var ku in korisnik_uloge)
            {
                _context.Remove(ku);
            }
            if (korisnik != null) _context.Remove(korisnik);

            if (slikaProfila != null && slikaProfilaId != Constants.DEFAULT_SlikaProfilaId)
            {
                _context.Remove(slikaProfila);
            }
            foreach (var rec in recenzije_usluznika)
            {
                _context.Remove(rec);
            }
            return base.BeforeDelete(entity);
        }

        public override async Task<bool> AddValidationInsert(ZaposleniciInsertRequest request)
        {
            var zaposlenik = await _context.Zaposleniks.FirstOrDefaultAsync(x => request.KorisnikId == x.KorisnikId); 
            if (zaposlenik == null) return true; else return false;
        }

        public override async Task<bool> AddValidationUpdate(int id, ZaposleniciUpdateRequest request)
        {
            var zaposlenik = await _context.Zaposleniks.FirstOrDefaultAsync(x => request.KorisnikId == x.KorisnikId && x.ZaposlenikId != id);
            if (zaposlenik == null) return true; else return false;
        }
    }
}
