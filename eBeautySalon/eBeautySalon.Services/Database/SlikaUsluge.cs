using System;
using System.Collections.Generic;

namespace eBeautySalon.Services.Database;

public partial class SlikaUsluge
{
    public int SlikaUslugeId { get; set; }

    public byte[]? Slika { get; set; }

    public virtual ICollection<Usluga> Uslugas { get; set; } = new List<Usluga>();
}
