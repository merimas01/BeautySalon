using eBeautySalon.Models;
using eBeautySalon.Models.Requests;
using eBeautySalon.Models.SearchObjects;
using eBeautySalon.Services;
using Microsoft.AspNetCore.Mvc;

namespace eBeautySalon.Controllers
{
    [ApiController]
    public class RezervacijeController : BaseCRUDController<Rezervacije, BaseSearchObject, RezervacijeInsertRequest, RezervacijeUpdateRequest>
    {
        public RezervacijeController(ILogger<BaseCRUDController<Rezervacije, BaseSearchObject, RezervacijeInsertRequest, RezervacijeUpdateRequest>> logger, IRezervacijeService service)
            : base(logger, service)
        {
        }
    }
}
