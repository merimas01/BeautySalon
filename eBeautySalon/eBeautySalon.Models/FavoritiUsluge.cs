using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBeautySalon.Models
{
    public class FavoritiUsluge
    {
        public int FavoritId { get; set; }

        public int? KorisnikId { get; set; }

        public bool? IsFavorit { get; set; }

        public DateTime? DatumIzmjene { get; set; }

        public int? UslugaId { get; set; }

        //public virtual Korisnici? Korisnik { get; set; }

        //public virtual Usluge? Usluga { get; set; }
    }
}
