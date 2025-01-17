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
    public class NovostiLikeCommentController : BaseCRUDController<Models.NovostLikeComment, NovostLikeCommentSearchObject, NovostLikeCommentInsertRequest, NovostLikeCommentUpdateRequest>
    {
        INovostLikeCommentService _service;
        public NovostiLikeCommentController(ILogger<BaseCRUDController<Models.NovostLikeComment, NovostLikeCommentSearchObject, NovostLikeCommentInsertRequest, NovostLikeCommentUpdateRequest>> logger, INovostLikeCommentService service)
            : base(logger, service)
        {
            _service = service;
        }

        [Authorize]
        public override Task<Models.NovostLikeComment> Insert(NovostLikeCommentInsertRequest insert)
        {
            return base.Insert(insert);
        }

        [Authorize]
        public override Task<Models.NovostLikeComment> Update(int id, [FromBody] NovostLikeCommentUpdateRequest update)
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