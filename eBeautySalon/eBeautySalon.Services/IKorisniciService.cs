using eBeautySalon.Models;
using eBeautySalon.Models.Requests;
using eBeautySalon.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBeautySalon.Services
{
    public interface IKorisniciService
    {
        List<Korisnici> Get();
        Korisnici Insert(KorisniciInsertRequest request);
        Korisnici Update(int id, KorisniciUpdateRequest request);
    }
}
