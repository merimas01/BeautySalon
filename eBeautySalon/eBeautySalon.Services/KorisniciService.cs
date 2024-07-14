using AutoMapper;
using Azure.Core;
using eBeautySalon.Models;
using eBeautySalon.Models.Requests;
using eBeautySalon.Models.SearchObjects;
using eBeautySalon.Services.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace eBeautySalon.Services
{
    public class KorisniciService : BaseCRUDService<Korisnici, Korisnik, KorisniciSearchObject,KorisniciInsertRequest, KorisniciUpdateRequest>, IKorisniciService
    {
        public KorisniciService(BeautySalonContext context, IMapper mapper): base(context,mapper)
        {
        }

        public override async Task BeforeInsert(Korisnik korisnik, KorisniciInsertRequest request)
        {
            korisnik.LozinkaSalt = GenerateSalt();
            korisnik.LozinkaHash = GenerateHash(korisnik.LozinkaSalt, request.Password);
        }
      
        public static string GenerateSalt()
        {
            var provider = new RNGCryptoServiceProvider();
            var byteArray = new byte[16];
            provider.GetBytes(byteArray);

            return Convert.ToBase64String(byteArray);
        }

        public static string GenerateHash(string salt, string password)
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

        public override IQueryable<Korisnik> AddInclude(IQueryable<Korisnik> query, KorisniciSearchObject? search = null)
        {
            if (search?.isUlogeIncluded == true)
            {
                query = query.Include("KorisnikUlogas.Uloga");
            }
            return base.AddInclude(query, search);
        }

        public override IQueryable<Korisnik> AddFilter(IQueryable<Korisnik> query, KorisniciSearchObject? search = null)
        {
            if (!string.IsNullOrWhiteSpace(search?.Ime))
            {
                query = query.Where(x => x.Ime.StartsWith(search.Ime));
            }
            if (!string.IsNullOrWhiteSpace(search?.Prezime))
            {
                query = query.Where(x => x.Prezime != null && x.Prezime.StartsWith(search.Prezime));
            }
            if (!string.IsNullOrWhiteSpace(search?.KorisnickoIme))
            {
                query = query.Where(x => x.KorisnickoIme != null && x.KorisnickoIme.StartsWith(search.KorisnickoIme));
            }
            if (search?.Status == true)
            {
                query = query.Where(x => x.Status == true);
            }
            return base.AddFilter(query, search);
        }
        public async Task<Korisnici> Login(string username, string password)
        {
            var entity = await _context.Korisniks.Include("KorisnikUlogas.Uloga").FirstOrDefaultAsync(x => x.KorisnickoIme == username);

            if (entity == null)
            {
                return null;
            }
            //sada password koji je poslan moramo hesirati istim mehanizmom koji je u bazi
            //i ako se hash slaze, mozemo korisnika pustiti
            var hash = GenerateHash(entity.LozinkaSalt, password);

            if (hash != entity.LozinkaHash)
            {
                return null;
            }
            return _mapper.Map<Korisnici>(entity);

        }

    }
}
