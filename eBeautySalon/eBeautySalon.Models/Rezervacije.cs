using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBeautySalon.Models
{
    public class Rezervacije
    {
        public int RezervacijaId { get; set; }

        public int KorisnikId { get; set; }

        public int UslugaId { get; set; }

        public int TerminId { get; set; }

        public DateTime DatumRezervacije { get; set; }

        public int? StatusId { get; set; }

        public bool? IsArhiva { get; set; }

        public string? Sifra { get; set; }

        public bool? IsArhivaKorisnik { get; set; }

        public bool? Platio { get; set; }

        public virtual Korisnici Korisnik { get; set; } = null!;

        public virtual Statusi? Status { get; set; }

        public virtual Termini Termin { get; set; } = null!;

        public virtual Usluge Usluga { get; set; } = null!;

    }
}
