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

namespace eBeautySalon.Services
{
    public class UlogeService : BaseCRUDService<Uloge, Uloga, BaseSearchObject, UlogeInsertRequest, UlogeUpdateRequest>, IUlogeService
    {
        public UlogeService(Ib200070Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Uloga> AddFilter(IQueryable<Uloga> query, BaseSearchObject? search = null)
        {
            query = query.Where(x => x.Naziv != "Administrator");
            return base.AddFilter(query, search);
        }
    }
}
