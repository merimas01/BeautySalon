using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace eBeautySalon.Models.Requests
{
    public class FavoritiUslugeUpdateRequest
    {
        [Required]
        public int? KorisnikId { get; set; }

        [Required]
        public int? UslugaId { get; set; }

        public bool? IsFavorit { get; set; } 

        [JsonIgnore]
        public DateTime? DatumIzmjene { get; set; } = DateTime.Now;

    }
}
