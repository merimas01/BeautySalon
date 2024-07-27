using eBeautySalon.Models;
using eBeautySalon.Models.Requests;
using eBeautySalon.Models.SearchObjects;
using eBeautySalon.Services;
using Microsoft.AspNetCore.Mvc;

namespace eBeautySalon.Controllers
{
    [ApiController]
    public class RecenzijaUsluznikaController : BaseCRUDController<Models.RecenzijaUsluznika, BaseSearchObject, RecenzijaUsluznikaInsertRequest, RecenzijaUsluznikaUpdateRequest>
    {
        public RecenzijaUsluznikaController(ILogger<BaseCRUDController<Models.RecenzijaUsluznika, BaseSearchObject, RecenzijaUsluznikaInsertRequest, RecenzijaUsluznikaUpdateRequest>> logger, IRecenzijaUsluznikaService service)
            : base(logger, service)
        {
        }
    }
}
