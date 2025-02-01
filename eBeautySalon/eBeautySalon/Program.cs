using System.Security.Cryptography;
using System.Text;
using eBeautySalon;
using eBeautySalon.Controllers;
using eBeautySalon.Filters;
using eBeautySalon.Models;
using eBeautySalon.Models.Requests;
using eBeautySalon.Models.SearchObjects;
using eBeautySalon.Services;
using eBeautySalon.Services.Database;
using Microsoft.AspNetCore.Authentication;
using Microsoft.EntityFrameworkCore;
using Microsoft.OpenApi.Models;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddTransient<IUslugeService, UslugeService>();
builder.Services.AddTransient<IKorisniciService, KorisniciService>();
builder.Services.AddTransient<IKategorijeService, KategorijeService>();
builder.Services.AddTransient<IRecenzijaUsluznikaService, RecenzijaUsluznikaService>();
builder.Services.AddTransient<IRecenzijaUslugeService, RecenzijaUslugeService>();
builder.Services.AddTransient<INovostiService, NovostiService>();
builder.Services.AddTransient<ISlikaNovostiService, SlikaNovostiService>();
builder.Services.AddTransient<ISlikaProfilaService, SlikaProfilaService>();
builder.Services.AddTransient<ISlikaUslugeService, SlikaUslugeService>();
builder.Services.AddTransient<ITerminiService, TerminiService>();
builder.Services.AddTransient<IRezervacijeService, RezervacijeService>();
builder.Services.AddTransient<IZaposleniciService, ZaposleniciService>();
builder.Services.AddTransient<IZaposleniciUslugeService, ZaposleniciUslugeService>();
builder.Services.AddTransient<IKorisniciUlogeService, KorisniciUlogeService>();
builder.Services.AddTransient<IUlogeService, UlogeService>();
builder.Services.AddTransient<IStatusService, StatusiService>();
builder.Services.AddTransient<IUslugeTerminiService, UslugeTerminiService>();
builder.Services.AddTransient<INovostLikeCommentService, NovostLikeCommentService>();


builder.Services.AddControllers(x =>
{
    x.Filters.Add<ErrorFilter>();
});
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen( c=>
    {
        c.AddSecurityDefinition("basicAuth", new Microsoft.OpenApi.Models.OpenApiSecurityScheme()
        {
            Type = Microsoft.OpenApi.Models.SecuritySchemeType.Http,
            Scheme = "basic"
        });

        c.AddSecurityRequirement(new Microsoft.OpenApi.Models.OpenApiSecurityRequirement()
        {
            {
                new OpenApiSecurityScheme
                {
                    Reference=new OpenApiReference{Type=ReferenceType.SecurityScheme, Id="basicAuth"}
                },
                new string[]{}
            }
        });
    }
);

builder.Services.AddAutoMapper(typeof(IKorisniciService));
builder.Services.AddAuthentication("BasicAuthentication")
    .AddScheme<AuthenticationSchemeOptions, BasicAuthenticationHandler>("BasicAuthentication", null);


var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
builder.Services.AddDbContext<Ib200070Context>(options => options.UseSqlServer(connectionString));


var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

