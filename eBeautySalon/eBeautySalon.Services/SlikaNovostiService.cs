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
    public class SlikaNovostiService : BaseCRUDService<SlikaNovosti, SlikaNovost, BaseSearchObject, SlikaNovostiInsertRequest, SlikaNovostiUpdateRequest>, ISlikaNovostiService
    {
        public SlikaNovostiService(Ib200070Context context, IMapper mapper) : base(context, mapper)
        {
        }
    }
}
