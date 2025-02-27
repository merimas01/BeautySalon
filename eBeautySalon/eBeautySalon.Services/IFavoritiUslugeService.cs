using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using eBeautySalon.Models.Requests;
using eBeautySalon.Models.SearchObjects;
using eBeautySalon.Models;

namespace eBeautySalon.Services
{
    public interface IFavoritiUslugeService : ICRUDService<Models.FavoritiUsluge, FavoritiUslugeSearchObject, FavoritiUslugeInsertRequest, FavoritiUslugeUpdateRequest>
    {
    }
}
