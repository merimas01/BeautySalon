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
    public class UslugeTerminiController : BaseCRUDController<UslugeTermini, UslugeTerminiSearchObject, UslugeTerminiInsertRequest, UslugeTerminiUpdateRequest>
    {
        public UslugeTerminiController(ILogger<BaseCRUDController<UslugeTermini, UslugeTerminiSearchObject, UslugeTerminiInsertRequest, UslugeTerminiUpdateRequest>> logger, IUslugeTerminiService service) : base(logger, service)
        {
        }

        [Authorize(Roles = "Administrator, Uslužnik")]
        public override Task<UslugeTermini> Insert([FromBody] UslugeTerminiInsertRequest insert)
        {
            return base.Insert(insert);
        }

        [Authorize(Roles = "Administrator, Uslužnik")]
        public override Task<UslugeTermini> Update(int id, [FromBody] UslugeTerminiUpdateRequest update)
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
