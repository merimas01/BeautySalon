using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace eBeautySalon.Models.Requests
{
    public class FavoritiUslugeInsertRequest
    {
        [Required]
        public int? KorisnikId { get; set; }

        [Required]
        public int? UslugaId { get; set; }

        [JsonIgnore]
        public bool? IsFavorit { get; set; } = true;

        [JsonIgnore]
        public DateTime? DatumIzmjene { get; set; } = DateTime.Now;

    }
}
