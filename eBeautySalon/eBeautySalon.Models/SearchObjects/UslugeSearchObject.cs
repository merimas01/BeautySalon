using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBeautySalon.Models.SearchObjects
{
    public class UslugeSearchObject : BaseSearchObject
    {
        public string? FTS { get; set; } //full text search
        public int? KategorijaId { get; set; }
        public string? Naziv { get; set; }

        public string? Opis { get; set; } = null!;

        public decimal? Cijena { get; set; }

        public bool? isKategorijaIncluded { get; set; } 
        public bool? isSlikaIncluded { get; set; }

    }
}
