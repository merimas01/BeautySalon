using eBeautySalon.Models;
using eBeautySalon.Models.Requests;
using eBeautySalon.Models.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBeautySalon.Services
{
    public interface IRezervacijeService : ICRUDService<Rezervacije, RezervacijeSearchObject, RezervacijeInsertRequest, RezervacijeUpdateRequest>
    {
        public Task<bool> OtkaziRezervaciju(int rezervacijaId);
        public Task<dynamic> GetTermineZaUsluguIDatum(int uslugaId, DateTime datum);
        public Task<int> DeleteUnpaidReservations();
    }
}
