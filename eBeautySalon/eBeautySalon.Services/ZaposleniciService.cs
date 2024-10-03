using AutoMapper;
using eBeautySalon.Models;
using eBeautySalon.Models.Requests;
using eBeautySalon.Models.SearchObjects;
using eBeautySalon.Services.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBeautySalon.Services
{
    public class ZaposleniciService : BaseCRUDService<Zaposlenici, Zaposlenik, ZaposleniciSearchObject, ZaposleniciInsertRequest, ZaposleniciUpdateRequest>, IZaposleniciService
    {
        public ZaposleniciService(IB200070Context context, IMapper mapper) : base(context, mapper)
        {
        }

        //public override IQueryable<Zaposlenik> AddInclude(IQueryable<Zaposlenik> query, ZaposleniciSearchObject? search = null)
        //{
        //    if (search?.isKorisnikIncluded == true)
        //    {
        //        query = query.Include(c=>c.Korisnik);
        //    }
        //    if (search?.isUslugeIncluded == true)
        //    {
        //        query = query.Include("ZaposlenikUslugas.Usluga");
        //    }
        //    return base.AddInclude(query, search);
        //}
    }
}
