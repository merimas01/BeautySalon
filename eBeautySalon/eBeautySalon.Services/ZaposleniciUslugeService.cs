using AutoMapper;
using eBeautySalon.Models;
using eBeautySalon.Models.Requests;
using eBeautySalon.Models.SearchObjects;
using eBeautySalon.Models.Utils;
using eBeautySalon.Services.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;

namespace eBeautySalon.Services
{
    public class ZaposleniciUslugeService : BaseCRUDService<ZaposleniciUsluge, ZaposlenikUsluga, BaseSearchObject, ZaposleniciUslugeInsertRequest, ZaposleniciUslugeUpdateRequest>, IZaposleniciUslugeService
    {
        public ZaposleniciUslugeService(Ib200070Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public override async Task<bool> AddValidationInsert(ZaposleniciUslugeInsertRequest request)
        {
            //ne moze se dodati ista usluga opet
            var _postojece_usluge = await _context.ZaposlenikUslugas.Where(x => x.ZaposlenikId == request.ZaposlenikId).Select(x => x.UslugaId).ToListAsync();
            if (_postojece_usluge.Contains(request.UslugaId)) return false;

            var _zaposlenik = await _context.Zaposleniks.Where(x => x.ZaposlenikId == request.ZaposlenikId).FirstOrDefaultAsync();
            var _zaposlenik_uloge = await _context.KorisnikUlogas.Where(x => x.KorisnikId == _zaposlenik.KorisnikId).Select(x=>x.UlogaId).ToListAsync();        

            //zaposlenik mora biti usluznik
            if (_zaposlenik_uloge.Contains(Constants.DEFAULT_Uloga_Usluznik))
            {
                //ne mogu se dodati vise od 3 usluge
                if (_postojece_usluge.Count() < 3) 
                    return true; else return false;
            }
            else return false;  
        }

        public override async Task<bool> AddValidationUpdate(int id, ZaposleniciUslugeUpdateRequest request)
        {
            //ne moze se dodati ista usluga opet
            var _postojece_usluge = await _context.ZaposlenikUslugas.Where(x => x.ZaposlenikId == request.ZaposlenikId).Select(x => x.UslugaId).ToListAsync();
            if (_postojece_usluge.Contains(request.UslugaId)) return false;
            
            var _zaposlenik = await _context.Zaposleniks.Where(x => x.ZaposlenikId == request.ZaposlenikId).FirstOrDefaultAsync();
            var _zaposlenik_uloge = await _context.KorisnikUlogas.Where(x => x.KorisnikId == _zaposlenik.KorisnikId).Select(x => x.UlogaId).ToListAsync();

            if (_zaposlenik_uloge.Contains(Constants.DEFAULT_Uloga_Usluznik))
            {
                if (_postojece_usluge.Count() < 3)
                    return true;
                else return false;
            }
            else return false;
        }
    }
}
