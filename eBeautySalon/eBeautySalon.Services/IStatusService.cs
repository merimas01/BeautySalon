using eBeautySalon.Models;
using eBeautySalon.Models.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBeautySalon.Services
{
    public interface IStatusService : IService<Models.Statusi, BaseSearchObject>
    {
        Task<PagedResult<Statusi>> GetStatuse(BaseSearchObject search);
    }
}
