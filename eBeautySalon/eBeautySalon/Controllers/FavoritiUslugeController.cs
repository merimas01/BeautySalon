using eBeautySalon.Models;
using eBeautySalon.Models.Requests;
using eBeautySalon.Models.SearchObjects;
using eBeautySalon.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eBeautySalon.Controllers
{
    [ApiController]
    public class FavoritiUslugeController : BaseCRUDController<Models.FavoritiUsluge, FavoritiUslugeSearchObject, FavoritiUslugeInsertRequest, FavoritiUslugeUpdateRequest>
    {
        IFavoritiUslugeService _service;
        public FavoritiUslugeController(ILogger<BaseCRUDController<Models.FavoritiUsluge, FavoritiUslugeSearchObject, FavoritiUslugeInsertRequest, FavoritiUslugeUpdateRequest>> logger, IFavoritiUslugeService service)
            : base(logger, service)
        {
            _service = service;
        }

        [Authorize]
        public override Task<FavoritiUsluge> Insert([FromBody] FavoritiUslugeInsertRequest insert)
        {
            return base.Insert(insert);
        }

        [Authorize]
        public override Task<FavoritiUsluge> Update(int id, [FromBody] FavoritiUslugeUpdateRequest update)
        {
            return base.Update(id, update);
        }

        [Authorize]
        public override Task<bool> Delete(int id)
        {
            return base.Delete(id);
        }
    }
}
