using eBeautySalon.Models;
using eBeautySalon.Models.Requests;
using eBeautySalon.Models.SearchObjects;
using eBeautySalon.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace eBeautySalon.Controllers
{
    [ApiController]
    public class KomentariController : BaseCRUDController<Komentari, BaseSearchObject,KomentariInsertRequest,KomentariUpdateRequest>
    {
        public KomentariController(ILogger<BaseCRUDController<Komentari, BaseSearchObject, KomentariInsertRequest,KomentariUpdateRequest>> logger, IKomentariService service)
            : base(logger, service)
        {
        }
    }
}
