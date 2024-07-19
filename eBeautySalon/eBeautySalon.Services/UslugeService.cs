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
    public class UslugeService : BaseCRUDService<Usluge,Usluga, UslugeSearchObject, UslugeInsertRequest, UslugeUpdateRequest> , IUslugeService
    {
        public UslugeService(BeautySalonContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Usluga> AddFilter(IQueryable<Usluga> query, UslugeSearchObject? search = null)
        {
            if (!string.IsNullOrWhiteSpace(search?.Naziv))
            {
                query = query.Where(x => x.Naziv != null && x.Naziv.StartsWith(search.Naziv));
            }
            if (!string.IsNullOrWhiteSpace(search?.Opis))
            {
                query = query.Where(x => x.Opis != null && x.Opis.Contains(search.Opis));
            }
            if (search?.Cijena != null)
            {
                query = query.Where(x => x.Cijena == search.Cijena);
            }
            return base.AddFilter(query, search);
        }

        public override IQueryable<Usluga> AddInclude(IQueryable<Usluga> query, UslugeSearchObject? search = null)
        {
            if (search?.isKategorijaIncluded == true)
            {
                query = query.Include(c => c.Kategorija);
            }
            if (search?.isSlikaIncluded == true)
            {
                query = query.Include(c => c.SlikaUsluge);
            }
            return base.AddInclude(query, search);
        }
    }
}
