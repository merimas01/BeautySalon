using eBeautySalon.Models;
using eBeautySalon.Models.Requests;
using eBeautySalon.Models.SearchObjects;
using eBeautySalon.Services;
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
    }
}
