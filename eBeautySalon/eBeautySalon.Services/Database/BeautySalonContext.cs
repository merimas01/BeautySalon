using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace eBeautySalon.Services.Database;

public partial class BeautySalonContext : DbContext
{
    public BeautySalonContext()
    {
    }

    public BeautySalonContext(DbContextOptions<BeautySalonContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Kategorija> Kategorijas { get; set; }

    public virtual DbSet<Korisnik> Korisniks { get; set; }

    public virtual DbSet<KorisnikUloga> KorisnikUlogas { get; set; }

    public virtual DbSet<Novost> Novosts { get; set; }

    public virtual DbSet<RecenzijaUsluge> RecenzijaUsluges { get; set; }

    public virtual DbSet<RecenzijaUsluznika> RecenzijaUsluznikas { get; set; }

    public virtual DbSet<Rezervacija> Rezervacijas { get; set; }

    public virtual DbSet<SlikaNovost> SlikaNovosts { get; set; }

    public virtual DbSet<SlikaProfila> SlikaProfilas { get; set; }

    public virtual DbSet<SlikaUsluge> SlikaUsluges { get; set; }

    public virtual DbSet<Termin> Termins { get; set; }

    public virtual DbSet<Uloga> Ulogas { get; set; }

    public virtual DbSet<Usluga> Uslugas { get; set; }

    public virtual DbSet<Zaposlenik> Zaposleniks { get; set; }

    public virtual DbSet<ZaposlenikUsluga> ZaposlenikUslugas { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see https://go.microsoft.com/fwlink/?LinkId=723263.
        => optionsBuilder.UseSqlServer("Data Source=localhost; Initial Catalog=BeautySalon; Trusted_Connection=True; TrustServerCertificate=True");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Kategorija>(entity =>
        {
            entity.ToTable("Kategorija");

            entity.Property(e => e.KategorijaId).HasColumnName("KategorijaID");
            entity.Property(e => e.DatumKreiranja).HasColumnType("datetime");
            entity.Property(e => e.DatumModifikovanja).HasColumnType("datetime");
            entity.Property(e => e.Naziv).HasMaxLength(50);
            entity.Property(e => e.Opis).HasMaxLength(200);
        });

        modelBuilder.Entity<Korisnik>(entity =>
        {
            entity.ToTable("Korisnik");

            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");
            entity.Property(e => e.DatumKreiranja).HasColumnType("datetime");
            entity.Property(e => e.DatumModifikovanja).HasColumnType("datetime");
            entity.Property(e => e.Email).HasMaxLength(100);
            entity.Property(e => e.Ime).HasMaxLength(50);
            entity.Property(e => e.IsAdmin).HasColumnName("isAdmin");
            entity.Property(e => e.KorisnickoIme).HasMaxLength(50);
            entity.Property(e => e.LozinkaHash).HasMaxLength(50);
            entity.Property(e => e.LozinkaSalt).HasMaxLength(50);
            entity.Property(e => e.Prezime).HasMaxLength(50);
            entity.Property(e => e.SlikaProfilaId).HasColumnName("SlikaProfilaID");
            entity.Property(e => e.Telefon).HasMaxLength(20);

            entity.HasOne(d => d.SlikaProfila).WithMany(p => p.Korisniks)
                .HasForeignKey(d => d.SlikaProfilaId)
                .HasConstraintName("FK_Korisnik_SlikaProfila");
        });

        modelBuilder.Entity<KorisnikUloga>(entity =>
        {
            entity.ToTable("KorisnikUloga");

            entity.Property(e => e.KorisnikUlogaId).HasColumnName("KorisnikUlogaID");
            entity.Property(e => e.DatumIzmjene).HasColumnType("datetime");
            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");
            entity.Property(e => e.UlogaId).HasColumnName("UlogaID");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.KorisnikUlogas)
                .HasForeignKey(d => d.KorisnikId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_KorisnikUloga_Korisnik");

            entity.HasOne(d => d.Uloga).WithMany(p => p.KorisnikUlogas)
                .HasForeignKey(d => d.UlogaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_KorisnikUloga_Uloga");
        });

        modelBuilder.Entity<Novost>(entity =>
        {
            entity.ToTable("Novost");

            entity.Property(e => e.NovostId).HasColumnName("NovostID");
            entity.Property(e => e.DatumKreiranja).HasColumnType("datetime");
            entity.Property(e => e.DatumModificiranja).HasColumnType("datetime");
            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");
            entity.Property(e => e.Naslov).HasMaxLength(100);
            entity.Property(e => e.SlikaNovostId).HasColumnName("SlikaNovostID");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.Novosts)
                .HasForeignKey(d => d.KorisnikId)
                .HasConstraintName("FK_Novost_Korisnik");

            entity.HasOne(d => d.SlikaNovost).WithMany(p => p.Novosts)
                .HasForeignKey(d => d.SlikaNovostId)
                .HasConstraintName("FK_Novost_SlikaNovost");
        });

        modelBuilder.Entity<RecenzijaUsluge>(entity =>
        {
            entity.ToTable("RecenzijaUsluge");

            entity.Property(e => e.RecenzijaUslugeId).HasColumnName("RecenzijaUslugeID");
            entity.Property(e => e.DatumKreiranja)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.DatumModificiranja).HasColumnType("datetime");
            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");
            entity.Property(e => e.UslugaId).HasColumnName("UslugaID");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.RecenzijaUsluges)
                .HasForeignKey(d => d.KorisnikId)
                .HasConstraintName("FK_RecenzijaUsluge_Korisnik");

            entity.HasOne(d => d.Usluga).WithMany(p => p.RecenzijaUsluges)
                .HasForeignKey(d => d.UslugaId)
                .HasConstraintName("FK_RecenzijaUsluge_Usluga");
        });

