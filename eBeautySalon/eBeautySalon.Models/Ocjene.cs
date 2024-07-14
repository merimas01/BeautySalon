using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBeautySalon.Models
{
    public class Ocjene
    {
        public int OcjenaId { get; set; }

        public string Opis { get; set; } = null!;

        public DateTime DatumKreiranja { get; set; }

        public DateTime? DatumModificiranja { get; set; }

        public int? KorisnikId { get; set; }

        public int? UslugaId { get; set; }

       // public virtual Korisnik? Korisnik { get; set; }

       // public virtual Usluga? Usluga { get; set; }
    }
}
