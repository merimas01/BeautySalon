using eBeautySalon.Models;
using eBeautySalon.Models.Requests;
using eBeautySalon.Models.SearchObjects;
using eBeautySalon.Services;
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
    }
}
