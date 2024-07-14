using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBeautySalon.Models
{
    public class Korisnici
    {
        public int KorisnikId { get; set; }

        public string Ime { get; set; } = null!;

        public string Prezime { get; set; } = null!;

        public string? Email { get; set; }

        public string? Telefon { get; set; }

        public string KorisnickoIme { get; set; } = null!;

        public bool Status { get; set; }

        public int? SlikaProfilaId { get; set; }

        public bool? IsAdmin { get; set; }

        public DateTime? DatumKreiranja { get; set; }

        public DateTime? DatumModifikovanja { get; set; }

        //public virtual ICollection<Komentar> Komentars { get; set; } = new List<Komentar>();

        public virtual ICollection<KorisniciUloge> KorisnikUlogas { get; set; } = new List<KorisniciUloge>();

        //public virtual ICollection<Novost> Novosts { get; set; } = new List<Novost>();

        //public virtual ICollection<Ocjena> Ocjenas { get; set; } = new List<Ocjena>();

        //public virtual ICollection<Rezervacija> Rezervacijas { get; set; } = new List<Rezervacija>();

        //public virtual SlikaProfila? SlikaProfila { get; set; }

        //public virtual Zaposlenik? Zaposlenik { get; set; }
    }
}
