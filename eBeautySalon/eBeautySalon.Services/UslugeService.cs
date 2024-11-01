using AutoMapper;
using eBeautySalon.Models;
using eBeautySalon.Models.Requests;
using eBeautySalon.Models.SearchObjects;
using eBeautySalon.Services.Database;
using eBeautySalon.Models.Utils;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory;

namespace eBeautySalon.Services
{
    public class UslugeService : BaseCRUDService<Usluge, Usluga, UslugeSearchObject, UslugeInsertRequest, UslugeUpdateRequest>, IUslugeService
    {
        public UslugeService(Ib200070Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public override async Task BeforeInsert(Usluga entity, UslugeInsertRequest insert)
        {
            if (insert.SlikaUslugeId == null || insert.SlikaUslugeId == 0)
                entity.SlikaUslugeId = _context.SlikaUsluges.Select(x => x.SlikaUslugeId).First();          
        }

        public override async Task BeforeUpate(Usluga entity, UslugeUpdateRequest update)
        {
            if (update.SlikaUslugeId == null || update.SlikaUslugeId == 0)
                entity.SlikaUslugeId = _context.SlikaUsluges.Select(x => x.SlikaUslugeId).First();  
        }

        public override async Task BeforeDelete(Usluga entity)
        {
            var slikaUslugeId = entity.SlikaUslugeId;
            var slikaUsluge = await _context.SlikaUsluges.Where(x => x.SlikaUslugeId == slikaUslugeId).FirstAsync();
            var recenzije_usluga = await _context.RecenzijaUsluges.Where(x => x.UslugaId == entity.UslugaId).ToListAsync();
            if (slikaUsluge != null && slikaUslugeId != Constants.DEFAULT_SlikaUslugeId) { 
                _context.Remove(slikaUsluge); //deleta se ovaj objekat jer se nece koristiti vise
            }
            foreach (var item in recenzije_usluga)
            {
                _context.Remove(item);
            }
        }

        public override async Task<bool> AddValidationInsert(UslugeInsertRequest insert)
        {
            var usluga_nazivi = await _context.Uslugas.Select(x => x.Naziv.ToLower()).ToListAsync();
            if (usluga_nazivi.Contains(insert.Naziv.ToLower())) return false; else return true;
        }

        public override async Task<bool> AddValidationUpdate(int id, UslugeUpdateRequest request)
        {
            var usluga_nazivi = await _context.Uslugas.Where(x => x.UslugaId != id).Select(x => x.Naziv.ToLower()).ToListAsync();
            if (usluga_nazivi.Contains(request.Naziv.ToLower())) return false; else return true;
        }

        public override IQueryable<Usluga> AddFilter(IQueryable<Usluga> query, UslugeSearchObject? search = null)
        {
            if (!string.IsNullOrWhiteSpace(search?.FTS))
            {
                query = query.Where(x => (x.Naziv != null && x.Naziv.ToLower().Contains(search.FTS.ToLower())) 
                || (x.Opis!=null && x.Opis.ToLower().Contains(search.FTS.ToLower())
                || (x.Cijena.ToString().Contains(search.FTS)) || (x.Kategorija.Naziv != null && x.Kategorija.Naziv.Contains(search.FTS))));
            }
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
