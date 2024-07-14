using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace eBeautySalon.Models.Requests
{
    public class KomentariInsertRequest
    {
        [Required(AllowEmptyStrings = false, ErrorMessage = "Polje Opis je obavezno")]
        public string Opis { get; set; } = null!;

        [JsonIgnore]
        public DateTime DatumKreiranja { get; set; } = DateTime.Now;

        [Required]
        public int? KorisnikId { get; set; }

        [Required]
        public int? UslugaId { get; set; }

    }
}
