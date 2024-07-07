using eBeautySalon.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBeautySalon.Services
{
    public class UslugeService : IUslugeService
    {
        List<Usluge> usluge = new List<Usluge>()
        {
            new Usluge()
            {
                UslugaId=1,
                Naziv="Tretmani lica"
            }
        };
        public IList<Usluge> Get()
        {
            return usluge;
        }
    }
}
