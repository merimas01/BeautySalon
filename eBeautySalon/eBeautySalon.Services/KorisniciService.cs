using AutoMapper;
using eBeautySalon.Models;
using eBeautySalon.Models.Requests;
using eBeautySalon.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace eBeautySalon.Services
{
    public class KorisniciService : IKorisniciService
    {
        BeautySalonContext _context;
        public IMapper _mapper { get; set; }

        public KorisniciService(BeautySalonContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }

        public List<Korisnici> Get()
        {
            var entityList = _context.Korisniks.ToList();
            return _mapper.Map<List<Korisnici>>(entityList);

        }

        public Korisnici Insert(KorisniciInsertRequest request)
        {
            var korisnik = new Korisnik(); 
            _mapper.Map(request, korisnik);

            korisnik.LozinkaSalt = GenerateSalt();
            korisnik.LozinkaHash = GenerateHash(korisnik.LozinkaSalt, request.Password);

            _context.Korisniks.Add(korisnik); 
            _context.SaveChanges(); 

            return _mapper.Map<Korisnici>(korisnik); 
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

        public Korisnici Update(int id, KorisniciUpdateRequest request)
        {
            var korisnik = _context.Korisniks.Find(id);

            if (korisnik != null)
            {
                _mapper.Map(request, korisnik); 
            
                _context.SaveChanges();

                return _mapper.Map<Models.Korisnici>(korisnik);
            }

            return new Models.Korisnici();
        }

    }
}
