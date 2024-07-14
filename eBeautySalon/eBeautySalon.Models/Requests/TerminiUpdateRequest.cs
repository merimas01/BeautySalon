using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBeautySalon.Models.Requests
{
    public class TerminiUpdateRequest
    {
        [Required(AllowEmptyStrings = false, ErrorMessage = "Ovo polje je obavezno.")]
        public string Opis { get; set; } = null!;
    }
}
