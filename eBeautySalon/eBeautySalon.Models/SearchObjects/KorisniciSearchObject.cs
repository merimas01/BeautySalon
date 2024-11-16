using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBeautySalon.Models.SearchObjects
{
    public class KorisniciSearchObject : BaseSearchObject
    {
        public string? FTS { get; set; }
        public string? isBlokiran { get; set; }

        public bool? isAdmin { get; set; }
        public bool? isZaposlenik { get; set; }
        
        public bool? isUlogeIncluded { get; set; }
        
        public bool? isSlikaIncluded { get; set; }
   
        public bool? Status { get; set; }
   
        public string? Ime { get; set; } = null!;

        public string? Prezime { get; set; } = null!;

        public string? KorisnickoIme { get; set; } = null!;
       
    }
}
