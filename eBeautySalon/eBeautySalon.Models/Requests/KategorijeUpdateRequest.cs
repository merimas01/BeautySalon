using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace eBeautySalon.Models.Requests
{
    public class KategorijeUpdateRequest
    {
        [Required(AllowEmptyStrings = false, ErrorMessage = "Polje Naziv je obavezno")]
        public string Naziv { get; set; } = null!;

        public string? Opis { get; set; }

        [JsonIgnore]
        public DateTime? DatumModifikovanja { get; set; } = DateTime.Now;
    }
}
