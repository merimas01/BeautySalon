using AutoMapper;
using Azure.Core;
using eBeautySalon.Models;
using eBeautySalon.Models.Requests;
using eBeautySalon.Models.SearchObjects;
using eBeautySalon.Services.Database;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace eBeautySalon.Services
{
    public class KorisniciService : BaseCRUDService<Korisnici, Korisnik, KorisniciSearchObject, KorisniciInsertRequest, KorisniciUpdateRequest>, IKorisniciService
    {
        public KorisniciService(Ib200070Context context, IMapper mapper): base(context,mapper)
        {
        }

        public override async Task BeforeInsert(Korisnik korisnik, KorisniciInsertRequest request)
        {
            korisnik.LozinkaSalt = GenerateSalt();
            korisnik.LozinkaHash = GenerateHash(korisnik.LozinkaSalt, request.Password);   
        }

        public override async Task<bool> AddValidationInsert(KorisniciInsertRequest insert)
        {
            var korisnici_telefoni = await _context.Korisniks.Select(x => x.Telefon.Replace("-", " ")).ToListAsync();
            var korisnici_emailovi = await _context.Korisniks.Select(x => x.Email.ToLower()).ToListAsync();
            var korisnici_korisnickoIme = await _context.Korisniks.Select(x => x.KorisnickoIme.ToLower()).ToListAsync();
            
            if (korisnici_korisnickoIme.Contains(insert.KorisnickoIme.ToLower())
                || (insert.Telefon != null && korisnici_telefoni.Contains(insert.Telefon))
                || (insert.Email != null && korisnici_emailovi.Contains(insert.Email.ToLower())))
                return  false;
            else return true;
        }

        public override async Task<bool> AddValidationUpdate(int id, KorisniciUpdateRequest request)
        {
            var korisnici_telefoni = await _context.Korisniks.Where(x=>x.KorisnikId != id).Select(x => x.Telefon.Replace("-", " ")).ToListAsync();
            var korisnici_emailovi = await _context.Korisniks.Where(x => x.KorisnikId != id).Select(x => x.Email.ToLower()).ToListAsync();

            if ((request.Telefon!=null && korisnici_telefoni.Contains(request.Telefon))
                || ( request.Email!=null && korisnici_emailovi.Contains(request.Email.ToLower())))
                return false;
            else return true;
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

        public override async Task<Korisnik> AddIncludeForGetById(IQueryable<Korisnik> query, int id)
        {
            query = query.Include("KorisnikUlogas.Uloga");
            query = query.Include("SlikaProfila");
            var entity = await query.FirstOrDefaultAsync(x => x.KorisnikId == id);
            return entity;
        }

        public override IQueryable<Korisnik> AddInclude(IQueryable<Korisnik> query, KorisniciSearchObject? search = null)
        {
            if (search?.isUlogeIncluded == true)
            {
                query = query.Include("KorisnikUlogas.Uloga");
            }
            if (search?.isSlikaIncluded == true)
            {
                query = query.Include("SlikaProfila");
            }
            if (search?.isAdmin == false)
            {
                query = query.Where(x => x.IsAdmin == false).AsQueryable();
            }
            return base.AddInclude(query, search);
        }

        public override IQueryable<Korisnik> AddFilter(IQueryable<Korisnik> query, KorisniciSearchObject? search = null)
        {
            if (!string.IsNullOrWhiteSpace(search?.FTS))
            {
                query = query.Where(x => (x.Ime != null && x.Ime.ToLower().Contains(search.FTS.ToLower())) 
                || (x.Prezime != null && x.Prezime.ToLower().Contains(search.FTS.ToLower())
                || (x.KorisnickoIme != null && x.KorisnickoIme.ToLower().Contains(search.FTS.ToLower()))));
            }
            if(search.isAdmin==false && search.isZaposlenik == false)
            {
                query = query.Include("KorisnikUlogas.Uloga").Include(x=>x.SlikaProfila).Where(x => x.IsAdmin == false && x.KorisnikUlogas.Count() == 0); //ako nema nijedne uloge, onda je obicni korisnik (nije ni admin ni zaposlenik)
            }
            if(search.isBlokiran == "da")
            {
                query = query.Where(x => x.Status == false);
            }
            if(search.isBlokiran == "ne")
            {
                query = query.Where(x => x.Status == true);
            }
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
