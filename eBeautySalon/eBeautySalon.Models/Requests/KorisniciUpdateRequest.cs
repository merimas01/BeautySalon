using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace eBeautySalon.Models.Requests
{
    public class KorisniciUpdateRequest
    {

        [Required(AllowEmptyStrings = false, ErrorMessage = "Polje Ime je obavezno")]
        public string Ime { get; set; } = null!;

        [Required(AllowEmptyStrings = false, ErrorMessage = "Polje Prezime je obavezno")]
        public string Prezime { get; set; } = null!;

        public string? Email { get; set; }

        public string? Telefon { get; set; }

        public bool? Status { get; set; } = true;

        public int? SlikaProfilaId { get; set; }
        
        [JsonIgnore]
        public DateTime? DatumModifikovanja { get; set; } = DateTime.Now;
    }
}
