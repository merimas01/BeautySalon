using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace eBeautySalon.Models.Requests
{
    public class UslugeUpdateRequest
    {
        [Required(AllowEmptyStrings = false, ErrorMessage = "Naziv je obavezan.")]
        public string Naziv { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Opis je obavezan.")]
        public string Opis { get; set; } = null!;

        [Required(ErrorMessage = "Cijena je obavezna.")]
        [Range(1, 1000)]
        public decimal Cijena { get; set; }

        public int? SlikaUslugeId { get; set; }

        [Required]
        public int? KategorijaId { get; set; }

        [JsonIgnore]
        public DateTime? DatumModifikovanja { get; set; } = DateTime.Now;
    }
}
