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
    public class SlikaNovostiService : BaseCRUDService<SlikaNovosti, SlikaNovost, BaseSearchObject, SlikaNovostiInsertRequest, SlikaNovostiUpdateRequest>, ISlikaNovostiService
    {
        public SlikaNovostiService(Ib200070Context context, IMapper mapper) : base(context, mapper)
        {
        }
        public override Task BeforeDelete(SlikaNovost entity)
        {
            var novosti = _context.Novosts.Where(x => x.SlikaNovostId == entity.SlikaNovostId).ToList();
            var firstImageId = _context.SlikaNovosts.Select(x => x.SlikaNovostId).First(); //DEFAULT_SlikaNovostId

            if (firstImageId != null)
            {
                foreach (var novost in novosti)
                {
                    novost.SlikaNovostId = firstImageId;
                }
            }
            return base.BeforeDelete(entity);
        }

        public override async Task<SlikaNovost> AddIncludeForGetById(IQueryable<SlikaNovost> query, int id)
        {
            var entity = await query.FirstOrDefaultAsync(x => x.SlikaNovostId == id);
            return entity;
        }
    }
}
