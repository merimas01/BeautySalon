using AutoMapper;
using eBeautySalon.Models;
using eBeautySalon.Models.Requests;
using eBeautySalon.Services.Database;

namespace eBeautySalon.Services
{
    public class MappingProfile : Profile
    {
        public MappingProfile() 
        {
            CreateMap<Korisnik, Korisnici>();
            CreateMap<KorisniciInsertRequest, Korisnik>();
            CreateMap<KorisniciUpdateRequest, Korisnik>();

            CreateMap<Kategorija, Kategorije>();
            CreateMap<KategorijeInsertRequest, Kategorija>();
            CreateMap<KategorijeUpdateRequest, Kategorija>();

            CreateMap<Komentar, Komentari>();
            CreateMap<KomentariInsertRequest, Komentar>();
            CreateMap<KomentariUpdateRequest, Komentar>();

            CreateMap<KorisnikUloga, KorisniciUloge>();
            CreateMap<Uloga, Uloge>();

            CreateMap<Usluga, Usluge>();
            CreateMap<UslugeInsertRequest, Usluga>();
            CreateMap<UslugeUpdateRequest, Usluga>();

            CreateMap<Ocjena, Ocjene>();
            CreateMap<OcjeneInsertRequest, Ocjena>();
            CreateMap<OcjeneUpdateRequest, Ocjena>();

            CreateMap<Novost, Novosti>();
            CreateMap<NovostiInsertRequest, Novost>();
            CreateMap<NovostiUpdateRequest, Novost>();

            CreateMap<SlikaNovost, SlikaNovosti>();
            CreateMap<SlikaNovostiInsertRequest, SlikaNovost>();
            CreateMap<SlikaNovostiUpdateRequest, SlikaNovost>();

            CreateMap<Termin, Termini>();
            CreateMap<TerminiInsertRequest, Termin>();
            CreateMap<TerminiUpdateRequest, Termin>();

            CreateMap<Rezervacija, Rezervacije>();
            CreateMap<RezervacijeInsertRequest, Rezervacija>();
            CreateMap<RezervacijeUpdateRequest, Rezervacija>();

            CreateMap<Database.SlikaProfila, Models.SlikaProfila>();
            CreateMap<SlikaProfilaInsertRequest, Database.SlikaProfila>();
            CreateMap<SlikaProfilaUpdateRequest, Database.SlikaProfila>();

            CreateMap<Database.SlikaUsluge, Models.SlikaUsluge>();
            CreateMap<SlikaUslugeInsertRequest, Database.SlikaUsluge>();
            CreateMap<SlikaUslugeUpdateRequest, Database.SlikaUsluge>();

            CreateMap<Database.Zaposlenik, Models.Zaposlenici>();
            CreateMap<ZaposleniciInsertRequest, Database.Zaposlenik>();
            CreateMap<ZaposleniciUpdateRequest, Database.Zaposlenik>();

            CreateMap<Database.ZaposlenikUsluga, Models.ZaposleniciUsluge>();
            CreateMap<ZaposleniciUslugeInsertRequest, Database.ZaposlenikUsluga>();
            CreateMap<ZaposleniciUslugeUpdateRequest, Database.ZaposlenikUsluga>();
        }
    }
}
