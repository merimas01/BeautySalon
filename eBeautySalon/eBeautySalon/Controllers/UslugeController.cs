using eBeautySalon.Models;
using eBeautySalon.Models.Requests;
using eBeautySalon.Models.SearchObjects;
using eBeautySalon.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eBeautySalon.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class UslugeController : BaseCRUDController<Usluge,UslugeSearchObject,UslugeInsertRequest,UslugeUpdateRequest>
    {
        IUslugeService _service;
        public UslugeController(ILogger<BaseCRUDController<Usluge, UslugeSearchObject, UslugeInsertRequest, UslugeUpdateRequest>> logger, IUslugeService service) :base(logger,service)
        {
            _service = service;
        }

        [Authorize(Roles = "Administrator")]
        public override Task<Usluge> Insert([FromBody] UslugeInsertRequest insert)
        {
            return base.Insert(insert);
        }

        [Authorize(Roles = "Administrator")]
        public override Task<Usluge> Update(int id, [FromBody] UslugeUpdateRequest update)
        {
            return base.Update(id, update);
        }

        [Authorize(Roles = "Administrator")]
        public override Task<bool> Delete(int id)
        {
            return base.Delete(id);
        }

        [Authorize]
        [HttpGet("recommend/{uslugaId}/{korisnikId}")]
        public async Task<List<Models.Usluge>> Recommend(int uslugaId, int korisnikId)
        {
            return await _service.Recommend(uslugaId, korisnikId);
        }
    }
}
