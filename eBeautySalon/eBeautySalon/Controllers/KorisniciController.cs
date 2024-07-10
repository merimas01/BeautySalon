using eBeautySalon.Models;
using eBeautySalon.Models.Requests;
using eBeautySalon.Services;
using eBeautySalon.Services.Database;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace eBeautySalon.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class KorisniciController : ControllerBase
    {
        private readonly IKorisniciService _service;
        private readonly ILogger<WeatherForecastController> _logger;

        public KorisniciController(ILogger<WeatherForecastController> logger, IKorisniciService service)
        {
            _logger = logger;
            _service = service;
        }

        [HttpGet()]
        public IEnumerable<Korisnici> Get()
        {
            return _service.Get();
        }

        [HttpPost()]
        public Korisnici Insert(KorisniciInsertRequest request)
        {
            return _service.Insert(request);
        }

        [HttpPut("{id}")]
        public Korisnici Update (int id, KorisniciUpdateRequest request)
        {
            return _service.Update(id, request);
        }
    }
}
