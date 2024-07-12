using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace eBeautySalon.Models.Requests
{
    public class UslugeInsertRequest
    {
        public string Naziv { get; set; }

        public string Opis { get; set; } = null!;

        public decimal Cijena { get; set; }

       // public int? SlikaUslugeId { get; set; }

        public int? KategorijaId { get; set; }

        [JsonIgnore]
        public DateTime? DatumKreiranja { get; set; } = DateTime.Now;

    }
}
