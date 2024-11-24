using System;
using System.Collections.Generic;

namespace eBeautySalon.Services.Database;

public partial class Termin
{
    public int TerminId { get; set; }

    public string Opis { get; set; } = null!;

    public string? Sifra { get; set; }

    public virtual ICollection<Rezervacija> Rezervacijas { get; set; } = new List<Rezervacija>();

    public virtual ICollection<UslugaTermin> UslugaTermins { get; set; } = new List<UslugaTermin>();
}
