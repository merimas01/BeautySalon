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
        public SlikaUslugeService(BeautySalonContext context, IMapper mapper) : base(context, mapper)
        {
        }
    }
}
