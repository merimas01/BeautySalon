using System;
using System.Collections.Generic;

namespace eBeautySalon.Services.Database;

public partial class Usluga
{
    public int UslugaId { get; set; }

    public string Naziv { get; set; } = null!;

    public string Opis { get; set; } = null!;

    public decimal Cijena { get; set; }

    public int? SlikaUslugeId { get; set; }

    public int? KategorijaId { get; set; }

    public DateTime? DatumKreiranja { get; set; }

    public DateTime? DatumModifikovanja { get; set; }

    public virtual Kategorija? Kategorija { get; set; }

    public virtual ICollection<RecenzijaUsluge> RecenzijaUsluges { get; set; } = new List<RecenzijaUsluge>();

    public virtual ICollection<Rezervacija> Rezervacijas { get; set; } = new List<Rezervacija>();

    public virtual SlikaUsluge? SlikaUsluge { get; set; }

    public virtual ICollection<ZaposlenikUsluga> ZaposlenikUslugas { get; set; } = new List<ZaposlenikUsluga>();
}
