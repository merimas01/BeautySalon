using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBeautySalon.Models.SearchObjects
{
    public class FavoritiUslugeSearchObject : BaseSearchObject
    {
        //public bool? isUslugaIncluded {  get; set; }
        //public bool? isKorisnikIncluded { get; set; }
        public int? korisnikId { get; set; }
    }
}
