using eBeautySalon.Models;
using eBeautySalon.Models.Requests;
using eBeautySalon.Models.SearchObjects;
using eBeautySalon.Services;
using Microsoft.AspNetCore.Mvc;

namespace eBeautySalon.Controllers
{
    [ApiController]
    public class RezervacijeController : BaseCRUDController<Rezervacije, RezervacijeSearchObject, RezervacijeInsertRequest, RezervacijeUpdateRequest>
    {
        IRezervacijeService _service;
        public RezervacijeController(ILogger<BaseCRUDController<Rezervacije, RezervacijeSearchObject, RezervacijeInsertRequest, RezervacijeUpdateRequest>> logger, IRezervacijeService service)
            : base(logger, service)
        {
            _service = service;
        }

        [HttpGet("rezervacije/{korisnikId}")]
        public async Task<PagedResult<Rezervacije>> GetRezervacijeByKorisnikId(int korisnikId, string? FTS)
        {
            return await _service.GetRezervacijeByKorisnikId(korisnikId, FTS);
        }
    }
}
