using eBeautySalon.Models.Requests;
using eBeautySalon.Models.SearchObjects;
using eBeautySalon.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBeautySalon.Services
{
    public interface IKorisniciUlogeService : ICRUDService<KorisniciUloge, KorisniciUlogeSearchObject, KorisniciUlogeInsertRequest, KorisniciUlogeUpdateRequest>
    {
    }
}
