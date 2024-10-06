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

        public override IQueryable<Zaposlenik> AddFilter(IQueryable<Zaposlenik> query, ZaposleniciSearchObject? search = null)
        {
            if (!string.IsNullOrWhiteSpace(search?.FTS))
            {
                query = query.Where(x => (x.Korisnik.Ime != null && x.Korisnik.Ime.Contains(search.FTS))
                || (x.Korisnik.Prezime != null && x.Korisnik.Prezime.Contains(search.FTS)
                || (x.Korisnik.KorisnikUlogas !=null && x.Korisnik.KorisnikUlogas.Select(y=>y.Uloga.Naziv).Contains(search.FTS))
                || (x.ZaposlenikUslugas != null && x.ZaposlenikUslugas.Select(z => z.Usluga.Naziv).Contains(search.FTS))
               ));
            }
            return base.AddFilter(query, search);
        }
        public override IQueryable<Zaposlenik> AddInclude(IQueryable<Zaposlenik> query, ZaposleniciSearchObject? search = null)
        {
            if (search?.isKorisnikIncluded == true)
            {
                query = query.Include("Korisnik.KorisnikUlogas.Uloga");
                query = query.Include("Korisnik.SlikaProfila");
            }
            if (search?.isUslugeIncluded == true)
            {
                query = query.Include("ZaposlenikUslugas.Usluga");
            }
            return base.AddInclude(query, search);
        }
    }
}
