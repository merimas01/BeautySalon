using eBeautySalon.Models;
using eBeautySalon.Models.Requests;
using eBeautySalon.Models.SearchObjects;
using eBeautySalon.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;

namespace eBeautySalon.Controllers
{
    [ApiController]
    public class KategorijeController : BaseCRUDController<Kategorije, KategorijeSearchObject, KategorijeInsertRequest,KategorijeUpdateRequest>
    {
        public KategorijeController(ILogger<BaseCRUDController<Kategorije,KategorijeSearchObject,KategorijeInsertRequest,KategorijeUpdateRequest>> logger, IKategorijeService service)
            :base(logger,service)
        {
        }

        [Authorize(Roles = "Administrator, Uslužnik")]
        public override Task<Kategorije> Insert([FromBody] KategorijeInsertRequest insert)
        {
            return base.Insert(insert);
        }

        [Authorize(Roles = "Administrator, Uslužnik")]
        public override Task<Kategorije> Update(int id, [FromBody] KategorijeUpdateRequest update)
        {
            return base.Update(id, update);
        }

        [Authorize(Roles = "Administrator, Uslužnik")]
        public override Task<bool> Delete(int id)
        {
            return base.Delete(id);
        }
    }
}
