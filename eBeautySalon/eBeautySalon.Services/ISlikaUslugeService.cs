using eBeautySalon.Models.Requests;
using eBeautySalon.Models.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBeautySalon.Services
{
    public interface ISlikaUslugeService : ICRUDService<Models.SlikaUsluge, BaseSearchObject, SlikaUslugeInsertRequest, SlikaUslugeUpdateRequest>
    {
    }
}
