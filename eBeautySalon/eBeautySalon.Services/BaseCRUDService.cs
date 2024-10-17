using AutoMapper;
using eBeautySalon.Models;
using eBeautySalon.Models.SearchObjects;
using eBeautySalon.Services.Database;
using Microsoft.EntityFrameworkCore.Metadata.Conventions;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBeautySalon.Services
{
    public class BaseCRUDService<T, TDb, TSearch, TInsert,TUpdate> : BaseService<T, TDb, TSearch> where T : class where TDb : class where TSearch : BaseSearchObject
    {
        public BaseCRUDService(IB200070Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public virtual async Task BeforeInsert(TDb entity, TInsert insert)
        {

        }

        public virtual async Task BeforeUpate(TDb entity, TUpdate update)
        {

        }

        public virtual async Task BeforeDelete(TDb entity)
        {

        }

        public virtual async Task<bool> AddValidationInsert (TInsert request)
        {
            return true;
        }

        public virtual async Task<bool> AddValidationUpdate(int id, TUpdate request)
        {
            return true;
        }

        public virtual async Task<T> Insert(TInsert insert)
        {
            var set = _context.Set<TDb>();

            TDb entity = _mapper.Map<TDb>(insert);

            await BeforeInsert(entity, insert);
            var validate = await AddValidationInsert(insert);

            if (validate == true)
            {
                set.Add(entity);

                await _context.SaveChangesAsync();
                return _mapper.Map<T>(entity);
            }
            else throw new Exception("podaci nisu validni (duplicirani nazivi).");
        }


        public virtual async Task<T> Update(int id, TUpdate update)
        {
            var set = _context.Set<TDb>();

            var entity = await set.FindAsync(id);

            await BeforeUpate(entity, update);
            var validate = await AddValidationUpdate(id, update);

            if (validate == true)
            {
                _mapper.Map(update, entity);

                await _context.SaveChangesAsync();
                return _mapper.Map<T>(entity);
            }
            else throw new Exception("podaci nisu validni (duplicirani nazivi).");

        }


        public virtual async Task<bool> Delete(int id)
        {
            var set = _context.Set<TDb>();

            var entity = await set.FindAsync(id);
      
            if (entity != null)
            {
                await BeforeDelete(entity);
                set.Remove(entity);
                await _context.SaveChangesAsync();
                return true;
            }
            else return false;
           
        }

    }

}
