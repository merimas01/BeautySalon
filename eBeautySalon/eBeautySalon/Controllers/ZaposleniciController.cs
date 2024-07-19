using eBeautySalon.Models;
using eBeautySalon.Models.Requests;
using eBeautySalon.Models.SearchObjects;
using eBeautySalon.Services;
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

    }
}
