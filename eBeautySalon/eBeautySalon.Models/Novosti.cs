using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBeautySalon.Models
{
    public class Novosti
    {
        public int NovostId { get; set; }

        public string Naslov { get; set; } = null!;

        public string Sadrzaj { get; set; } = null!;

        public DateTime? DatumKreiranja { get; set; }

        public DateTime? DatumModificiranja { get; set; }

        public int? KorisnikId { get; set; }

        public int? SlikaNovostId { get; set; }

        //public virtual Korisnik? Korisnik { get; set; }

        //public virtual SlikaNovost? SlikaNovost { get; set; }
    }
}
