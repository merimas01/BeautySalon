using eBeautySalon.Models;
using eBeautySalon.Models.SearchObjects;
using eBeautySalon.Services;
using Microsoft.AspNetCore.Mvc;

namespace eBeautySalon.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class StatusiController : BaseController<Models.Statusi, BaseSearchObject>
    {
        IStatusService _service;
        public StatusiController(ILogger<BaseController<Statusi, BaseSearchObject>> logger, IStatusService service) : base(logger, service)
        {
            _service = service;
        }

        [HttpGet("GetStatuse")]
        public Task<PagedResult<Statusi>> GetStatuse([FromQuery] BaseSearchObject search)
        {
            return _service.GetStatuse(search);
        }
    }
}

