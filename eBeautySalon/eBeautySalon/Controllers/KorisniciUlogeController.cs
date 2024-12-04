using eBeautySalon.Models;
using eBeautySalon.Models.Requests;
using eBeautySalon.Models.SearchObjects;
using eBeautySalon.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eBeautySalon.Controllers
{
    [ApiController]
    public class KorisniciUlogeController : BaseCRUDController<Models.KorisniciUloge, KorisniciUlogeSearchObject, KorisniciUlogeInsertRequest, KorisniciUlogeUpdateRequest>
    {
        public KorisniciUlogeController(ILogger<BaseCRUDController<Models.KorisniciUloge, KorisniciUlogeSearchObject, KorisniciUlogeInsertRequest, KorisniciUlogeUpdateRequest>> logger, IKorisniciUlogeService service)
            : base(logger, service)
        {
        }

        [Authorize(Roles = "Administrator, Uslužnik")]
        public override Task<KorisniciUloge> Insert([FromBody] KorisniciUlogeInsertRequest insert)
        {
            return base.Insert(insert);
        }

        [Authorize(Roles = "Administrator, Uslužnik")]
        public override Task<KorisniciUloge> Update(int id, [FromBody] KorisniciUlogeUpdateRequest update)
        {
            return base.Update(id, update);
        }

        [Authorize(Roles = "Administrator, Uslužnik")]
        public override Task<bool> Delete(int id)
        {
            return base.Delete(id);
        }
    }
}
