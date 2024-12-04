using eBeautySalon.Models;
using eBeautySalon.Models.Requests;
using eBeautySalon.Models.SearchObjects;
using eBeautySalon.Services;
using Microsoft.AspNetCore.Authorization;
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

        [Authorize(Roles = "Administrator")]
        public override Task<ZaposleniciUsluge> Insert([FromBody] ZaposleniciUslugeInsertRequest insert)
        {
            return base.Insert(insert);
        }

        [Authorize(Roles = "Administrator")]
        public override Task<ZaposleniciUsluge> Update(int id, [FromBody] ZaposleniciUslugeUpdateRequest update)
        {
            return base.Update(id, update);
        }

        [Authorize(Roles = "Administrator")]
        public override Task<bool> Delete(int id)
        {
            return base.Delete(id);
        }
    }
}
