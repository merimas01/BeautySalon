using eBeautySalon.Models;
using eBeautySalon.Models.Requests;
using eBeautySalon.Models.SearchObjects;
using eBeautySalon.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eBeautySalon.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class KorisniciController : BaseCRUDController<Korisnici, KorisniciSearchObject,KorisniciInsertRequest,KorisniciUpdateRequest>
    {
        protected IKorisniciService _korisniciService;// - ako imali svoje metode koje nisu crud
        public KorisniciController(ILogger<BaseCRUDController<Korisnici, KorisniciSearchObject, KorisniciInsertRequest, KorisniciUpdateRequest>> logger, IKorisniciService service)
            : base(logger, service)
        {
           _korisniciService = service;
        }

        [Authorize(Roles = "Administrator")] //samo admin moze insertati korisnika
        public override Task<Korisnici> Insert(KorisniciInsertRequest insert)
        {
            return base.Insert(insert);
        }
    }
}
