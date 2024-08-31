using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBeautySalon.Models.SearchObjects
{
    public class KategorijeSearchObject : BaseSearchObject
    {
        public string? FTS { get; set; }
        public string? Naziv { get; set; }
        public string? Opis { get; set; }
        
        //public bool? isUslugeIncluded { get; set; }
    }
}
