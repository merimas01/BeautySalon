using eBeautySalon.Models;
using eBeautySalon.Models.Requests;
using eBeautySalon.Models.SearchObjects;
using eBeautySalon.Services;
using Microsoft.AspNetCore.Authorization;
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

        [Authorize]
        public override Task<Rezervacije> Insert([FromBody] RezervacijeInsertRequest insert)
        {
            return base.Insert(insert);
        }

        [Authorize] 
        public override Task<Rezervacije> Update(int id, [FromBody] RezervacijeUpdateRequest update)
        {
            return base.Update(id, update);
        }

        [Authorize]
        public override Task<bool> Delete(int id)
        {
            return base.Delete(id);
        }
    }
}