        modelBuilder.Entity<RecenzijaUsluznika>(entity =>
        {
            entity.ToTable("RecenzijaUsluznika");

            entity.Property(e => e.RecenzijaUsluznikaId).HasColumnName("RecenzijaUsluznikaID");
            entity.Property(e => e.DatumKreiranja)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.DatumModificiranja).HasColumnType("datetime");
            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");
            entity.Property(e => e.UsluznikId).HasColumnName("UsluznikID");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.RecenzijaUsluznikas)
                .HasForeignKey(d => d.KorisnikId)
                .HasConstraintName("FK_RecenzijaUsluznika_Korisnik");

            entity.HasOne(d => d.Usluznik).WithMany(p => p.RecenzijaUsluznikas)
                .HasForeignKey(d => d.UsluznikId)
                .HasConstraintName("FK_RecenzijaUsluznika_Usluznik");
        });

        modelBuilder.Entity<Rezervacija>(entity =>
        {
            entity.ToTable("Rezervacija");

            entity.Property(e => e.RezervacijaId).HasColumnName("RezervacijaID");
            entity.Property(e => e.DatumRezervacije).HasColumnType("datetime");
            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");
            entity.Property(e => e.TerminId).HasColumnName("TerminID");
            entity.Property(e => e.UslugaId).HasColumnName("UslugaID");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.Rezervacijas)
                .HasForeignKey(d => d.KorisnikId)
                .HasConstraintName("FK_Rezervacija_Korisnik");

            entity.HasOne(d => d.Termin).WithMany(p => p.Rezervacijas)
                .HasForeignKey(d => d.TerminId)
                .HasConstraintName("FK_Rezervacija_Termin");

            entity.HasOne(d => d.Usluga).WithMany(p => p.Rezervacijas)
                .HasForeignKey(d => d.UslugaId)
                .HasConstraintName("FK_Rezervacija_Usluga");
        });

        modelBuilder.Entity<SlikaNovost>(entity =>
        {
            entity.ToTable("SlikaNovost");

            entity.Property(e => e.SlikaNovostId).HasColumnName("SlikaNovostID");
        });

        modelBuilder.Entity<SlikaProfila>(entity =>
        {
            entity.ToTable("SlikaProfila");

            entity.Property(e => e.SlikaProfilaId).HasColumnName("SlikaProfilaID");
        });

        modelBuilder.Entity<SlikaUsluge>(entity =>
        {
            entity.ToTable("SlikaUsluge");

            entity.Property(e => e.SlikaUslugeId).HasColumnName("SlikaUslugeID");
        });

        modelBuilder.Entity<Termin>(entity =>
        {
            entity.ToTable("Termin");

            entity.Property(e => e.TerminId).HasColumnName("TerminID");
            entity.Property(e => e.Opis).HasMaxLength(50);
        });

        modelBuilder.Entity<Uloga>(entity =>
        {
            entity.ToTable("Uloga");

            entity.Property(e => e.UlogaId).HasColumnName("UlogaID");
            entity.Property(e => e.Naziv).HasMaxLength(50);
            entity.Property(e => e.Opis).HasMaxLength(200);
        });

        modelBuilder.Entity<Usluga>(entity =>
        {
            entity.ToTable("Usluga");

            entity.Property(e => e.UslugaId).HasColumnName("UslugaID");
            entity.Property(e => e.Cijena).HasColumnType("decimal(18, 0)");
            entity.Property(e => e.DatumKreiranja).HasColumnType("datetime");
            entity.Property(e => e.DatumModifikovanja).HasColumnType("datetime");
            entity.Property(e => e.KategorijaId).HasColumnName("KategorijaID");
            entity.Property(e => e.Naziv).HasMaxLength(50);
            entity.Property(e => e.SlikaUslugeId).HasColumnName("SlikaUslugeID");

            entity.HasOne(d => d.Kategorija).WithMany(p => p.Uslugas)
                .HasForeignKey(d => d.KategorijaId)
                .HasConstraintName("FK_Usluga_Kategorija");

            entity.HasOne(d => d.SlikaUsluge).WithMany(p => p.Uslugas)
                .HasForeignKey(d => d.SlikaUslugeId)
                .HasConstraintName("FK_Usluga_SlikaUsluge");
        });

        modelBuilder.Entity<Zaposlenik>(entity =>
        {
            entity.ToTable("Zaposlenik");

            entity.Property(e => e.ZaposlenikId).HasColumnName("ZaposlenikID");
            entity.Property(e => e.DatumKreiranja)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.DatumModifikovanja).HasColumnType("datetime");
            entity.Property(e => e.DatumRodjenja).HasColumnType("datetime");
            entity.Property(e => e.DatumZaposlenja).HasColumnType("datetime");
            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.Zaposleniks)
                .HasForeignKey(d => d.KorisnikId)
                .HasConstraintName("FK_Korisnik_Zaposlenik");
        });

        modelBuilder.Entity<ZaposlenikUsluga>(entity =>
        {
            entity.ToTable("ZaposlenikUsluga");

            entity.Property(e => e.ZaposlenikUslugaId).HasColumnName("ZaposlenikUslugaID");
            entity.Property(e => e.DatumKreiranja)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.DatumModificiranja).HasColumnType("datetime");
            entity.Property(e => e.UslugaId).HasColumnName("UslugaID");
            entity.Property(e => e.ZaposlenikId).HasColumnName("ZaposlenikID");

            entity.HasOne(d => d.Usluga).WithMany(p => p.ZaposlenikUslugas)
                .HasForeignKey(d => d.UslugaId)
                .HasConstraintName("FK_ZaposlenikUsluga_Usluga");

            entity.HasOne(d => d.Zaposlenik).WithMany(p => p.ZaposlenikUslugas)
                .HasForeignKey(d => d.ZaposlenikId)
                .HasConstraintName("FK_ZaposlenikUsluga_Zaposlenik");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
