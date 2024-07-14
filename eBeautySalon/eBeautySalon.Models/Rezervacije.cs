﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBeautySalon.Models
{
    public class Rezervacije
    {
        public int RezervacijaId { get; set; }

        public int? KorisnikId { get; set; }

        public int? UslugaId { get; set; }

        public int? TerminId { get; set; }

        public DateTime DatumRezervacije { get; set; }

        //public virtual Korisnik? Korisnik { get; set; }

        //public virtual Termin? Termin { get; set; }

        //public virtual Usluga? Usluga { get; set; }
    }
}
