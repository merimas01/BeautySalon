using eBeautySalon.Models;
using eBeautySalon.Models.Requests;
using eBeautySalon.Models.SearchObjects;
using eBeautySalon.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eBeautySalon.Controllers
{
    [ApiController]
    public class UlogeController : BaseCRUDController<Models.Uloge, UlogeSearchObject, UlogeInsertRequest, UlogeUpdateRequest>
    {
        public UlogeController(ILogger<BaseCRUDController<Models.Uloge, UlogeSearchObject, UlogeInsertRequest, UlogeUpdateRequest>> logger, IUlogeService service)
            : base(logger, service)
        {
        }

        [Authorize(Roles = "Administrator, Uslužnik")]
        public override Task<Uloge> Insert([FromBody] UlogeInsertRequest insert)
        {
            return base.Insert(insert);
        }

        [Authorize(Roles = "Administrator, Uslužnik")]
        public override Task<Uloge> Update(int id, [FromBody] UlogeUpdateRequest update)
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
