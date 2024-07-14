using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBeautySalon.Models
{
    public class Kategorije
    {
        public int KategorijaId { get; set; }

        public string Naziv { get; set; } = null!;

        public string? Opis { get; set; }

        public DateTime DatumKreiranja { get; set; }

        public DateTime? DatumModifikovanja { get; set; }

      //  public virtual ICollection<Usluge> Uslugas { get; set; } = new List<Usluge>();
    }
}
