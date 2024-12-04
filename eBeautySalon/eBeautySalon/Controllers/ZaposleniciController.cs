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
    public class ZaposleniciController : BaseCRUDController<Zaposlenici, ZaposleniciSearchObject, ZaposleniciInsertRequest, ZaposleniciUpdateRequest>
    {
        public ZaposleniciController(ILogger<BaseCRUDController<Zaposlenici, ZaposleniciSearchObject, ZaposleniciInsertRequest, ZaposleniciUpdateRequest>> logger, IZaposleniciService service) : base(logger, service)
        {
        }

        [Authorize(Roles = "Administrator")]
        public override Task<Zaposlenici> Insert([FromBody] ZaposleniciInsertRequest insert)
        {
            return base.Insert(insert);
        }

        [Authorize(Roles = "Administrator")]
        public override Task<Zaposlenici> Update(int id, [FromBody] ZaposleniciUpdateRequest update)
        {
            return base.Update(id, update);
        }
    }
}
