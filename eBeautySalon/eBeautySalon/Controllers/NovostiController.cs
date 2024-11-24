using eBeautySalon.Models;
using eBeautySalon.Models.Requests;
using eBeautySalon.Models.SearchObjects;
using eBeautySalon.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eBeautySalon.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class NovostiController : BaseCRUDController<Novosti, NovostiSearchObject, NovostiInsertRequest, NovostiUpdateRequest>
    {
        INovostiService _service;
        public NovostiController(ILogger<BaseCRUDController<Novosti, NovostiSearchObject, NovostiInsertRequest, NovostiUpdateRequest>> logger, INovostiService service)
            : base(logger, service)
        {
            _service = service;
        }

        [Authorize(Roles = "Administrator")] 
        public override Task<Novosti> Insert(NovostiInsertRequest insert)
        {
            return base.Insert(insert);
        }

        [Authorize(Roles = "Administrator")]
        public override Task<Novosti> Update(int id, [FromBody] NovostiUpdateRequest update)
        {
            return base.Update(id, update);
        }

        [HttpGet("lastNews")]
        public Task<PagedResult<Novosti>> GetLastThreeNovosti()
        {
            return _service.GetLastThreeNovosti();
        }
    }
}
