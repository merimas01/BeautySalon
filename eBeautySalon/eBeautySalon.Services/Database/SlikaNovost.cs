using System;
using System.Collections.Generic;

namespace eBeautySalon.Services.Database;

public partial class SlikaNovost
{
    public int SlikaNovostId { get; set; }

    public byte[]? Slika { get; set; }

    public virtual ICollection<Novost> Novosts { get; set; } = new List<Novost>();
}
