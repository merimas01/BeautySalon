using eBeautySalon.Models;
using eBeautySalon.Models.Requests;
using eBeautySalon.Models.SearchObjects;
using eBeautySalon.Services;
using Microsoft.AspNetCore.Mvc;

namespace eBeautySalon.Controllers
{
    [ApiController]
    public class RecenzijaUslugeController : BaseCRUDController<Models.RecenzijaUsluge, RecenzijaUslugeSearchObject, RecenzijaUslugeInsertRequest, RecenzijaUslugeUpdateRequest>
    {
        IRecenzijaUslugeService _service;
        public RecenzijaUslugeController(ILogger<BaseCRUDController<Models.RecenzijaUsluge, RecenzijaUslugeSearchObject, RecenzijaUslugeInsertRequest, RecenzijaUslugeUpdateRequest>> logger, IRecenzijaUslugeService service)
            : base(logger, service)
        {
            _service = service;
        }

        [HttpGet("prosjecnaOcjena")]
        public async Task<List<dynamic>> GetProsjecnaOcjena()
        {
            return await _service.GetProsjecneOcjeneUsluga();
        }
    }
}
