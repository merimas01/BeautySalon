using eBeautySalon.Models;
using eBeautySalon.Models.Requests;
using eBeautySalon.Models.SearchObjects;
using eBeautySalon.Services;
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
    }
}
