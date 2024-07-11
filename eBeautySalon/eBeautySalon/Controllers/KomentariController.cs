using eBeautySalon.Models;
using eBeautySalon.Models.SearchObjects;
using eBeautySalon.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace eBeautySalon.Controllers
{
    [ApiController]
    public class KomentariController : BaseController<Komentari, BaseSearchObject>
    {
        public KomentariController(ILogger<BaseController<Komentari,BaseSearchObject>> logger, IService<Komentari,BaseSearchObject> service)
            : base(logger, service)
        {
        }
    }
}
