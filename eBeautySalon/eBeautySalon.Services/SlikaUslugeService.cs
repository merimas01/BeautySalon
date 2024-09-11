using AutoMapper;
using eBeautySalon.Models.Requests;
using eBeautySalon.Models.SearchObjects;
using eBeautySalon.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBeautySalon.Services
{
    public class SlikaUslugeService : BaseCRUDService<Models.SlikaUsluge, Database.SlikaUsluge, BaseSearchObject, SlikaUslugeInsertRequest, SlikaUslugeUpdateRequest>, ISlikaUslugeService
    {
        public SlikaUslugeService(IB200070Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public override Task BeforeDelete(SlikaUsluge entity)
        {
            var uslugas = _context.Uslugas.Where(x => x.SlikaUslugeId == entity.SlikaUslugeId).ToList();
            var firstImageId = _context.SlikaUsluges.Select(x => x.SlikaUslugeId).First(); //DEFAULT_SlikaUslugeId

            if (firstImageId != null)
            {
                foreach (var usluga in uslugas)
                {
                    usluga.SlikaUslugeId = firstImageId;
                }
            }
            
            return base.BeforeDelete(entity);
        }
    }
}
