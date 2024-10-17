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
using System.Text;
using System.Threading.Tasks;

namespace eBeautySalon.Services
{
    public class NovostiService : BaseCRUDService<Novosti, Novost, NovostiSearchObject, NovostiInsertRequest, NovostiUpdateRequest>, INovostiService
    {
        IB200070Context _context;
        public NovostiService(IB200070Context context, IMapper mapper) : base(context, mapper)
        {
            _context = context;
        }

        public override Task BeforeInsert(Novost entity, NovostiInsertRequest insert)
        {
            entity.KorisnikId = _context.Korisniks.Where(x => x.IsAdmin == true).Select(x=>x.KorisnikId).First();
            return base.BeforeInsert(entity, insert);
        }

        public override Task BeforeUpate(Novost entity, NovostiUpdateRequest update)
        {
            entity.KorisnikId = _context.Korisniks.Where(x => x.IsAdmin == true).Select(x => x.KorisnikId).First();
            return base.BeforeUpate(entity, update);
        }

        public override IQueryable<Novost> AddFilter(IQueryable<Novost> query, NovostiSearchObject? search = null)
        {
            if (!string.IsNullOrWhiteSpace(search?.Naslov))
            {
                query = query.Where(x => x.Naslov != null && x.Naslov.StartsWith(search.Naslov));
            }
            if (!string.IsNullOrWhiteSpace(search?.Sadrzaj))
            {
                query = query.Where(x => x.Sadrzaj != null && x.Sadrzaj.Contains(search.Sadrzaj));
            }
            return base.AddFilter(query, search);
        }

        public override IQueryable<Novost> AddInclude(IQueryable<Novost> query, NovostiSearchObject? search = null)
        {
            if (search?.isSlikaIncluded == true)
            {
                query = query.Include(c => c.SlikaNovost);
            }
            if (search?.isKorisnikIncluded == true)
            {
                query = query.Include(c => c.Korisnik);
            }
            return base.AddInclude(query, search);
        }

        public override Task BeforeDelete(Novost entity)
        {
            var slikaNovostId = entity.SlikaNovostId;
            var slikaNovost = _context.SlikaNovosts.Where(x => x.SlikaNovostId == slikaNovostId).First();
            if (slikaNovost != null && slikaNovostId != Constants.DEFAULT_SlikaNovostId)
            {
                _context.Remove(slikaNovost); 
            }
            return base.BeforeDelete(entity);
        }
    }
}
