using System;
using System.Collections.Generic;

namespace eBeautySalon.Services.Database;

public partial class SlikaProfila
{
    public int SlikaProfilaId { get; set; }

    public byte[]? Slika { get; set; }

    public virtual ICollection<Korisnik> Korisniks { get; set; } = new List<Korisnik>();
}
