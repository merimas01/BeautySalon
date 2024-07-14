using AutoMapper;
using eBeautySalon.Models;
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
    public class OcjeneService : BaseCRUDService<Ocjene, Ocjena, BaseSearchObject, OcjeneInsertRequest, OcjeneUpdateRequest>, IOcjeneService
    {
        public OcjeneService(BeautySalonContext context, IMapper mapper) : base(context, mapper)
        {
        }
    }
}
