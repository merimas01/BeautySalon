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
    public class RecenzijaUsluznikaService : BaseCRUDService<Models.RecenzijaUsluznika, Database.RecenzijaUsluznika, RecenzijaUsluznikaSearchObject, RecenzijaUsluznikaInsertRequest, RecenzijaUsluznikaUpdateRequest>, IRecenzijaUsluznikaService
    {
        public RecenzijaUsluznikaService(Ib200070Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<RecenzijaUsluznika> AddInclude(IQueryable<RecenzijaUsluznika> query, RecenzijaUsluznikaSearchObject? search = null)
        {
            if (search?.isKorisnikIncluded == true)
            {
                query = query.Include(x => x.Korisnik.SlikaProfila);
            }
            if (search?.isZaposlenikIncluded == true)
            {
                query = query.Include(x => x.Usluznik.Korisnik.SlikaProfila);
            }
            return base.AddInclude(query, search);
        }

        public override Task<bool> AddValidationInsert(RecenzijaUsluznikaInsertRequest request)
        {
            return base.AddValidationInsert(request);
        }

        public override Task<bool> AddValidationUpdate(int id, RecenzijaUsluznikaUpdateRequest request)
        {
            return base.AddValidationUpdate(id, request);
        }
    }
}
