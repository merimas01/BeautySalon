using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace eBeautySalon.Models.Requests
{
    public class RezervacijeInsertRequest
    {
        [Required]
        public int? KorisnikId { get; set; }

        [Required]
        public int? UslugaId { get; set; }

        [Required]
        public int? TerminId { get; set; }

        [Required(ErrorMessage = "Datum je obavezan.")]
        public DateTime DatumRezervacije { get; set; }

        [JsonIgnore]
        public int? StatusId { get; set; }

        [JsonIgnore]
        public bool? IsArhiva { get; set; } = false;

        [JsonIgnore]
        public bool? IsArhivaKorisnik { get; set; } = false;

        [JsonIgnore]
        public bool? Platio { get; set; } = false;

    }
}
