using eBeautySalon.Models.Requests;
using eBeautySalon.Models.SearchObjects;
using eBeautySalon.Models;
using eBeautySalon.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AutoMapper;
using Microsoft.EntityFrameworkCore;

namespace eBeautySalon.Services
{
    public class KorisniciUlogeService : BaseCRUDService<KorisniciUloge, KorisnikUloga, KorisniciUlogeSearchObject, KorisniciUlogeInsertRequest, KorisniciUlogeUpdateRequest>, IKorisniciUlogeService
    {
        public KorisniciUlogeService(Ib200070Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<KorisnikUloga> AddInclude(IQueryable<KorisnikUloga> query, KorisniciUlogeSearchObject? search = null)
        {
            if(search?.isUlogeIncluded == true)
            {
                query = query.Include(x => x.Uloga);
            }
           
            return base.AddInclude(query, search);
        }

        public override async Task<KorisnikUloga> AddIncludeForGetById(IQueryable<KorisnikUloga> query, int id)
        {
            query = query.Include(x => x.Uloga);
            query = query.Include(x => x.Korisnik);
            var entity = await query.FirstOrDefaultAsync(x => x.KorisnikUlogaId == id);
            return entity;
        }
    }
}
