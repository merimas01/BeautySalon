using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using eBeautySalon.Models.Requests;
using eBeautySalon.Models.SearchObjects;

namespace eBeautySalon.Services
{
    public interface INovostLikeCommentService : ICRUDService<Models.NovostLikeComment, NovostLikeCommentSearchObject, NovostLikeCommentInsertRequest, NovostLikeCommentUpdateRequest>
    {
    }
}
