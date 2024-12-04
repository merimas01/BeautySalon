using eBeautySalon.Models;
using eBeautySalon.Models.Requests;
using eBeautySalon.Models.SearchObjects;
using eBeautySalon.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eBeautySalon.Controllers
{
    [ApiController]
    public class TerminiController : BaseCRUDController<Termini, BaseSearchObject, TerminiInsertRequest, TerminiUpdateRequest>
    {
        public TerminiController(ILogger<BaseCRUDController<Termini, BaseSearchObject, TerminiInsertRequest, TerminiUpdateRequest>> logger, ITerminiService service)
            : base(logger, service)
        {
        }

        [Authorize(Roles = "Administrator")]
        public override Task<Termini> Insert([FromBody] TerminiInsertRequest insert)
        {
            return base.Insert(insert);
        }

        [Authorize(Roles = "Administrator")]
        public override Task<Termini> Update(int id, [FromBody] TerminiUpdateRequest update)
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
