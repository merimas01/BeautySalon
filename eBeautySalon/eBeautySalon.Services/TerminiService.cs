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
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace eBeautySalon.Services
{
    public class TerminiService : BaseCRUDService<Termini, Termin, BaseSearchObject, TerminiInsertRequest, TerminiUpdateRequest>, ITerminiService
    {
        public TerminiService(Ib200070Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public override async Task<bool> AddValidationInsert(TerminiInsertRequest request)
        {
            var termini = await _context.Termins.Select(x => x.Opis).ToListAsync();
            string termin_opis_pattern = @"^(0[6-9]|1[0-9]|2[0-2]):([0-5][0-9])$";
            if (termini.Contains(request.Opis)) return false;
            if (string.IsNullOrWhiteSpace(request.Opis) || !Regex.IsMatch(request.Opis, termin_opis_pattern)) return false;
            return true;
        }

        public override async Task<bool> AddValidationUpdate(int id, TerminiUpdateRequest request)
        {
            var termini = await _context.Termins.Where(x=>x.TerminId != id).Select(x => x.Opis).ToListAsync();
            string termin_opis_pattern = @"^(0[6-9]|1[0-9]|2[0-2]):([0-5][0-9])$";
            if (termini.Contains(request.Opis)) return false;
            if (string.IsNullOrWhiteSpace(request.Opis) || !Regex.IsMatch(request.Opis, termin_opis_pattern)) return false;
            return true;
        }

        public override List<Termin> SortAZ(List<Termin> list)
        {
            var sortedTimes = list
            .OrderBy(t => TimeSpan.Parse(t.Opis))
            .ToList();
            return list;
        }

        public override async Task<Termin> AddIncludeForGetById(IQueryable<Termin> query, int id)
        {
            var entity = await query.FirstOrDefaultAsync(x => x.TerminId == id);
            return entity;
        }

        public override async Task AfterInsert(Termin entity, TerminiInsertRequest insert)
        {
            entity.Sifra = "T" + entity.TerminId.ToString("D6");
        }
    }
}
