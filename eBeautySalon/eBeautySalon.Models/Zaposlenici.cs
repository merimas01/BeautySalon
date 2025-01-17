using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBeautySalon.Models
{
    public class Zaposlenici
    {
        public int ZaposlenikId { get; set; }

        public DateTime DatumRodjenja { get; set; }

        public DateTime DatumZaposlenja { get; set; }

        public int? KorisnikId { get; set; }

        public DateTime? DatumKreiranja { get; set; }

        public DateTime? DatumModifikovanja { get; set; }

        public virtual Korisnici? Korisnik { get; set; }

        public string? Biografija { get; set; }

        public virtual ICollection<ZaposleniciUsluge> ZaposlenikUslugas { get; set; } = new List<ZaposleniciUsluge>();
    }
}
