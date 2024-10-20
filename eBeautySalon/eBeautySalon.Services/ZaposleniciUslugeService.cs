using AutoMapper;
using eBeautySalon.Models;
using eBeautySalon.Models.Requests;
using eBeautySalon.Models.SearchObjects;
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

        public override Task BeforeInsert(ZaposlenikUsluga entity, ZaposleniciUslugeInsertRequest insert)
        {
            
            return base.BeforeInsert(entity, insert);
        }

        public override async Task<bool> AddValidationInsert(ZaposleniciUslugeInsertRequest request)
        {
            var _postojece_usluge = await _context.ZaposlenikUslugas.Where(x => x.ZaposlenikId == request.ZaposlenikId).Select(x => x.UslugaId).ToListAsync();
            if (_postojece_usluge.Count() < 5) return true; else return false;
        }
    }
}
