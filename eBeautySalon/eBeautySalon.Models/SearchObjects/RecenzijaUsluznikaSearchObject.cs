using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBeautySalon.Models.SearchObjects
{
    public class RecenzijaUsluznikaSearchObject : BaseSearchObject
    {
        public string? FTS { get; set; }
        public int ? UsluznikId { get; set; }
        public int? KorisnikId { get; set; }
        public int? UslugaId { get; set; }
        public bool? isKorisnikIncluded { get; set; }
        public bool? isZaposlenikIncluded { get; set; }
    }
}
