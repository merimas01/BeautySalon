using eBeautySalon.Models;
using eBeautySalon.Services;
using Microsoft.AspNetCore.Mvc;

namespace eBeautySalon.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class UslugeController : ControllerBase
    {
        private readonly IUslugeService _uslugeService;
        private readonly ILogger<WeatherForecastController> _logger;

        public UslugeController(ILogger<WeatherForecastController> logger, IUslugeService uslugeService)
        {
            _logger = logger;
            _uslugeService = uslugeService;
        }

        [HttpGet()]
        public IEnumerable<Usluge> Get()
        {
            return _uslugeService.Get();
        }
    }
}
