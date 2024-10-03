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
    public class ZaposleniciUslugeService : BaseCRUDService<ZaposleniciUsluge, ZaposlenikUsluga, ZaposleniciSearchObject, ZaposleniciUslugeInsertRequest, ZaposleniciUslugeUpdateRequest>, IZaposleniciUslugeService
    {
        public ZaposleniciUslugeService(IB200070Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<ZaposlenikUsluga> AddInclude(IQueryable<ZaposlenikUsluga> query, ZaposleniciSearchObject? search = null)
        {
            if (search?.isKorisnikIncluded == true)
            {
                query = query.Include(c => c.Zaposlenik.Korisnik.SlikaProfila);
            }
            if (search?.isUslugeIncluded == true)
            {
                query = query.Include(x=>x.Usluga);
            }
            return base.AddInclude(query, search);
        }

        public override IQueryable<ZaposlenikUsluga> AddFilter(IQueryable<ZaposlenikUsluga> query, ZaposleniciSearchObject? search = null)
        {
            if (!string.IsNullOrWhiteSpace(search?.FTS))
            {
                query = query.Where(x => (x.Zaposlenik.Korisnik.Ime != null && x.Zaposlenik.Korisnik.Ime.Contains(search.FTS)) 
                || (x.Zaposlenik.Korisnik.Prezime != null && x.Zaposlenik.Korisnik.Prezime.Contains(search.FTS)
                || (x.Usluga.Naziv != null && x.Usluga.Naziv.Contains(search.FTS))));
            }
            return base.AddFilter(query, search);
        }
    }
}
