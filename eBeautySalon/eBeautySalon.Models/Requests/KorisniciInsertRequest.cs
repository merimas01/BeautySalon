using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace eBeautySalon.Models.Requests
{
    public class KorisniciInsertRequest
    {
        public string Ime { get; set; } = null!;

        public string Prezime { get; set; } = null!;

        public string? Email { get; set; }

        public string? Telefon { get; set; }

        public string KorisnickoIme { get; set; } = null!;

        [Compare("PasswordPotvrda", ErrorMessage = "Sifre nisu iste.")]
        public string Password { get; set; } = null!;

        [Compare("Password", ErrorMessage = "Sifre nisu iste.")]
        public string PasswordPotvrda { get; set; } = null!;

        public bool Status { get; set; }
        [JsonIgnore]
        public DateTime? DatumKreiranja { get; set; } = DateTime.Now;

        // public int? SlikaProfilaId { get; set; }
        [JsonIgnore]
        public bool? IsAdmin { get; set; } = false;
    }
}
