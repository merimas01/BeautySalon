using AutoMapper;
using eBeautySalon.Models;
using eBeautySalon.Models.Requests;
using eBeautySalon.Models.SearchObjects;
using eBeautySalon.Services.Database;
using Microsoft.EntityFrameworkCore;
using RabbitMQ.Client;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace eBeautySalon.Services
{
    public class RezervacijeService : BaseCRUDService<Rezervacije, Rezervacija, RezervacijeSearchObject, RezervacijeInsertRequest, RezervacijeUpdateRequest>, IRezervacijeService
    {
        public RezervacijeService(Ib200070Context context, IMapper mapper) : base(context, mapper)
        {         
        }

        public override IQueryable<Rezervacija> AddFilter(IQueryable<Rezervacija> query, RezervacijeSearchObject? search = null)
        {
            if (!string.IsNullOrWhiteSpace(search?.FTS))
            {
                query = query.Where(x => 
                x.Korisnik!=null && (x.Korisnik.Ime.ToLower().Contains(search.FTS.ToLower()) 
                || x.Korisnik.Prezime.ToLower().Contains(search.FTS.ToLower())
                || x.Termin.Opis.StartsWith(search.FTS)
                || x.Usluga.Naziv.StartsWith(search.FTS)));
            }
            if (search.StatusId != null)
            {
                query = query.Where(x => x.StatusId == search.StatusId);
            }
            return base.AddFilter(query, search);
        }

        public override IQueryable<Rezervacija> AddInclude(IQueryable<Rezervacija> query, RezervacijeSearchObject? search = null)
        {
            if (search?.isKorisnikIncluded == true)
            {
                query = query.Include(x => x.Korisnik.SlikaProfila);
            }
            if (search?.isUslugaIncluded == true)
            {
                query = query.Include(x => x.Usluga);
            }
            if (search?.isTerminIncluded == true)
            {
                query = query.Include(x => x.Termin);
            }
            if (search?.isStatusIncluded == true)
            {
                query = query.Include(x => x.Status);
            }
          
            return base.AddInclude(query, search);
        }
        public override async Task<bool> AddValidationInsert(RezervacijeInsertRequest request)
        {
            //ne smiju se dvije iste rezervacije pojaviti (iste vrijednosti usluge, termina i datuma)
            var lista = await _context.Rezervacijas.Where(x => x.UslugaId == request.UslugaId && x.TerminId == request.TerminId && x.DatumRezervacije == request.DatumRezervacije).ToListAsync();
            if (lista.Count() != 0) return false;
            return true;
        }

        public override async Task<bool> AddValidationUpdate(int id, RezervacijeUpdateRequest request)
        {
            var lista = await _context.Rezervacijas.Where(x => x.UslugaId == request.UslugaId && x.TerminId == request.TerminId && x.DatumRezervacije == request.DatumRezervacije && x.RezervacijaId != id).ToListAsync();
            if (lista.Count() != 0) return false;
            return true;
        }

        public override async Task BeforeInsert(Rezervacija entity, RezervacijeInsertRequest insert)
        {
            var klijent = await _context.Korisniks.FirstOrDefaultAsync(x=>x.KorisnikId == entity.KorisnikId);
            var klijentEmail = klijent?.Email;
            var usluga = await _context.Uslugas.FirstOrDefaultAsync(x => x.UslugaId == insert.UslugaId);
            var u = usluga?.Naziv;
            var termin = await _context.Termins.FirstOrDefaultAsync(x => x.TerminId == insert.TerminId);
            var t = termin?.Opis;
            var datum = insert.DatumRezervacije.Day + "." + insert.DatumRezervacije.Month + "." + insert.DatumRezervacije.Year;

            var factory = new ConnectionFactory { HostName = "localhost", UserName = "guest", Password = "guest" };
            using var connection = factory.CreateConnection();
            using var channel = connection.CreateModel();

            channel.QueueDeclare(queue: "reservation_created",
                                 durable: false,
                                 exclusive: false,
                                 autoDelete: false,
                                 arguments: null);

            string message = $"Rezervacija_je_kreirana!_email_{klijentEmail}_usluga_{u}_termin_{t}_datum_{datum}"; 
            var body = Encoding.UTF8.GetBytes(message);

            channel.BasicPublish(exchange: string.Empty,
                                 routingKey: "reservation_created",
                                 basicProperties: null,
                                 body: body);


            entity.StatusId = await _context.Statuses.Where(x => x.Opis != null && x.Opis == "Nova").Select(x=>x.StatusId).FirstOrDefaultAsync();
           
            await base.BeforeInsert(entity, insert);
        }
    }
}
