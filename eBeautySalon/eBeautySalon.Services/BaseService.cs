using AutoMapper;
using eBeautySalon.Models;
using eBeautySalon.Models.SearchObjects;
using eBeautySalon.Services.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBeautySalon.Services
{
    public class BaseService<T, TDb, TSearch> : IService<T,TSearch> where TDb : class where T : class where TSearch: BaseSearchObject
    {
        protected Ib200070Context _context;
        protected IMapper _mapper { get; set; }

        public BaseService(Ib200070Context context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }

        public virtual async Task<PagedResult<T>> Get(TSearch search)
        {
            var query = _context.Set<TDb>().AsQueryable();

            PagedResult<T> result = new PagedResult<T>();

            query = AddInclude(query, search);

            query = AddFilter(query, search);

            result.Count = await query.CountAsync();

            if (search?.Page.HasValue==true && search?.PageSize.HasValue == true)
            {
                query=query.Take(search.PageSize.Value).Skip(search.Page.Value*search.PageSize.Value);
            }
            var list = await query.ToListAsync();

            list = SortAZ(list);

            var tmp = _mapper.Map<List<T>>(list);

            result.Result = tmp;

            return result;
        }

        public virtual List<TDb> SortAZ (List<TDb> list)
        {
            return list;
        }

        public virtual IQueryable<TDb> AddInclude(IQueryable<TDb> query, TSearch? search = null)
        {
            return query;
        }

        public virtual IQueryable<TDb> AddFilter(IQueryable<TDb> query, TSearch? search = null)
        {
            return query;
        }


        public virtual async Task<TDb> AddIncludeForGetById(IQueryable<TDb> query, int id)
        {
            return (TDb)query;
        }

        public virtual async Task<T> GetById(int id)
        {
            var query = _context.Set<TDb>().AsQueryable();

            var entity = await AddIncludeForGetById(query, id);

            return _mapper.Map<T>(entity);
        }


    }
}
