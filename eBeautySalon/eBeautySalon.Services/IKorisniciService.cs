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
    public interface IKorisniciService : ICRUDService<Korisnici, KorisniciSearchObject, KorisniciInsertRequest,KorisniciUpdateRequest>
    {
        public Task<Korisnici> Login(string username, string password);
    }
}
