using eBeautySalon.Models;
using eBeautySalon.Models.Requests;
using eBeautySalon.Models.SearchObjects;
using eBeautySalon.Services;
using Microsoft.AspNetCore.Mvc;

namespace eBeautySalon.Controllers
{
    [ApiController]
    public class ZaposleniciUslugeController : BaseCRUDController<ZaposleniciUsluge, BaseSearchObject, ZaposleniciUslugeInsertRequest, ZaposleniciUslugeUpdateRequest>
    {
        public ZaposleniciUslugeController(ILogger<BaseCRUDController<ZaposleniciUsluge, BaseSearchObject, ZaposleniciUslugeInsertRequest, ZaposleniciUslugeUpdateRequest>> logger, IZaposleniciUslugeService service)
            : base(logger, service)
        {
        }
    }
}
