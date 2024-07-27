using System;
using System.Collections.Generic;

namespace eBeautySalon.Services.Database;

public partial class RecenzijaUsluznika
{
    public int RecenzijaUsluznikaId { get; set; }

    public int Ocjena { get; set; }

    public string? Komentar { get; set; }

    public DateTime DatumKreiranja { get; set; }

    public DateTime? DatumModificiranja { get; set; }

    public int? KorisnikId { get; set; }

    public int? UsluznikId { get; set; }

    public virtual Korisnik? Korisnik { get; set; }

    public virtual Zaposlenik? Usluznik { get; set; }
}
