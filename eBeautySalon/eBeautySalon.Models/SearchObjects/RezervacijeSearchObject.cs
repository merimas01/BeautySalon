using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBeautySalon.Models.SearchObjects
{
    public class RezervacijeSearchObject : BaseSearchObject
    {
        public bool? isKorisnikIncluded { get; set; }
        public bool? isUslugaIncluded { get; set; }
        public bool? isTerminIncluded { get; set; }
    }
}
