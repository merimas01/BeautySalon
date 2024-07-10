using System;
using System.Collections.Generic;

namespace eBeautySalon.Services.Database;

public partial class Zaposlenik
{
    public int KorisnikId { get; set; }

    public DateTime DatumRodjenja { get; set; }

    public DateTime DatumZaposlenja { get; set; }

    public DateTime? DatumOtkaza { get; set; }

    public virtual Korisnik Korisnik { get; set; } = null!;

    public virtual ICollection<ZaposlenikUsluga> ZaposlenikUslugas { get; set; } = new List<ZaposlenikUsluga>();
}
