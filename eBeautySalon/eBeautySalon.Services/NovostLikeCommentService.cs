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
            query = query.OrderByDescending(x => x.NovostLikeCommentId);
            if (!string.IsNullOrWhiteSpace(search.FTS))
            {
                query = query.Where(x => x.Korisnik.Ime.Contains(search.FTS) || x.Korisnik.Prezime.Contains(search.FTS) || x.Novost.Naslov.Contains(search.FTS));
            }
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
            if (search.isComment == false)
            {
                query = query.Where(x => string.IsNullOrWhiteSpace(x.Komentar));
            }
            if (search.isComment == true)
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

            var brojRijeciKomentar = request.Komentar?.Trim().Split(new[] { ' ', '\t', '\n', '\r' }, StringSplitOptions.RemoveEmptyEntries).Length ?? 0;

            if (brojRijeciKomentar > 15) return false;
            else if (request.Komentar!=null && request.Komentar.Trim() == "") return false;

            return true;
        }

        public override async Task<bool> AddValidationUpdate(int id, NovostLikeCommentUpdateRequest request)
        {
            var brojRijeciKomentar = request.Komentar?.Trim().Split(new[] { ' ', '\t', '\n', '\r' }, StringSplitOptions.RemoveEmptyEntries).Length ?? 0;
           
            if (brojRijeciKomentar > 15) return false;
            else if (request.Komentar != null && request.Komentar.Trim() == "") return false;


            return true;
        }

        public override async Task<Database.NovostLikeComment> AddIncludeForGetById(IQueryable<Database.NovostLikeComment> query, int id)
        {
            query = query.Include(x => x.Novost.SlikaNovost);
            query = query.Include(x => x.Korisnik.SlikaProfila);
            var entity = await query.FirstOrDefaultAsync(x => x.NovostLikeCommentId == id);
            return entity;
        }
    }
}
