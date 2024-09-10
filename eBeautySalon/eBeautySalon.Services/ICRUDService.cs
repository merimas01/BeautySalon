using eBeautySalon.Models.Requests;
using eBeautySalon.Models;
using eBeautySalon.Models.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBeautySalon.Services
{
    public interface ICRUDService<T, TSearch, TInsert, TUpdate> : IService<T,TSearch> where T : class where TSearch : class
    {
        Task<T> Insert(TInsert request);
        Task<T> Update(int id, TUpdate request);
        Task<bool> Delete(int id);
    }
}
