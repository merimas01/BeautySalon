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
    public class NovostiInsertRequest
    {
        [Required(AllowEmptyStrings = false, ErrorMessage = "Polje Naslov je obavezno")]
        public string Naslov { get; set; } = null!;

        [Required(AllowEmptyStrings = false, ErrorMessage = "Polje Sadrzaj je obavezno")]
        public string Sadrzaj { get; set; } = null!;

        [JsonIgnore]
        public DateTime? DatumKreiranja { get; set; } = DateTime.Now;

        [DefaultValue(1)]
        public int? SlikaNovostId { get; set; }

    }
}
