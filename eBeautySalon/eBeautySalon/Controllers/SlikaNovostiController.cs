using eBeautySalon.Models;
using eBeautySalon.Models.Requests;
using eBeautySalon.Models.SearchObjects;
using eBeautySalon.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eBeautySalon.Controllers
{
    [ApiController]
    public class SlikaNovostiController : BaseCRUDController<SlikaNovosti, BaseSearchObject, SlikaNovostiInsertRequest, SlikaNovostiUpdateRequest>
    {
        public SlikaNovostiController(ILogger<BaseCRUDController<SlikaNovosti, BaseSearchObject, SlikaNovostiInsertRequest, SlikaNovostiUpdateRequest>> logger, ISlikaNovostiService service)
            : base(logger, service)
        {
        }

        [Authorize(Roles = "Administrator")]
        public override Task<SlikaNovosti> Insert([FromBody] SlikaNovostiInsertRequest insert)
        {
            return base.Insert(insert);
        }

        [Authorize(Roles = "Administrator")]
        public override Task<SlikaNovosti> Update(int id, [FromBody] SlikaNovostiUpdateRequest update)
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
