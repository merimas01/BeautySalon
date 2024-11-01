using AutoMapper;
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

        public override IQueryable<RecenzijaUsluge> AddFilter(IQueryable<RecenzijaUsluge> query, RecenzijaUslugeSearchObject? search = null)
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
        public override IQueryable<RecenzijaUsluge> AddInclude(IQueryable<RecenzijaUsluge> query, RecenzijaUslugeSearchObject? search = null)
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
    }
}
