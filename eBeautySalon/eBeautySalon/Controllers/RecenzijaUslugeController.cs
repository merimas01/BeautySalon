using eBeautySalon.Models;
using eBeautySalon.Models.Requests;
using eBeautySalon.Models.SearchObjects;
using eBeautySalon.Services;
using Microsoft.AspNetCore.Mvc;

namespace eBeautySalon.Controllers
{
    [ApiController]
    public class RecenzijaUslugeController : BaseCRUDController<Models.RecenzijaUsluge, BaseSearchObject, RecenzijaUslugeInsertRequest, RecenzijaUslugeUpdateRequest>
    {
        public RecenzijaUslugeController(ILogger<BaseCRUDController<Models.RecenzijaUsluge, BaseSearchObject, RecenzijaUslugeInsertRequest, RecenzijaUslugeUpdateRequest>> logger, IRecenzijaUslugeService service)
            : base(logger, service)
        {
        }
    }
}
