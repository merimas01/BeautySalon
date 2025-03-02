using System;
using System.Collections.Generic;

namespace eBeautySalon.Services.Database;

public partial class ZaposlenikUsluga
{
    public int ZaposlenikUslugaId { get; set; }

    public int ZaposlenikId { get; set; }

    public int UslugaId { get; set; }

    public DateTime DatumKreiranja { get; set; }

    public DateTime? DatumModificiranja { get; set; }

    public virtual Usluga Usluga { get; set; } = null!;

    public virtual Zaposlenik Zaposlenik { get; set; } = null!;
}
