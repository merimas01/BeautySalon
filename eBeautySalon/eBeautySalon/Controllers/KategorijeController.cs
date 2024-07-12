﻿using eBeautySalon.Models;
using eBeautySalon.Models.Requests;
using eBeautySalon.Models.SearchObjects;
using eBeautySalon.Services;
using eBeautySalon.Services.Database;
using Microsoft.AspNetCore.Http;
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

        //[HttpPost()]
        //public Korisnici Insert(KorisniciInsertRequest request)
        //{
        //    return _service.Insert(request);
        //}

        //[HttpPut("{id}")]
        //public Korisnici Update (int id, KorisniciUpdateRequest request)
        //{
        //    return _service.Update(id, request);
        //}
    }
}
