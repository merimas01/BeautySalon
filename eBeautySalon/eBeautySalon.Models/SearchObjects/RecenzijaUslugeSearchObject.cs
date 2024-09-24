using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBeautySalon.Models.SearchObjects
{
    public class RecenzijaUslugeSearchObject : BaseSearchObject
    {
        public bool? isUslugeIncluded { get; set; }
        public bool? isKorisnikIncluded { get; set; }
    }
}
