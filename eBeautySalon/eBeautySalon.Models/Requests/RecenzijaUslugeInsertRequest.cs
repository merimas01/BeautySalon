using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace eBeautySalon.Models.Requests
{
    public class RecenzijaUslugeInsertRequest
    {
        [Required(ErrorMessage = "Ocjena je obavezna: 1-5.")]
        [Range(1,5)]
        public int Ocjena { get; set; }

        public string? Komentar { get; set; }

        [JsonIgnore]
        public DateTime DatumKreiranja { get; set; } = DateTime.Now;

        [Required]
        public int KorisnikId { get; set; }

        [Required]
        public int UslugaId { get; set; }
    }
}
