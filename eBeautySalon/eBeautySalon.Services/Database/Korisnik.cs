using System;
using System.Collections.Generic;

namespace eBeautySalon.Services.Database;

public partial class Korisnik
{
    public int KorisnikId { get; set; }

    public string Ime { get; set; } = null!;

    public string Prezime { get; set; } = null!;

    public string? Email { get; set; }

    public string? Telefon { get; set; }

    public string KorisnickoIme { get; set; } = null!;

    public string LozinkaHash { get; set; } = null!;

    public string LozinkaSalt { get; set; } = null!;

    public bool Status { get; set; }

    public int? SlikaProfilaId { get; set; }

    public bool? IsAdmin { get; set; }

    public DateTime? DatumKreiranja { get; set; }

    public DateTime? DatumModifikovanja { get; set; }

    public string? Sifra { get; set; }

    public virtual ICollection<KorisnikUloga> KorisnikUlogas { get; set; } = new List<KorisnikUloga>();

    public virtual ICollection<Novost> Novosts { get; set; } = new List<Novost>();

    public virtual ICollection<RecenzijaUsluge> RecenzijaUsluges { get; set; } = new List<RecenzijaUsluge>();

    public virtual ICollection<RecenzijaUsluznika> RecenzijaUsluznikas { get; set; } = new List<RecenzijaUsluznika>();

    public virtual ICollection<Rezervacija> Rezervacijas { get; set; } = new List<Rezervacija>();

    public virtual SlikaProfila? SlikaProfila { get; set; }

    public virtual ICollection<Zaposlenik> Zaposleniks { get; set; } = new List<Zaposlenik>();
}
