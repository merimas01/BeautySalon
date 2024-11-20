using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBeautySalon.Models.SearchObjects
{
    public class RezervacijeSearchObject : BaseSearchObject
    {
        public String? FTS { get; set; }
        public int? StatusId { get; set; }
        public string? isArhiva { get; set; }
        public bool? isKorisnikIncluded { get; set; }
        public bool? isUslugaIncluded { get; set; }
        public bool? isTerminIncluded { get; set; }
        public bool? isStatusIncluded { get; set; }
    }
}
