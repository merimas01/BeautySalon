using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBeautySalon.Models
{
    public class ZaposleniciUsluge
    {
        public int ZaposlenikUslugaId { get; set; }

        public int? ZaposlenikId { get; set; }

        public int? UslugaId { get; set; }

        public DateTime DatumKreiranja { get; set; }

        public DateTime? DatumModificiranja { get; set; }

        public virtual Usluge? Usluga { get; set; }

        //public virtual Zaposlenici? Zaposlenik { get; set; }
    }
}
