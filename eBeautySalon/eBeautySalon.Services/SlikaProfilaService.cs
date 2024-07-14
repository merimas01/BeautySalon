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
    public class SlikaProfilaService : BaseCRUDService<Models.SlikaProfila, Database.SlikaProfila, BaseSearchObject, SlikaProfilaInsertRequest, SlikaProfilaUpdateRequest>, ISlikaProfilaService
    {
        public SlikaProfilaService(BeautySalonContext context, IMapper mapper) : base(context, mapper)
        {
        }
    }
}
