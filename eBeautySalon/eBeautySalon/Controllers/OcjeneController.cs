using eBeautySalon.Models;
using eBeautySalon.Models.Requests;
using eBeautySalon.Models.SearchObjects;
using eBeautySalon.Services;
using Microsoft.AspNetCore.Mvc;

namespace eBeautySalon.Controllers
{
    [ApiController]
    public class OcjeneController : BaseCRUDController<Ocjene, BaseSearchObject, OcjeneInsertRequest, OcjeneUpdateRequest>
    {
        public OcjeneController(ILogger<BaseCRUDController<Ocjene, BaseSearchObject, OcjeneInsertRequest, OcjeneUpdateRequest>> logger, IOcjeneService service)
            : base(logger, service)
        {
        }
    }
}
