using eBeautySalon.Models;
using eBeautySalon.Models.Requests;
using eBeautySalon.Models.SearchObjects;
using eBeautySalon.Services;
using Microsoft.AspNetCore.Mvc;

namespace eBeautySalon.Controllers
{
    [ApiController]
    public class SlikaUslugeController : BaseCRUDController<Models.SlikaUsluge, BaseSearchObject, SlikaUslugeInsertRequest, SlikaUslugeUpdateRequest>
    {
        public SlikaUslugeController(ILogger<BaseCRUDController<SlikaUsluge, BaseSearchObject, SlikaUslugeInsertRequest, SlikaUslugeUpdateRequest>> logger, ISlikaUslugeService service) : base(logger, service)
        {
        }
    }
}
