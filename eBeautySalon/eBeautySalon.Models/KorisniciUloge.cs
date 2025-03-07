﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBeautySalon.Models
{
    public class KorisniciUloge
    {
        public int KorisnikUlogaId { get; set; }

        public int KorisnikId { get; set; }

        public int UlogaId { get; set; }

        public DateTime DatumIzmjene { get; set; }

        //public virtual Korisnik Korisnik { get; set; } = null!; - nepotrebno jer ucitavamo iz korisnika

        public virtual Uloge Uloga { get; set; } = null!;
    }
}
