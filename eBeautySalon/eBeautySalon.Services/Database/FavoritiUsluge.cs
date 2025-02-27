using System;
using System.Collections.Generic;

namespace eBeautySalon.Services.Database;

public partial class FavoritiUsluge
{
    public int FavoritId { get; set; }

    public int? KorisnikId { get; set; }

    public bool? IsFavorit { get; set; }

    public DateTime? DatumIzmjene { get; set; }

    public int? UslugaId { get; set; }

    public virtual Korisnik? Korisnik { get; set; }

    public virtual Usluga? Usluga { get; set; }
}
