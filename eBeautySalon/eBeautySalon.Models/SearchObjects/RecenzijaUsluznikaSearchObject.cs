using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBeautySalon.Models.SearchObjects
{
    public class RecenzijaUsluznikaSearchObject : BaseSearchObject
    {
        public bool? isKorisnikIncluded { get; set; }
        public bool? isZaposlenikIncluded { get; set; }
    }
}
