using eBeautySalon.Models;
using eBeautySalon.Models.Requests;
using eBeautySalon.Models.SearchObjects;
using eBeautySalon.Services;
using Microsoft.AspNetCore.Mvc;

namespace eBeautySalon.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class UslugeController : BaseCRUDController<Usluge,UslugeSearchObject,UslugeInsertRequest,UslugeUpdateRequest>
    {
        public UslugeController(ILogger<BaseCRUDController<Usluge, UslugeSearchObject, UslugeInsertRequest, UslugeUpdateRequest>> logger, IUslugeService service) :base(logger,service)
        {
        }

    }
}
