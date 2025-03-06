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

        public override async Task BeforeDelete(Novost entity)
        {
            var slikaNovostId = entity.SlikaNovostId;
            var slikaNovost = await _context.SlikaNovosts.Where(x => x.SlikaNovostId == slikaNovostId).FirstAsync();
            var novostLikeComment = await _context.NovostLikeComments.Where(x => x.NovostId == entity.NovostId).ToListAsync();
           
            if (slikaNovost != null && slikaNovostId != Constants.DEFAULT_SlikaUslugeId)
            {
                _context.Remove(slikaNovost); //deleta se ovaj objekat jer se nece koristiti vise
            }
            foreach (var item in novostLikeComment)
            {
                _context.Remove(item);
            }
        }
        public override IQueryable<Novost> AddFilter(IQueryable<Novost> query, NovostiSearchObject? search = null)
        {
            query = query.OrderByDescending(x => x.NovostId);
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
            if (search.DatumOpadajuciSort == true)
            {
                query = query.OrderByDescending(x => x.DatumKreiranja);
            }
            if (search.DatumOpadajuciSort == false)
            {
                query = query.OrderBy(x => x.DatumKreiranja);
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
                temp = await novosti.ToListAsync();
            }
            else if (listaCount <= 2)
            {
                number = 2;
                var novosti = _context.Novosts.Include(x => x.SlikaNovost).OrderByDescending(x => x.DatumKreiranja).Take(number);
                temp = await novosti.ToListAsync();
            }
            else if(listaCount == 1)
            {
                number = 1;
                var novosti = _context.Novosts.Include(x => x.SlikaNovost).OrderByDescending(x => x.DatumKreiranja).Take(number);
                temp = await novosti.ToListAsync();
            }     
            pagedResult.Result = _mapper.Map<List<Novosti>>(temp);
            pagedResult.Count = number;
            return pagedResult;
        }

        public override async Task<Novost> AddIncludeForGetById(IQueryable<Novost> query, int id)
        {
            query = query.Include(c => c.SlikaNovost);
            query = query.Include(c => c.Korisnik);
            var entity = await query.FirstOrDefaultAsync(x => x.NovostId == id);
            return entity;
        }

        public override async Task AfterInsert(Novost entity, NovostiInsertRequest insert)
        {
            entity.Sifra = "N" + entity.NovostId.ToString("D6");
        }
    }
}
