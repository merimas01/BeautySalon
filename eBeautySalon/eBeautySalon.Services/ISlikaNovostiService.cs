using eBeautySalon.Models.Requests;
using eBeautySalon.Models;
using eBeautySalon.Models.SearchObjects;
using eBeautySalon.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBeautySalon.Services
{
    public interface ISlikaNovostiService : ICRUDService<SlikaNovosti,BaseSearchObject,SlikaNovostiInsertRequest,SlikaNovostiUpdateRequest>
    {
    }
}
