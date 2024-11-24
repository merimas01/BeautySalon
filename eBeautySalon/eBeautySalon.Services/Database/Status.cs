using System;
using System.Collections.Generic;

namespace eBeautySalon.Services.Database;

public partial class Status
{
    public int StatusId { get; set; }

    public string? Opis { get; set; }

    public string? Sifra { get; set; }

    public virtual ICollection<Rezervacija> Rezervacijas { get; set; } = new List<Rezervacija>();
}
