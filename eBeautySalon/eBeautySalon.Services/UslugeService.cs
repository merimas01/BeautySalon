using eBeautySalon.Models;
using eBeautySalon.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBeautySalon.Services
{
    public class UslugeService : IUslugeService
    {
        BeautySalonContext context;
        public UslugeService(BeautySalonContext context) {
            this.context = context;
        }
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
           // var list = context.Uslugas.ToList();
            return usluge;
        }
    }
}
