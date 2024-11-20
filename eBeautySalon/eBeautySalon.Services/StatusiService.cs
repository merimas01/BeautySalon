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
                query = query.Where(x => x.Opis == "Odbijena" || x.Opis == "Prihvacena");
            }
            return base.AddFilter(query, search);
        }
    }
}
