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
    public class SlikaProfilaService : BaseCRUDService<Models.SlikaProfila, Database.SlikaProfila, BaseSearchObject, SlikaProfilaInsertRequest, SlikaProfilaUpdateRequest>, ISlikaProfilaService
    {
        public SlikaProfilaService(Ib200070Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public override Task BeforeDelete(SlikaProfila entity)
        {
            var korisnici = _context.Korisniks.Where(x => x.SlikaProfilaId == entity.SlikaProfilaId).ToList();
            var firstImageId = _context.SlikaProfilas.Select(x => x.SlikaProfilaId).First(); //DEFAULT_SlikaProfilaId

            if (firstImageId != null)
            {
                foreach (var korisnik in korisnici)
                {
                    korisnik.SlikaProfilaId = firstImageId;
                }
            }

            return base.BeforeDelete(entity);
        }

        public override async Task<SlikaProfila> AddIncludeForGetById(IQueryable<SlikaProfila> query, int id)
        {
            var entity = await query.FirstOrDefaultAsync(x => x.SlikaProfilaId == id);
            return entity;
        }
    }
}
