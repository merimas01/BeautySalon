using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace eBeautySalon.Models.Requests
{
    public class OcjeneInsertRequest
    {
        [Required(ErrorMessage = "Ocjena je obavezna.")]
        [Range(1,10)]
        public int? Opis { get; set; }

        [JsonIgnore]
        public DateTime DatumKreiranja { get; set; } = DateTime.Now;

        [Required]
        public int? KorisnikId { get; set; }

        [Required]
        public int? UslugaId { get; set; }
    }
}
