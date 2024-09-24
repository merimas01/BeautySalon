using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBeautySalon.Models.SearchObjects
{
    public class NovostiSearchObject : BaseSearchObject
    {
        public string? FTS { get; set; }
        public string? Naslov { get; set; } = null!;

        public string? Sadrzaj { get; set; } = null!;

        public bool? isSlikaIncluded { get; set; }
        
        public bool? isKorisnikIncluded { get; set; }   

        //public DateTime? DatumKreiranja { get; set; }

        //public DateTime? DatumModificiranja { get; set; }

    }
}
