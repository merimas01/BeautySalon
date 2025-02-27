using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using eBeautySalon.Models.Requests;
using eBeautySalon.Models.SearchObjects;
using eBeautySalon.Models;
using eBeautySalon.Services.Database;
using AutoMapper;
using Microsoft.EntityFrameworkCore;

namespace eBeautySalon.Services
{
    public class FavoritiUslugeService : BaseCRUDService<Models.FavoritiUsluge, Database.FavoritiUsluge, FavoritiUslugeSearchObject, FavoritiUslugeInsertRequest, FavoritiUslugeUpdateRequest>, IFavoritiUslugeService
    {
        public FavoritiUslugeService(Ib200070Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public override async Task<bool> AddValidationInsert(FavoritiUslugeInsertRequest request)
        {
            var favoriti = await _context.FavoritiUsluges.Where(x => x.KorisnikId == request.KorisnikId && x.UslugaId == request.UslugaId).FirstOrDefaultAsync();

            if (favoriti != null) return false;
            return true;
        }

        public override async Task<bool> AddValidationUpdate(int id, FavoritiUslugeUpdateRequest request)
        {
            //isFavorit moze biti false ili true, ako je false onda znaci da korisnik nema favorita, tako da update nije potreban
            return false;
        }

        public override async Task<Database.FavoritiUsluge> AddIncludeForGetById(IQueryable<Database.FavoritiUsluge> query, int id)
        {
           // query = query.Include(c => c.Usluga);
           // query = query.Include(c => c.Korisnik);
            var entity = await query.FirstOrDefaultAsync(x => x.FavoritId == id);
            return entity;
        }

        public override IQueryable<Database.FavoritiUsluge> AddFilter(IQueryable<Database.FavoritiUsluge> query, FavoritiUslugeSearchObject? search = null)
        {
            if (search.korisnikId != null) {

                query = query.Where(x => x.KorisnikId == search.korisnikId);
            }
            return base.AddFilter(query, search);
        }
    }
}
