using eBeautySalon.Models;
using eBeautySalon.Models.Requests;
using eBeautySalon.Models.SearchObjects;
using eBeautySalon.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eBeautySalon.Controllers
{
    [ApiController]
    public class SlikaProfilaController : BaseCRUDController<Models.SlikaProfila, BaseSearchObject, SlikaProfilaInsertRequest, SlikaProfilaUpdateRequest>
    {
        public SlikaProfilaController(ILogger<BaseCRUDController<Models.SlikaProfila, BaseSearchObject, SlikaProfilaInsertRequest, SlikaProfilaUpdateRequest>> logger, ISlikaProfilaService service)
            : base(logger, service)
        {
        }

        [Authorize]
        public override Task<SlikaProfila> Insert([FromBody] SlikaProfilaInsertRequest insert)
        {
            return base.Insert(insert);
        }

        [Authorize]
        public override Task<SlikaProfila> Update(int id, [FromBody] SlikaProfilaUpdateRequest update)
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
