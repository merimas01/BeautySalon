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
    public class KategorijeService : BaseCRUDService<Kategorije,Kategorija,KategorijeSearchObject, KategorijeInsertRequest, KategorijeUpdateRequest>, IKategorijeService
    {
        public KategorijeService(IB200070Context context, IMapper mapper) : base(context,mapper)
        {
        }

        public override IQueryable<Kategorija> AddFilter(IQueryable<Kategorija> query, KategorijeSearchObject? search = null)
        {
            if (!string.IsNullOrWhiteSpace(search?.FTS))
            {
                query = query.Where(x => x.Naziv.Contains(search.FTS) || (x.Opis != null && x.Opis.Contains(search.FTS)));
            }
            if (!string.IsNullOrWhiteSpace(search?.Naziv))
            {
                query = query.Where(x => x.Naziv.StartsWith(search.Naziv));
            }
            if (!string.IsNullOrWhiteSpace(search?.Opis))
            {
                query = query.Where(x => x.Opis != null && x.Opis.StartsWith(search.Opis));
            }
           
            return base.AddFilter(query, search);
        }

        public override async Task<bool> AddValidationInsert(KategorijeInsertRequest request)
        {
            var kategorija_nazivi = await _context.Kategorijas.Select(x => x.Naziv.ToLower()).ToListAsync();
            if (kategorija_nazivi.Contains(request.Naziv.ToLower())) return false; else return true;
        }

        public override async Task<bool> AddValidationUpdate(int id, KategorijeUpdateRequest request)
        {
            var kategorija_nazivi = await _context.Kategorijas.Where(x => x.KategorijaId != id).Select(x => x.Naziv.ToLower()).ToListAsync();
            if (kategorija_nazivi.Contains(request.Naziv.ToLower())) return false; else return true;
        }
     
    }
}
