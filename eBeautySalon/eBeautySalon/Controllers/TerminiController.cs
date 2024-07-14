using eBeautySalon.Models;
using eBeautySalon.Models.Requests;
using eBeautySalon.Models.SearchObjects;
using eBeautySalon.Services;
using Microsoft.AspNetCore.Mvc;

namespace eBeautySalon.Controllers
{
    [ApiController]
    public class TerminiController : BaseCRUDController<Termini, BaseSearchObject, TerminiInsertRequest, TerminiUpdateRequest>
    {
        public TerminiController(ILogger<BaseCRUDController<Termini, BaseSearchObject, TerminiInsertRequest, TerminiUpdateRequest>> logger, ITerminiService service)
            : base(logger, service)
        {
        }
    }
}
