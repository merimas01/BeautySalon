using AutoMapper;
using eBeautySalon.Models;
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
    public class KategorijeService : BaseService<Kategorije,Kategorija,KategorijeSearchObject>, IKategorijeService
    {
        public KategorijeService(BeautySalonContext context, IMapper mapper) : base(context,mapper)
        {
        }

        public override IQueryable<Kategorija> AddFilter(IQueryable<Kategorija> query, KategorijeSearchObject? search = null)
        {
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
    }
}
