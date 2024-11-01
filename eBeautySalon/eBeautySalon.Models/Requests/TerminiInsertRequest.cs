using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace eBeautySalon.Models.Requests
{
    public class TerminiInsertRequest
    {
        [Required(AllowEmptyStrings = false, ErrorMessage = "Ovo polje je obavezno.")]
        public string Opis { get; set; } = null!;
    }
}
