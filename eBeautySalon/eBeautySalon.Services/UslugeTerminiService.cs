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
    public class UslugeTerminiService : BaseCRUDService<UslugeTermini, UslugaTermin, UslugeTerminiSearchObject, UslugeTerminiInsertRequest, UslugeTerminiUpdateRequest>, IUslugeTerminiService
    {
        public UslugeTerminiService(Ib200070Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<UslugaTermin> AddFilter(IQueryable<UslugaTermin> query, UslugeTerminiSearchObject? search = null)
        {
            if(search.uslugaId != null)
            {
                query = query.Where(x => x.UslugaId == search.uslugaId).AsQueryable();
            }
            if (search.isPrikazan == true)
            {
                query = query.Where(x => x.IsPrikazan == true);
            }
            if (search.isPrikazan == false)
            {
                query = query.Where(x => x.IsPrikazan == false);
            }
            return base.AddFilter(query, search);
        }

        public override IQueryable<UslugaTermin> AddInclude(IQueryable<UslugaTermin> query, UslugeTerminiSearchObject? search = null)
        {
            if ( search.isUslugaIncluded == true)
            {
                query = query.Include(x => x.Usluga.SlikaUsluge);
                query = query.Include(x => x.Usluga.Kategorija);
            }
            if ( search.isTerminIncluded == true)
            {
                query = query.Include(x => x.Termin);
            }     
            return base.AddInclude(query, search);
        }

        public override async Task<bool> AddValidationInsert(UslugeTerminiInsertRequest request)
        {
            var uslugeTermini = await _context.UslugaTermins.ToListAsync();
            foreach (var item in uslugeTermini)
            {
                if (item.TerminId == request.TerminId && item.UslugaId == request.UslugaId)
                    return false;
            }
            return true;
        }

        public override async Task<bool> AddValidationUpdate(int id, UslugeTerminiUpdateRequest request)
        {
            var uslugeTermini = await _context.UslugaTermins.Where(x=>x.UslugaTerminId != id).ToListAsync();
            foreach (var item in uslugeTermini)
            {
                if (item.TerminId == request.TerminId && item.UslugaId == request.UslugaId)
                    return false;
            }
            return true;
        }

        public override List<UslugaTermin> SortAZ(List<UslugaTermin> list)
        {
            if(list.Count()!=0 && list[0].Termin != null) {
                var sortedTimes = list
               .OrderBy(t => TimeSpan.Parse(t.Termin.Opis))
               .ToList();     
            }
            return list;
        }

        public override async Task<UslugaTermin> AddIncludeForGetById(IQueryable<UslugaTermin> query, int id)
        {
            query = query.Include(x => x.Usluga.Kategorija);
            query = query.Include(x => x.Usluga.SlikaUsluge);
            query = query.Include(x => x.Termin);
            var entity = await query.FirstOrDefaultAsync(x => x.UslugaTerminId == id);
            return entity;
        }
    }
}
