using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBeautySalon.Models.SearchObjects
{
    public class KorisniciSearchObject : BaseSearchObject
    {
        public bool? isUlogeIncluded { get; set; }
        public string? Ime { get; set; } = null!;

        public string? Prezime { get; set; } = null!;

        public string? KorisnickoIme { get; set; } = null!;
        public bool? Status { get; set; }
    }
}
