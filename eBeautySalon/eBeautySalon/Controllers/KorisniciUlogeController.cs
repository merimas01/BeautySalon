using eBeautySalon.Models;
using eBeautySalon.Models.Requests;
using eBeautySalon.Models.SearchObjects;
using eBeautySalon.Services;
using Microsoft.AspNetCore.Mvc;

namespace eBeautySalon.Controllers
{
    [ApiController]
    public class KorisniciUlogeController : BaseCRUDController<Models.KorisniciUloge, KorisniciUlogeSearchObject, KorisniciUlogeInsertRequest, KorisniciUlogeUpdateRequest>
    {
        public KorisniciUlogeController(ILogger<BaseCRUDController<Models.KorisniciUloge, KorisniciUlogeSearchObject, KorisniciUlogeInsertRequest, KorisniciUlogeUpdateRequest>> logger, IKorisniciUlogeService service)
            : base(logger, service)
        {
        }
    }
}
