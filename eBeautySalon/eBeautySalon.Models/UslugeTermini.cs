using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace eBeautySalon.Models
{
    public class UslugeTermini
    {
        public int UslugaTerminId { get; set; }

        public int UslugaId { get; set; }

        public int TerminId { get; set; }

        public DateTime DatumIzmjene { get; set; }

        public bool? IsPrikazan { get; set; } = true;

        public virtual Termini Termin { get; set; } = null!;

        public virtual Usluge Usluga { get; set; } = null!;
    }
}
