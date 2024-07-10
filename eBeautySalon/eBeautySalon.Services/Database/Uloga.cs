using System;
using System.Collections.Generic;

namespace eBeautySalon.Services.Database;

public partial class Uloga
{
    public int UlogaId { get; set; }

    public string Naziv { get; set; } = null!;

    public string? Opis { get; set; }

    public virtual ICollection<KorisnikUloga> KorisnikUlogas { get; set; } = new List<KorisnikUloga>();
}
