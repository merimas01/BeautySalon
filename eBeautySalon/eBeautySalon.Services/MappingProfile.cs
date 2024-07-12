using AutoMapper;
using eBeautySalon.Models;
using eBeautySalon.Models.Requests;
using eBeautySalon.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

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

        }
    }
}
