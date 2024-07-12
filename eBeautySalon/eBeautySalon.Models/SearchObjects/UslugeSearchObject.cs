using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBeautySalon.Models.SearchObjects
{
    public class UslugeSearchObject : BaseSearchObject
    {
        public string? Naziv { get; set; }

        public string? Opis { get; set; } = null!;

        public decimal? Cijena { get; set; }

    }
}
