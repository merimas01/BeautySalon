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

            CreateMap<KorisnikUloga, KorisniciUloge>();
            CreateMap<KorisniciUlogeInsertRequest, KorisnikUloga>();
            CreateMap<KorisniciUlogeUpdateRequest, KorisnikUloga>();

            CreateMap<Uloga, Uloge>();
            CreateMap<UlogeInsertRequest, Uloga>();
            CreateMap<UlogeUpdateRequest, Uloga>();

            CreateMap<Usluga, Usluge>();
            CreateMap<UslugeInsertRequest, Usluga>();
            CreateMap<UslugeUpdateRequest, Usluga>();

            CreateMap<Database.RecenzijaUsluge, Models.RecenzijaUsluge>();
            CreateMap<RecenzijaUslugeInsertRequest, Database.RecenzijaUsluge>();
            CreateMap<RecenzijaUslugeUpdateRequest, Database.RecenzijaUsluge>();

            CreateMap<Database.RecenzijaUsluznika, Models.RecenzijaUsluznika>();
            CreateMap<RecenzijaUsluznikaInsertRequest, Database.RecenzijaUsluznika>();
            CreateMap<RecenzijaUsluznikaUpdateRequest, Database.RecenzijaUsluznika>();

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

            CreateMap<Database.UslugaTermin, Models.UslugeTermini>();
            CreateMap<UslugeTerminiInsertRequest, Database.UslugaTermin>();
            CreateMap<UslugeTerminiUpdateRequest, Database.UslugaTermin>();

            CreateMap<Database.NovostLikeComment, Models.NovostLikeComment>();
            CreateMap<NovostLikeCommentInsertRequest, Database.NovostLikeComment>();
            CreateMap<NovostLikeCommentUpdateRequest, Database.NovostLikeComment>();

            CreateMap<Database.Status, Models.Statusi>();
        }
    }
}
