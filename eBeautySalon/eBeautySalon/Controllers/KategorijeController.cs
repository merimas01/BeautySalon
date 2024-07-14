using eBeautySalon.Models;
using eBeautySalon.Models.Requests;
using eBeautySalon.Models.SearchObjects;
using eBeautySalon.Services;
using Microsoft.AspNetCore.Mvc;

namespace eBeautySalon.Controllers
{
    [ApiController]
    public class KategorijeController : BaseCRUDController<Kategorije, KategorijeSearchObject, KategorijeInsertRequest,KategorijeUpdateRequest>
    {
        public KategorijeController(ILogger<BaseCRUDController<Kategorije,KategorijeSearchObject,KategorijeInsertRequest,KategorijeUpdateRequest>> logger, IKategorijeService service)
            :base(logger,service)
        {
        }
    }
}
