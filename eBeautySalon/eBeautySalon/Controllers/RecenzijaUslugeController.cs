using eBeautySalon.Models;
using eBeautySalon.Models.Requests;
using eBeautySalon.Models.SearchObjects;
using eBeautySalon.Services;
using Microsoft.AspNetCore.Authorization;
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

        [Authorize]
        public override Task<RecenzijaUsluge> Insert([FromBody] RecenzijaUslugeInsertRequest insert)
        {
            return base.Insert(insert);
        }

        [Authorize]
        public override Task<RecenzijaUsluge> Update(int id, [FromBody] RecenzijaUslugeUpdateRequest update)
        {
            return base.Update(id, update);
        }

        [Authorize]
        public override Task<bool> Delete(int id)
        {
            return base.Delete(id);
        }

        [Authorize]
        [HttpGet("prosjecnaOcjena")]
        public async Task<List<dynamic>> GetProsjecnaOcjena()
        {
            return await _service.GetProsjecneOcjeneUsluga();
        }
    }
}
