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
    public class KomentariService : BaseCRUDService<Komentari, Komentar, BaseSearchObject, KomentariInsertRequest, KomentariUpdateRequest>, IKomentariService
    {
        public KomentariService(BeautySalonContext context, IMapper mapper) : base(context, mapper)
        {      
        }

    }
}
