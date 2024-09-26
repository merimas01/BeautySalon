using eBeautySalon.Models;
using eBeautySalon.Models.Requests;
using eBeautySalon.Models.SearchObjects;
using eBeautySalon.Services;
using Microsoft.AspNetCore.Mvc;

namespace eBeautySalon.Controllers
{
    [ApiController]
    public class UlogeController : BaseCRUDController<Models.Uloge, BaseSearchObject, UlogeInsertRequest, UlogeUpdateRequest>
    {
        public UlogeController(ILogger<BaseCRUDController<Models.Uloge, BaseSearchObject, UlogeInsertRequest, UlogeUpdateRequest>> logger, IUlogeService service)
            : base(logger, service)
        {
        }
    }
}
