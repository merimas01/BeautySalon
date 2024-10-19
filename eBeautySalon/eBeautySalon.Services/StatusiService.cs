using AutoMapper;
using eBeautySalon.Models;
using eBeautySalon.Models.SearchObjects;
using eBeautySalon.Services.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory;

namespace eBeautySalon.Services
{
    public class StatusiService : BaseService<Models.Statusi, Database.Status, BaseSearchObject>, IStatusService
    {
        public StatusiService(Ib200070Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public async Task<PagedResult<Statusi>> GetStatuse(BaseSearchObject search)
        {
            var query = _context.Statuses.Where(x => x.Opis != "Nova" || x.Opis != "Otkazana").AsQueryable();

            PagedResult<Statusi> result = new PagedResult<Statusi>();

            result.Count = await query.CountAsync();

            if (search?.Page.HasValue == true && search?.PageSize.HasValue == true)
            {
                query = query.Take(search.PageSize.Value).Skip(search.Page.Value * search.PageSize.Value);
            }
            var list = await query.ToListAsync();

            var tmp = _mapper.Map<List<Statusi>>(list);

            result.Result = tmp;

            return result;
        }
    }
}
