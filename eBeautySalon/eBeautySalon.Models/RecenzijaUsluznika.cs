using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBeautySalon.Models
{
    public class RecenzijaUsluznika
    {
        public int RecenzijaUsluznikaId { get; set; }

        public int Ocjena { get; set; }

        public string? Komentar { get; set; }

        public DateTime DatumKreiranja { get; set; }

        public DateTime? DatumModificiranja { get; set; }

        public int? KorisnikId { get; set; }

        public int? UsluznikId { get; set; }

        public virtual Korisnici? Korisnik { get; set; }

        public virtual Zaposlenici? Usluznik { get; set; }
    }
}
