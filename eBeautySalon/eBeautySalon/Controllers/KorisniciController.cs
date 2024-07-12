using eBeautySalon.Models;
using eBeautySalon.Models.Requests;
using eBeautySalon.Models.SearchObjects;
using eBeautySalon.Services;
using eBeautySalon.Services.Database;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace eBeautySalon.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class KorisniciController : BaseCRUDController<Korisnici, KorisniciSearchObject,KorisniciInsertRequest,KorisniciUpdateRequest>
    {
        //protected IKorisniciService _korisniciService; - ako imali svoje metode koje nisu crud
        public KorisniciController(ILogger<BaseCRUDController<Korisnici, KorisniciSearchObject, KorisniciInsertRequest, KorisniciUpdateRequest>> logger, IKorisniciService service)
            : base(logger, service)
        {
           //_korisniciService = service;
        }

        //[HttpPost()]
        //public Korisnici Insert(KorisniciInsertRequest request)
        //{
        //    return _korisniciService.Insert(request);
        //}

        //[HttpPut("{id}")]
        //public Korisnici Update(int id, KorisniciUpdateRequest request)
        //{
        //    return (_service as IKorisniciService).Update(id, request);
        //}
    }
}
