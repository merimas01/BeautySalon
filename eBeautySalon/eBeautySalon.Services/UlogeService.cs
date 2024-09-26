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
        public UlogeService(IB200070Context context, IMapper mapper) : base(context, mapper)
        {
        }
    }
}
