using System;
using System.Collections.Generic;

namespace eBeautySalon.Services.Database;

public partial class Zaposlenik
{
    public int ZaposlenikId { get; set; }

    public DateTime DatumRodjenja { get; set; }

    public DateTime DatumZaposlenja { get; set; }

    public int? KorisnikId { get; set; }

    public DateTime? DatumKreiranja { get; set; }

    public DateTime? DatumModifikovanja { get; set; }

    public string? Biografija { get; set; }

    public virtual Korisnik? Korisnik { get; set; }

    public virtual ICollection<RecenzijaUsluznika> RecenzijaUsluznikas { get; set; } = new List<RecenzijaUsluznika>();

    public virtual ICollection<ZaposlenikUsluga> ZaposlenikUslugas { get; set; } = new List<ZaposlenikUsluga>();
}
