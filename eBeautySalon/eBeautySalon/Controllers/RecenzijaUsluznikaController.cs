using eBeautySalon.Models;
using eBeautySalon.Models.Requests;
using eBeautySalon.Models.SearchObjects;
using eBeautySalon.Services;
using Microsoft.AspNetCore.Mvc;

namespace eBeautySalon.Controllers
{
    [ApiController]
    public class RecenzijaUsluznikaController : BaseCRUDController<Models.RecenzijaUsluznika, RecenzijaUsluznikaSearchObject, RecenzijaUsluznikaInsertRequest, RecenzijaUsluznikaUpdateRequest>
    {
        IRecenzijaUsluznikaService _service;
        public RecenzijaUsluznikaController(ILogger<BaseCRUDController<Models.RecenzijaUsluznika, RecenzijaUsluznikaSearchObject, RecenzijaUsluznikaInsertRequest, RecenzijaUsluznikaUpdateRequest>> logger, IRecenzijaUsluznikaService service)
            : base(logger, service)
        {
            _service = service;
        }

        [HttpGet("prosjecnaOcjena")]
        public async Task<List<dynamic>> GetProsjecnaUsluznika()
        {
            return await _service.GetProsjecneOcjeneUsluznika();
        }
    }
}
