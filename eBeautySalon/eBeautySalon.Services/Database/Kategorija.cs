using System;
using System.Collections.Generic;

namespace eBeautySalon.Services.Database;

public partial class Kategorija
{
    public int KategorijaId { get; set; }

    public string Naziv { get; set; } = null!;

    public string? Opis { get; set; }

    public DateTime DatumKreiranja { get; set; }

    public DateTime? DatumModifikovanja { get; set; }

    public virtual ICollection<Usluga> Uslugas { get; set; } = new List<Usluga>();
}
