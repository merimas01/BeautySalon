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
    public class StatusiService : BaseService<Models.Statusi, Database.Status, StatusiSearchObject>, IStatusService
    {
        public StatusiService(Ib200070Context context, IMapper mapper) : base(context, mapper)
        {
        }
        public override IQueryable<Status> AddFilter(IQueryable<Status> query, StatusiSearchObject? search = null)
        {
            if (search.promijeniStatus == true)
            {
                query = query.Where(x => x.Opis == "Odbijena" || x.Opis == "Prihvaćena");
            }
            return base.AddFilter(query, search);
        }

        public override async Task<Status> AddIncludeForGetById(IQueryable<Status> query, int id)
        {
            var entity = await query.FirstOrDefaultAsync(x => x.StatusId == id);
            return entity;
        }

    }
}
