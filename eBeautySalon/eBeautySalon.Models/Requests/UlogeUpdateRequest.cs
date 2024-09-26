using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBeautySalon.Models.Requests
{
    public class UlogeUpdateRequest
    {
        [Required]
        public string Naziv { get; set; }

        public string? Opis { get; set; }
    }
}
