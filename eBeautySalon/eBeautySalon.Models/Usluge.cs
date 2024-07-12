using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBeautySalon.Models
{
    public class Usluge
    {
        public int UslugaId { get; set; }
        public string Naziv { get; set; }

        public string Opis { get; set; } = null!;

        public decimal Cijena { get; set; }

        public int? SlikaUslugeId { get; set; }

        public int? KategorijaId { get; set; }

        public DateTime? DatumKreiranja { get; set; }

        public DateTime? DatumModifikovanja { get; set; }

        public virtual Kategorije? Kategorija { get; set; }

        //public virtual ICollection<Komentar> Komentars { get; set; } = new List<Komentar>();

        //public virtual ICollection<Ocjena> Ocjenas { get; set; } = new List<Ocjena>();

        //public virtual ICollection<Rezervacija> Rezervacijas { get; set; } = new List<Rezervacija>();

        //public virtual SlikaUsluge? SlikaUsluge { get; set; }

        //public virtual ICollection<ZaposlenikUsluga> ZaposlenikUslugas { get; set; } = new List<ZaposlenikUsluga>();
    }
}
