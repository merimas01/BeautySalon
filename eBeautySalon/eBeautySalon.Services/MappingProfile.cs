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
        }
    }
}
