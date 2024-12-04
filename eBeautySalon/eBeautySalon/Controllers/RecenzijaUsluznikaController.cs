using eBeautySalon.Models;
using eBeautySalon.Models.Requests;
using eBeautySalon.Models.SearchObjects;
using eBeautySalon.Services;
using Microsoft.AspNetCore.Authorization;
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

        [Authorize]
        public override Task<RecenzijaUsluznika> Insert([FromBody] RecenzijaUsluznikaInsertRequest insert)
        {
            return base.Insert(insert);
        }

        [Authorize]
        public override Task<RecenzijaUsluznika> Update(int id, [FromBody] RecenzijaUsluznikaUpdateRequest update)
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
        public async Task<List<dynamic>> GetProsjecnaUsluznika()
        {
            return await _service.GetProsjecneOcjeneUsluznika();
        }

        [Authorize]
        [HttpGet("recenzijeUsluznika/{korisnikId}")]
        public async Task<Models.PagedResult<Models.RecenzijaUsluznika>> GetRecenzijeUsluznikaByKorisnikId(int korisnikId, [FromQuery] string? FTS)
        {
            return await _service.GetRecenzijeUsluznikaByKorisnikId(korisnikId, FTS);
        }
    }
}
