using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBeautySalon.Models.Requests
{
    public class RezervacijeUpdateRequest
    {
        [Required]
        public int? KorisnikId { get; set; }

        [Required]
        public int? UslugaId { get; set; }

        [Required]
        public int? TerminId { get; set; }

        [Required(ErrorMessage = "Datum je obavezan.")]
        public DateTime DatumRezervacije { get; set; }

        [Required]
        public int? StatusId { get; set; }
    }
}
