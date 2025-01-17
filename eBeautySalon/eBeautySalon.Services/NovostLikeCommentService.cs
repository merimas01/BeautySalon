using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using eBeautySalon.Models.Requests;
using eBeautySalon.Models.SearchObjects;
using eBeautySalon.Models;
using eBeautySalon.Services.Database;
using AutoMapper;
using Microsoft.EntityFrameworkCore;
using Azure.Core;

namespace eBeautySalon.Services
{
    public class NovostLikeCommentService : BaseCRUDService<Models.NovostLikeComment, Database.NovostLikeComment, NovostLikeCommentSearchObject, NovostLikeCommentInsertRequest, NovostLikeCommentUpdateRequest>, INovostLikeCommentService
    {
        public NovostLikeCommentService(Ib200070Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Database.NovostLikeComment> AddInclude(IQueryable<Database.NovostLikeComment> query, NovostLikeCommentSearchObject? search = null)
        {
            if (search?.isKorisnikIncluded == true)
            {
                query = query.Include(x => x.Korisnik.SlikaProfila);
            }
            if (search?.isNovostIncluded == true)
            {
                query = query.Include(x => x.Novost.SlikaNovost);
            }
            return base.AddInclude(query, search);
        }

        public override IQueryable<Database.NovostLikeComment> AddFilter(IQueryable<Database.NovostLikeComment> query, NovostLikeCommentSearchObject? search = null)
        {
            if (search.KorisnikId != null)
            {
                query = query.Where(x => x.KorisnikId == search.KorisnikId);
            }
            if (search.NovostId != null)
            {
                query = query.Where(x => x.NovostId == search.NovostId);
            }
            if (search.IsLike != null)
            {
                query = query.Where(x => x.IsLike == search.IsLike);
            }
            if (search.isComment != null)
            {
                query = query.Where(x => !string.IsNullOrWhiteSpace(x.Komentar));
            }
            if (!string.IsNullOrWhiteSpace(search.Komentar))
            {
                query = query.Where(x => x.Komentar.Contains(x.Komentar));
            }
            return base.AddFilter(query, search);
        }

        public override async Task<bool> AddValidationInsert(NovostLikeCommentInsertRequest request)
        {
            //komentar ne smije biti duzi od 15 rijeci
            //ne smije postojati dva zapisa sa istim korisnikId i novostId

            var brojRijeciKomentar = request.Komentar?.Trim().Split(new[] { ' ', '\t', '\n', '\r' }, StringSplitOptions.RemoveEmptyEntries).Length ?? 0;
            var novostLajkoviKomentari = await _context.NovostLikeComments.Where(x => x.KorisnikId == request.KorisnikId && x.NovostId == request.NovostId).FirstOrDefaultAsync();

            if (novostLajkoviKomentari != null) return false;
            else if (brojRijeciKomentar > 15) return false;

            return true;
        }

        public override async Task<bool> AddValidationUpdate(int id, NovostLikeCommentUpdateRequest request)
        {
            var brojRijeciKomentar = request.Komentar?.Trim().Split(new[] { ' ', '\t', '\n', '\r' }, StringSplitOptions.RemoveEmptyEntries).Length ?? 0;
            var novostLajkoviKomentari = await _context.NovostLikeComments.Where(x => x.NovostLikeCommentId != id && (x.KorisnikId == request.KorisnikId && x.NovostId == request.NovostId)).FirstOrDefaultAsync();

            if (novostLajkoviKomentari != null) return false;
            else if (brojRijeciKomentar > 15) return false;

            return true;
        }
    }
}
