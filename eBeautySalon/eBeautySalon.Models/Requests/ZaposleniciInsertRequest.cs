using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace eBeautySalon.Models.Requests
{
    public class ZaposleniciInsertRequest
    {
        [Required]
        public DateTime DatumRodjenja { get; set; }

        [Required]
        public DateTime DatumZaposlenja { get; set; }

        [Required]
        public int? KorisnikId { get; set; }

        [JsonIgnore]
        public DateTime? DatumKreiranja { get; set; } = DateTime.Now;

    }
}
