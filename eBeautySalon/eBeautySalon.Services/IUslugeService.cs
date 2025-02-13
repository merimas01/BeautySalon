using eBeautySalon.Models;
using eBeautySalon.Models.Requests;
using eBeautySalon.Models.SearchObjects;
using Microsoft.EntityFrameworkCore.SqlServer.Query.Internal;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBeautySalon.Services
{
    public interface IUslugeService : ICRUDService<Usluge, UslugeSearchObject, UslugeInsertRequest, UslugeUpdateRequest>
    {
        Task<List<Models.Usluge>> Recommend(int uslugaId, int korisnikId);
    }
}
