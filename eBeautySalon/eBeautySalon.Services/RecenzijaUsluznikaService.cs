using AutoMapper;
using eBeautySalon.Models.Requests;
using eBeautySalon.Models.SearchObjects;
using eBeautySalon.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBeautySalon.Services
{
    public class RecenzijaUsluznikaService : BaseCRUDService<Models.RecenzijaUsluznika, Database.RecenzijaUsluznika, BaseSearchObject, RecenzijaUsluznikaInsertRequest, RecenzijaUsluznikaUpdateRequest>, IRecenzijaUsluznikaService
    {
        public RecenzijaUsluznikaService(BeautySalonContext context, IMapper mapper) : base(context, mapper)
        {
        }
    }
}
