using System;
using System.Collections.Generic;

namespace eBeautySalon.Services.Database;

public partial class UslugaTermin
{
    public int UslugaTerminId { get; set; }

    public int UslugaId { get; set; }

    public int TerminId { get; set; }

    public DateTime DatumIzmjene { get; set; }

    public bool? IsPrikazan { get; set; }

    public virtual Termin Termin { get; set; } = null!;

    public virtual Usluga Usluga { get; set; } = null!;
}
