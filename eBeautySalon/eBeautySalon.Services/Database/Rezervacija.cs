using System;
using System.Collections.Generic;

namespace eBeautySalon.Services.Database;

public partial class Rezervacija
{
    public int RezervacijaId { get; set; }

    public int? KorisnikId { get; set; }

    public int? UslugaId { get; set; }

    public int? TerminId { get; set; }

    public DateTime DatumRezervacije { get; set; }

    public int? StatusId { get; set; }

    public bool? IsArhiva { get; set; }

    public string? Sifra { get; set; }

    public virtual Korisnik? Korisnik { get; set; }

    public virtual Status? Status { get; set; }

    public virtual Termin? Termin { get; set; }

    public virtual Usluga? Usluga { get; set; }
}
