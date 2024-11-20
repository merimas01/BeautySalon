using eBeautySalon.Models;
using eBeautySalon.Models.SearchObjects;
using eBeautySalon.Services;
using Microsoft.AspNetCore.Mvc;

namespace eBeautySalon.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class StatusiController : BaseController<Models.Statusi, StatusiSearchObject>
    {
        IStatusService _service;
        public StatusiController(ILogger<BaseController<Statusi, StatusiSearchObject>> logger, IStatusService service) : base(logger, service)
        {
            _service = service;
        }
    }
}

