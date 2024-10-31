using AutoMapper;
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
    public class RecenzijaUslugeService : BaseCRUDService<Models.RecenzijaUsluge, Database.RecenzijaUsluge, RecenzijaUslugeSearchObject, RecenzijaUslugeInsertRequest, RecenzijaUslugeUpdateRequest>, IRecenzijaUslugeService
    {
        public RecenzijaUslugeService(Ib200070Context context, IMapper mapper) : base(context, mapper)
        {
        }
        public override IQueryable<RecenzijaUsluge> AddInclude(IQueryable<RecenzijaUsluge> query, RecenzijaUslugeSearchObject? search = null)
        {
            if (search?.isKorisnikIncluded == true)
            {
                query = query.Include(x => x.Korisnik.SlikaProfila);
            }
            if (search?.isUslugeIncluded == true)
            {
                query = query.Include(x => x.Usluga);
            }
            return base.AddInclude(query, search);
        }
        public override Task<bool> AddValidationInsert(RecenzijaUslugeInsertRequest request)
        {
            return base.AddValidationInsert(request);
        }

        public override Task<bool> AddValidationUpdate(int id, RecenzijaUslugeUpdateRequest request)
        {
            return base.AddValidationUpdate(id, request);
        }
    }
}
