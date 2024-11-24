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
        Ib200070Context _context;
        public NovostiService(Ib200070Context context, IMapper mapper) : base(context, mapper)
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
            var slikaNovost = _context.SlikaNovosts.Where(x=>x.SlikaNovostId == entity.SlikaNovostId).First();
            if (update.SlikaNovostId == Constants.DEFAULT_SlikaNovostId)
            {
                _context.Remove(slikaNovost);
            }
            return base.BeforeUpate(entity, update);
        }
        public override async Task BeforeDelete(Novost entity)
        {
            var slikaNovostId = entity.SlikaNovostId;
            var slikaNovost = await _context.SlikaNovosts.Where(x => x.SlikaNovostId == slikaNovostId).FirstAsync();
           
            if (slikaNovost != null && slikaNovostId != Constants.DEFAULT_SlikaUslugeId)
            {
                _context.Remove(slikaNovost); //deleta se ovaj objekat jer se nece koristiti vise
            }    
        }
        public override IQueryable<Novost> AddFilter(IQueryable<Novost> query, NovostiSearchObject? search = null)
        {
            if (!string.IsNullOrWhiteSpace(search?.FTS))
            {
                query = query.Where(x => (x.Naslov != null && x.Naslov.ToLower().Contains(search.FTS.ToLower()))
                || (x.Sadrzaj != null && x.Sadrzaj.ToLower().Contains(search.FTS.ToLower()))
                || (x.Sifra != null && x.Sifra.Contains(search.FTS)));
            }
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

        public override async Task<bool> AddValidationInsert(NovostiInsertRequest request)
        {
            var novost_naslovi = await _context.Novosts.Select(x => x.Naslov.ToLower()).ToListAsync();
            if (novost_naslovi.Contains(request.Naslov.ToLower())) return false; else return true;
        }

        public override async Task<bool> AddValidationUpdate(int id, NovostiUpdateRequest request)
        {
            var novost_naslovi = await _context.Novosts.Where(x=>x.NovostId != id).Select(x => x.Naslov.ToLower()).ToListAsync();
            if (novost_naslovi.Contains(request.Naslov.ToLower())) return false; else return true;
        }

        public async Task<PagedResult<Novosti>> GetLastThreeNovosti()
        {
            //obzirom da se datumi ne mogu modifikovati, najmladji datumi su oni koji su posljednji dodani
            var number = 0;
            var listaCount = _context.Novosts.ToList().Count();
            var pagedResult = new PagedResult<Novosti>();
            var temp = new List<Database.Novost>();

            if (listaCount >= 3)
            {
                number = 3;
                var novosti = _context.Novosts.Include(x => x.SlikaNovost).OrderByDescending(x => x.DatumKreiranja).Take(number);
                temp = novosti.ToList();
            }
            else if (listaCount <= 2)
            {
                number = 2;
                var novosti = _context.Novosts.Include(x => x.SlikaNovost).OrderByDescending(x => x.DatumKreiranja).Take(number);
                temp = novosti.ToList();
            }
            else if(listaCount == 1)
            {
                number = 1;
                var novosti = _context.Novosts.Include(x => x.SlikaNovost).OrderByDescending(x => x.DatumKreiranja).Take(number);
                temp = novosti.ToList();
            }     
            pagedResult.Result = _mapper.Map<List<Novosti>>(temp);
            pagedResult.Count = number;
            return pagedResult;
        }
    }
}
