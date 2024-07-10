using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace eBeautySalon.Models.Requests
{
    public class KorisniciUpdateRequest
    {
        public string Ime { get; set; } = null!;
        public string Prezime { get; set; } = null!;
        public string? Telefon { get; set; }
        public bool? Status { get; set; }
        [JsonIgnore]
        public DateTime? DatumModifikovanja { get; set; } = DateTime.Now;
    }
}