using (var scope = app.Services.CreateScope())
{
    var dataContext = scope.ServiceProvider.GetRequiredService<Ib200070Context>();

    //var con = dataContext.Database.GetConnectionString();

    if (dataContext.Database.EnsureCreated())
    {        
        dataContext.Database.Migrate();

        dataContext.SlikaProfilas.AddRange(
            new eBeautySalon.Services.Database.SlikaProfila { Slika = null});

        dataContext.SaveChanges();

        dataContext.SlikaUsluges.AddRange(
            new eBeautySalon.Services.Database.SlikaUsluge { Slika = null });

        dataContext.SaveChanges();

        dataContext.SlikaNovosts.AddRange(
            new eBeautySalon.Services.Database.SlikaNovost { Slika = null });

        dataContext.SaveChanges();

        dataContext.Ulogas.AddRange(
            new Uloga { Sifra = "UL000001", Naziv = "Administrator", Opis = "Glavni u app"},
            new Uloga { Sifra = "UL000002", Naziv = "Uslužnik", Opis = "Upravlja uslugama" },
            new Uloga { Sifra = "UL000003", Naziv = "Rezervacioner", Opis = "Upravlja rezervacijama" }
            );

        dataContext.SaveChanges();

        string password = "admin"; // Same password for demonstration

        string salt1 = GenerateSalt();
        string hash1 = GenerateHash(salt1, password);

        dataContext.Korisniks.AddRange(
         new Korisnik
         {
             DatumKreiranja = new DateTime(year: 2024, month: 1, day: 1),
             DatumModifikovanja = null,
             Email = "admin@gmail.com",
             Ime = "Admin",
             Prezime = "Admin",
             IsAdmin = true,
             KorisnickoIme = "admin",
             Sifra = "USR000001",
             Status = true,
             Telefon = "+387 62 654 235",
             LozinkaHash = hash1,
             LozinkaSalt = salt1,
             SlikaProfilaId = 1
         },
         new Korisnik
         {
             DatumKreiranja = new DateTime(year: 2024, month: 1, day: 2),
             DatumModifikovanja = null,
             Email = "marko.ivanovic@gmail.com",
             Ime = "Marko",
             Prezime = "Ivanovic",
             IsAdmin = false,
             KorisnickoIme = "marko",
             Sifra = "USR000002",
             Status = true,
             Telefon = "+387 62 555 777",
             LozinkaHash = hash1,
             LozinkaSalt = salt1,
             SlikaProfilaId = 1
         },
         new Korisnik
         {
             DatumKreiranja = new DateTime(year: 2024, month: 1, day: 2),
             DatumModifikovanja = null,
             Email = "jovana.nikolic@gmail.com",
             Ime = "Jovana",
             Prezime = "Nikolic",
             IsAdmin = false,
             KorisnickoIme = "jovana",
             Sifra = "USR000003",
             Status = true,
             Telefon = "+387 62 555 888",
             LozinkaHash = hash1,
             LozinkaSalt = salt1,
             SlikaProfilaId = 1
         },
         new Korisnik
         {
             DatumKreiranja = new DateTime(year: 2024, month: 1, day: 5),
             DatumModifikovanja = null,
             Email = "ivana.mihajlovic@gmail.com",
             Ime = "Ivana",
             Prezime = "Mihajlovic",
             IsAdmin = false,
             KorisnickoIme = "ivana",
             Sifra = "USR000004",
             Status = true,
             Telefon = "+387 62 555 999",
             LozinkaHash = hash1,
             LozinkaSalt = salt1,
             SlikaProfilaId = 1
         },
         new Korisnik
         {
             DatumKreiranja = new DateTime(year: 2024, month: 1, day: 3),
             DatumModifikovanja = null,
             Email = "petar.petrovic@gmail.com",
             Ime = "Petar",
             Prezime = "Petrovic",
             IsAdmin = false,
             KorisnickoIme = "petar",
             Sifra = "USR000005",
             Status = true,
             Telefon = "+387 62 555 000",
             LozinkaHash = hash1,
             LozinkaSalt = salt1,
             SlikaProfilaId = 1
         },
        new Korisnik
        {
            DatumKreiranja = new DateTime(year: 2024, month: 1, day: 3),
            DatumModifikovanja = null,
            Email = "mila.milic@gmail.com",
            Ime = "Mila",
            Prezime = "Milic",
            IsAdmin = false,
            KorisnickoIme = "mila",
            Sifra = "USR000006",
            Status = true,
            Telefon = "+387 62 544 600",
            LozinkaHash = hash1,
            LozinkaSalt = salt1,
            SlikaProfilaId = 1
        }
     );

        dataContext.SaveChanges();

        dataContext.KorisnikUlogas.AddRange(
            new KorisnikUloga { UlogaId = 1, KorisnikId = 1, DatumIzmjene = DateTime.Now },
            new KorisnikUloga { UlogaId = 2, KorisnikId = 2, DatumIzmjene = DateTime.Now },
            new KorisnikUloga { UlogaId = 3, KorisnikId = 3, DatumIzmjene = DateTime.Now },
            new KorisnikUloga { UlogaId = 2, KorisnikId = 6, DatumIzmjene = DateTime.Now }
            );

        dataContext.SaveChanges();

        dataContext.Kategorijas.AddRange(
            new Kategorija { Naziv = "Šminkanje", DatumKreiranja = DateTime.Now, DatumModifikovanja = null, Opis = "Kategorija vezana za šminkanje", Sifra = "K000001"},
            new Kategorija { Naziv = "Frizure", DatumKreiranja = DateTime.Now, DatumModifikovanja = null, Opis = "Kategorija koja obuhvata sve vrste frizura", Sifra = "K000002" },
            new Kategorija { Naziv = "Manikir", DatumKreiranja = DateTime.Now, DatumModifikovanja = null, Opis = "Kategorija vezana za usluge manikira", Sifra = "K000003" },
            new Kategorija { Naziv = "Pedikir", DatumKreiranja = DateTime.Now, DatumModifikovanja = null, Opis = "Usluge pedikira za negu stopala", Sifra = "K000004" },
            new Kategorija { Naziv = "Tretmani lica", DatumKreiranja = DateTime.Now, DatumModifikovanja = null, Opis = "Kategorija koja obuhvata sve tretmane za lice", Sifra = "K000005" },
            new Kategorija { Naziv = "Tretmani tijela", DatumKreiranja = DateTime.Now, DatumModifikovanja = null, Opis = "Razni tretmani za telo, od masaža do anticelulit tretmana", Sifra = "K000006" }
        );

        dataContext.SaveChanges();

        dataContext.Uslugas.AddRange(
            new Usluga { Naziv = "Profesionalno šminkanje", Opis="Nudimo najbolje šminkanje za mature, svadbe, slikanja...", KategorijaId = 1, Sifra = "U000001", SlikaUslugeId = 1, Cijena = 50, DatumKreiranja = DateTime.Now },
            new Usluga { Naziv = "Bridal šminkanje", Opis = "Za Vas dan zelimo samo da se opustite i prepustite rukama nasih vrhunskih usluznika. Za Vas cemo se potruditi da vase lice izgleda blistavo i da se osjecate ljepse nego ikada. Nudimo Vam hidrataciju i pripremu lica, šminkanje kao i savjete za odrzavanje sminke i sretnog duha tokom dana.", KategorijaId = 1, Sifra = "U000002", SlikaUslugeId = 1, Cijena = 60, DatumKreiranja = DateTime.Now },
            new Usluga { Naziv = "Hemijsko čišćenje lica", Opis = "Nas najpoznatiji tretman čišćenja lica. Uvjerite se zasto ga ljudi toliko vole.", KategorijaId = 5, Sifra = "U000003", SlikaUslugeId = 1, Cijena = 45, DatumKreiranja =DateTime.Now },
            new Usluga { Naziv = "Njega noktiju", Opis = "Ovaj tretman ukljucuje: ciscenje i obikovanje noktiju, lakiranje, stavljanje zastitnog sloja na nokte, njega i hidratacija ruku.", KategorijaId = 3, Sifra = "U000003", SlikaUslugeId = 1, Cijena = 45, DatumKreiranja = DateTime.Now },
            new Usluga { Naziv = "Scensko šminkanje", Opis = "Sminkanje za ples, glumu, koncerte i velike kamere.", KategorijaId = 1, Sifra = "U000005", SlikaUslugeId = 1, Cijena = 50, DatumKreiranja = DateTime.Now }
            );

        dataContext.SaveChanges();

        dataContext.Novosts.AddRange(
            new Novost
            {
                Naslov = "Besplatne usluge za sve klijente dana 23.8.2025.",
                Sadrzaj = "Puno teksta o besplatnim uslugama koje su dostupne klijentima ovog dana. Uključuje sve usluge u našem portfoliju.",
                SlikaNovostId = 1,
                Sifra = "N000001",
                KorisnikId = 1,
                DatumKreiranja = new DateTime(year:2024, month:8, day:1),
                DatumModificiranja = null
            },
            new Novost
            {
                Naslov = "Popust na frizure za sve nove korisnike!",
                Sadrzaj = "Novi korisnici mogu iskoristiti popust od 30% na sve frizerske usluge tokom meseca avgusta.",
                SlikaNovostId = 1,
                Sifra = "N000002",
                KorisnikId = 1,
                DatumKreiranja = new DateTime(year:2024, month:6, day:15),
                DatumModificiranja = null
            },
            new Novost
            {
                Naslov = "Novi tretman lica u ponudi",
                Sadrzaj = "Uveli smo novi tretman za negu lica koji koristi najnoviju tehnologiju za dubinsko čišćenje i revitalizaciju kože.",
                SlikaNovostId = 1,
                Sifra = "N000003",
                KorisnikId = 1,
                DatumKreiranja = new DateTime(year: 2024, month: 9, day:4),
                DatumModificiranja = null
            },
            new Novost
            {
                Naslov = "Otkazivanje termina bez naknade uz 24h obaveštenje",
                Sadrzaj = "Obaveštavamo sve naše klijente da je moguće otkazati termine bez naknade ako se obavesti 24h unapred.",
                SlikaNovostId = 1,
                Sifra = "N000004",
                KorisnikId = 1,
                DatumKreiranja = new DateTime(year: 2024, month: 10, day: 5),
                DatumModificiranja = null
            },
            new Novost
            {
                Naslov = "Osvježite svoj izgled - Akcija na manikir i pedikir!",
                Sadrzaj = "Za sve naše klijentkinje, popust na kombinovanu uslugu manikira i pedikira. Iskoristite priliku do kraja meseca.",
                SlikaNovostId = 1,
                Sifra = "N000005",
                KorisnikId = 1,
                DatumKreiranja = new DateTime(year: 2024, month: 10, day: 10),
                DatumModificiranja = null
            },
            new Novost
            {
                Naslov = "Specijalna ponuda za svadbeni dan",
                Sadrzaj = "Za buduće mlade, specijalni paket usluga za svadbeni dan uključujući frizuru, šminkanje i manikir.",
                SlikaNovostId = 1,
                Sifra = "N000006",
                KorisnikId = 1,
                DatumKreiranja = new DateTime(year: 2024, month: 7, day: 18),
                DatumModificiranja = null
            }
            );

        dataContext.SaveChanges();

        dataContext.RecenzijaUsluges.AddRange( 
            new eBeautySalon.Services.Database.RecenzijaUsluge { KorisnikId = 4, UslugaId = 1, DatumKreiranja = DateTime.Now, DatumModificiranja = null, Komentar = "Odlična usluga!", Ocjena = 5 },
            new eBeautySalon.Services.Database.RecenzijaUsluge { KorisnikId = 4, UslugaId = 2, DatumKreiranja = DateTime.Now, DatumModificiranja = null, Komentar = "Super usluga!", Ocjena = 5 },
            new eBeautySalon.Services.Database.RecenzijaUsluge { KorisnikId = 5, UslugaId = 1, DatumKreiranja = DateTime.Now, DatumModificiranja = null, Komentar = "Prosjek", Ocjena = 3 },
            new eBeautySalon.Services.Database.RecenzijaUsluge { KorisnikId = 5, UslugaId = 2, DatumKreiranja = DateTime.Now, DatumModificiranja = null, Komentar = "Može bolje", Ocjena = 4 }
            );

        dataContext.SaveChanges();


        dataContext.Zaposleniks.AddRange(
            new Zaposlenik {
                DatumRodjenja = new DateTime(year: 2000, month: 5, day: 15),
                DatumZaposlenja = DateTime.Now,
                KorisnikId = 2, 
                DatumKreiranja = DateTime.Now,
                Biografija = "Iskusan u svom poslu. Jako kreativan. Zavrsio umjetnicku skolu."
            }, //usluznik

            new Zaposlenik
            {
                DatumRodjenja = new DateTime(year: 1999, month: 8, day: 7),
                DatumZaposlenja = DateTime.Now,
                KorisnikId = 3, 
                DatumKreiranja = DateTime.Now,
                Biografija = "Izvrstan radnik, organizovana do srzi, posvecena maksimalno i uziva u tome sto radi."
            },//rezervacioner
              new Zaposlenik
              {
                  DatumRodjenja = new DateTime(year: 1995, month: 6, day: 8),
                  DatumZaposlenja = DateTime.Now,
                  KorisnikId = 6,
                  DatumKreiranja = DateTime.Now,
                  Biografija = "Svestrana, disciplinovana, brzih i spretnih ruku. Majstor svog zanata u svakom smislu te rijeci."
              } //usluznik
            );

        dataContext.SaveChanges();

        dataContext.ZaposlenikUslugas.AddRange(
            new ZaposlenikUsluga { ZaposlenikId = 1, DatumKreiranja = DateTime.Now, UslugaId = 1 },
            new ZaposlenikUsluga { ZaposlenikId = 1, DatumKreiranja = DateTime.Now, UslugaId = 2 },
            new ZaposlenikUsluga { ZaposlenikId = 3, DatumKreiranja = DateTime.Now, UslugaId = 3 },
            new ZaposlenikUsluga { ZaposlenikId = 3, DatumKreiranja = DateTime.Now, UslugaId = 2 },
            new ZaposlenikUsluga { ZaposlenikId = 3, DatumKreiranja = DateTime.Now, UslugaId = 5 }
            );

        dataContext.SaveChanges();

        dataContext.RecenzijaUsluznikas.AddRange(
             new eBeautySalon.Services.Database.RecenzijaUsluznika { KorisnikId = 4, UsluznikId = 1, Ocjena = 5, Komentar = "Odličan uslužnik!", DatumKreiranja = DateTime.Now },
             new eBeautySalon.Services.Database.RecenzijaUsluznika { KorisnikId = 5, UsluznikId = 1, Ocjena = 5, Komentar = "Jako zadovoljan.", DatumKreiranja = DateTime.Now }
            );

        dataContext.SaveChanges();

        dataContext.Statuses.AddRange(
            new Status { Sifra = "S000001", Opis = "Nova" },
            new Status { Sifra = "S000002", Opis = "Otkazana" },
            new Status { Sifra = "S000003", Opis = "Prihvaćena" },
            new Status { Sifra = "S000004", Opis = "Odbijena" },
            new Status { Sifra = "S000005", Opis = "Završena" }
            );

        dataContext.SaveChanges();

        dataContext.Termins.AddRange(
            new Termin { Opis = "08:00", Sifra = "T000001"},
            new Termin { Opis = "09:00", Sifra = "T000002"},
            new Termin { Opis = "10:00", Sifra = "T000003"}
            );

        dataContext.SaveChanges();

        dataContext.UslugaTermins.AddRange(
            new UslugaTermin { UslugaId = 1, TerminId = 1, DatumIzmjene = DateTime.Now, IsPrikazan = true },
            new UslugaTermin { UslugaId = 1, TerminId = 2, DatumIzmjene = DateTime.Now, IsPrikazan = true },
            new UslugaTermin { UslugaId = 1, TerminId = 3, DatumIzmjene = DateTime.Now, IsPrikazan = true },
            new UslugaTermin { UslugaId = 2, TerminId = 1, DatumIzmjene = DateTime.Now, IsPrikazan = true },
            new UslugaTermin { UslugaId = 2, TerminId = 2, DatumIzmjene = DateTime.Now, IsPrikazan = true },
            new UslugaTermin { UslugaId = 3, TerminId = 1, DatumIzmjene = DateTime.Now, IsPrikazan = true },
            new UslugaTermin { UslugaId = 3, TerminId = 2, DatumIzmjene = DateTime.Now, IsPrikazan = true },
            new UslugaTermin { UslugaId = 4, TerminId = 1, DatumIzmjene = DateTime.Now, IsPrikazan = true },
            new UslugaTermin { UslugaId = 4, TerminId = 2, DatumIzmjene = DateTime.Now, IsPrikazan = true },
            new UslugaTermin { UslugaId = 5, TerminId = 2, DatumIzmjene = DateTime.Now, IsPrikazan = true },
            new UslugaTermin { UslugaId = 5, TerminId = 3, DatumIzmjene = DateTime.Now, IsPrikazan = true }
            );

        dataContext.SaveChanges();

        dataContext.Rezervacijas.AddRange(
            new Rezervacija { Sifra = "R000001", KorisnikId = 4, StatusId = 1, IsArhiva = false, IsArhivaKorisnik = false, TerminId = 1, UslugaId = 2, DatumRezervacije = new DateTime(year: 2024, month: 9, day: 9), },
            new Rezervacija { Sifra = "R000002", KorisnikId = 4, StatusId = 1, IsArhiva = false, IsArhivaKorisnik = false, TerminId = 2, UslugaId = 1, DatumRezervacije = new DateTime(year: 2024, month: 10, day: 8), },
            new Rezervacija { Sifra = "R000003", KorisnikId = 5, StatusId = 4, IsArhiva = true, IsArhivaKorisnik = false, TerminId = 3, UslugaId = 1, DatumRezervacije = new DateTime(year: 2024, month: 11, day: 6), }
            );

        dataContext.SaveChanges();


        dataContext.NovostLikeComments.AddRange(
            new eBeautySalon.Services.Database.NovostLikeComment { KorisnikId = 4, NovostId = 1, IsLike = true, Komentar = "odlican post!", DatumKreiranja = DateTime.Now },
            new eBeautySalon.Services.Database.NovostLikeComment { KorisnikId = 5, NovostId = 2, IsLike = true, Komentar = "jako korisne informacije!", DatumKreiranja = DateTime.Now }
            );
        dataContext.SaveChanges();
    }
}
 static string GenerateSalt()
{
    var provider = new RNGCryptoServiceProvider();
    var byteArray = new byte[16];
    provider.GetBytes(byteArray);

    return Convert.ToBase64String(byteArray);
}

 static string GenerateHash(string salt, string password)
{
    byte[] src = Convert.FromBase64String(salt);
    byte[] bytes = Encoding.Unicode.GetBytes(password);
    byte[] dist = new byte[src.Length + bytes.Length];

    System.Buffer.BlockCopy(src, 0, dist, 0, src.Length);
    System.Buffer.BlockCopy(bytes, 0, dist, src.Length, bytes.Length);

    HashAlgorithm algorithm = HashAlgorithm.Create("SHA1");
    byte[] inArray = algorithm.ComputeHash(dist);
    return Convert.ToBase64String(inArray);
}





app.Run();
