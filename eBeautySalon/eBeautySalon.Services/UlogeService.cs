﻿using eBeautySalon.Models.Requests;
using eBeautySalon.Models.SearchObjects;
using eBeautySalon.Models;
using eBeautySalon.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AutoMapper;
using Microsoft.EntityFrameworkCore;
using System.Text.RegularExpressions;

namespace eBeautySalon.Services
{
    public class UlogeService : BaseCRUDService<Uloge, Uloga, UlogeSearchObject, UlogeInsertRequest, UlogeUpdateRequest>, IUlogeService
    {
        public UlogeService(Ib200070Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Uloga> AddFilter(IQueryable<Uloga> query, UlogeSearchObject? search = null)
        {
            query = query.Where(x => x.Naziv != "Administrator");
            if (!string.IsNullOrWhiteSpace(search.FTS))
            {
                query = query.Where(x => x.Naziv.StartsWith(search.FTS) || x.Opis.StartsWith(search.FTS)
                || (x.Sifra != null && x.Sifra.Contains(search.FTS)));
            }
            return base.AddFilter(query, search);
        }

        public override async Task<bool> AddValidationInsert(UlogeInsertRequest request)
        {
            //ne smije se dodati vec postojeca uloga
            //naziv ne smije biti prazan
            string naziv_opis_nedozvoljen_pattern = @"^[@#$?!%()\d~°^ˇ`˙´.;:,'<>+=*]+$";
            var uloge_nazivi = await _context.Ulogas.Select(x=>x.Naziv.ToLower()).ToListAsync();
            if (string.IsNullOrWhiteSpace(request.Naziv) || Regex.IsMatch(request.Naziv, naziv_opis_nedozvoljen_pattern)) return false;
            if (request.Opis != null && Regex.IsMatch(request.Opis, naziv_opis_nedozvoljen_pattern)) return false;
            if (uloge_nazivi.Contains(request.Naziv.ToLower())) return false;
            return true;
        }
        public override async Task<bool> AddValidationUpdate(int id, UlogeUpdateRequest request)
        {
            //ne smije se dodati vec postojeca uloga
            //naziv ne smije biti prazan
            string naziv_opis_nedozvoljen_pattern = @"^[@#$?!%()\d~°^ˇ`˙´.;:,'<>+=*]+$";
            var uloge_nazivi = await _context.Ulogas.Where(x=>x.UlogaId != id).Select(x => x.Naziv.ToLower()).ToListAsync();
            if (string.IsNullOrWhiteSpace(request.Naziv) || Regex.IsMatch(request.Naziv, naziv_opis_nedozvoljen_pattern)) return false;
            if (request.Opis != null && Regex.IsMatch(request.Opis, naziv_opis_nedozvoljen_pattern)) return false;
            if (uloge_nazivi.Contains(request.Naziv.ToLower())) return false;
            return true;
        }

        public override Task BeforeUpate(Uloga entity, UlogeUpdateRequest update)
        {
            if (string.IsNullOrWhiteSpace(update.Opis))
            {
                update.Opis = entity.Opis;
            }
            return base.BeforeUpate(entity, update);
        }

        public override async Task<bool> AddValidationDelete(int id)
        {
            //ne moze se obrisati uloga koju neko koristi.
            var korisniciUloge = await _context.KorisnikUlogas.Where(x=>x.UlogaId == id).ToListAsync();
            if(korisniciUloge.Count() != 0) return false;   
            return true;
        }

        public override async Task<Uloga> AddIncludeForGetById(IQueryable<Uloga> query, int id)
        {
            var entity = await query.FirstOrDefaultAsync(x => x.UlogaId == id);
            return entity;
        }

        public override async Task AfterInsert(Uloga entity, UlogeInsertRequest insert)
        {
            entity.Sifra = "UL" + entity.UlogaId.ToString("D6");
        }
    }
}
