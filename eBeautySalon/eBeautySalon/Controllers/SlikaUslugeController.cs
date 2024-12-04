using eBeautySalon.Models;
using eBeautySalon.Models.Requests;
using eBeautySalon.Models.SearchObjects;
using eBeautySalon.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eBeautySalon.Controllers
{
    [ApiController]
    public class SlikaUslugeController : BaseCRUDController<Models.SlikaUsluge, BaseSearchObject, SlikaUslugeInsertRequest, SlikaUslugeUpdateRequest>
    {
        public SlikaUslugeController(ILogger<BaseCRUDController<SlikaUsluge, BaseSearchObject, SlikaUslugeInsertRequest, SlikaUslugeUpdateRequest>> logger, ISlikaUslugeService service) : base(logger, service)
        {
        }

        [Authorize(Roles = "Administrator, Uslužnik")]
        public override Task<SlikaUsluge> Insert([FromBody] SlikaUslugeInsertRequest insert)
        {
            return base.Insert(insert);
        }

        [Authorize(Roles = "Administrator, Uslužnik")]
        public override Task<SlikaUsluge> Update(int id, [FromBody] SlikaUslugeUpdateRequest update)
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
