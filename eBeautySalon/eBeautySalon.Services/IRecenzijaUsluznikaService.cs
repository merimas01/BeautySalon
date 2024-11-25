using eBeautySalon.Models;
using eBeautySalon.Models.Requests;
using eBeautySalon.Models.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBeautySalon.Services
{
    public interface IRecenzijaUsluznikaService : ICRUDService<Models.RecenzijaUsluznika, RecenzijaUsluznikaSearchObject, RecenzijaUsluznikaInsertRequest, RecenzijaUsluznikaUpdateRequest>
    {
        public Task<List<dynamic>> GetProsjecneOcjeneUsluznika();

        public Task<PagedResult<Models.RecenzijaUsluznika>> GetRecenzijeUsluznikaByKorisnikId(int korisnikId, string? FTS);
    }
}
