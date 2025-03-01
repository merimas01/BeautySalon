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
using static Microsoft.EntityFrameworkCore.DbLoggerCategory;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace eBeautySalon.Services
{
    public class RezervacijeService : BaseCRUDService<Rezervacije, Rezervacija, RezervacijeSearchObject, RezervacijeInsertRequest, RezervacijeUpdateRequest>, IRezervacijeService
    {
        public RezervacijeService(Ib200070Context context, IMapper mapper) : base(context, mapper)
        {         
        }

        public async Task<int> DeleteUnpaidReservations()
        {
            int counter = 0;
            var unpaid_reservations = await _context.Rezervacijas.Where(x => x.Platio == false || x.Platio == null).ToListAsync();
            foreach (var item in unpaid_reservations)
            {
                var rezervacija = await _context.Rezervacijas.FirstOrDefaultAsync(x => x.RezervacijaId == item.RezervacijaId);      
                _context.Remove(rezervacija);
                await _context.SaveChangesAsync();
                counter++;
            }
            return counter;
        }

        public override IQueryable<Rezervacija> AddFilter(IQueryable<Rezervacija> query, RezervacijeSearchObject? search = null)
        {
            //query = query.Where(x => x.Platio == true);
            query = query.OrderByDescending(x => x.RezervacijaId);
            if (!string.IsNullOrWhiteSpace(search?.FTS))
            {
                query = query.Where(x => 
                x.Korisnik!=null && (x.Korisnik.Ime.ToLower().Contains(search.FTS.ToLower()) 
                || x.Korisnik.Prezime.ToLower().Contains(search.FTS.ToLower())
                || x.Termin.Opis.Contains(search.FTS)
                || x.Usluga.Naziv.Contains(search.FTS))
                || x.Usluga.Sifra.Contains(search.FTS)
                || x.Sifra.Contains(search.FTS) 
                || (x.Status!=null && x.Status.Opis.Contains(search.FTS))
                );
            }
            if (search.StatusId != null)
            {
                query = query.Where(x => x.StatusId == search.StatusId);
            }
            if (search.isArhiva == "da")
            {
                query = query.Where(x => x.IsArhiva==true);
            }
            if (search.isArhiva == "ne")
            {
                query = query.Where(x => x.IsArhiva == false || x.IsArhiva==null);
            }
            if (search.isArhivaKorisnik == "da")
            {
                query = query.Where(x => x.IsArhivaKorisnik == true);
            }
            if (search.isArhivaKorisnik == "ne")
            {
                query = query.Where(x => x.IsArhivaKorisnik == false || x.IsArhivaKorisnik == null);
            }
            if (search.KorisnikId != null)
            {
                query = query.Where(x => x.KorisnikId == search.KorisnikId);
            }
            if (search.DatumOpadajuciSort == true)
            {
                query = query.OrderByDescending(x => x.DatumRezervacije);
            }
            if (search.DatumOpadajuciSort == false)
            {
                query = query.OrderBy(x => x.DatumRezervacije);
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
                query = query.Include(x => x.Usluga.Kategorija);
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
            //samo korisnici mogu napraviti rezervaciju
            //ne smije isti korisnik rezrvisati dvije usluge na isti datum
            var lista_sveIsto = await _context.Rezervacijas.Where(x => x.UslugaId == request.UslugaId && x.TerminId == request.TerminId && x.DatumRezervacije.Date.CompareTo( request.DatumRezervacije.Date)==0).ToListAsync();
            var lista_istiKorisnik = await _context.Rezervacijas.Where(x => x.KorisnikId == request.KorisnikId && x.DatumRezervacije.Date.CompareTo(request.DatumRezervacije.Date)==0 && x.Status.Opis == "Nova").ToListAsync();
            var korisnici = await _context.Korisniks.FindAsync(request.KorisnikId);
            if (lista_sveIsto.Count() != 0) return false;
            if (lista_istiKorisnik.Count() != 0) return false;
            if (korisnici.KorisnikUlogas.Count() != 0) return false;
            return true;
        }

        public override async Task<bool> AddValidationUpdate(int id, RezervacijeUpdateRequest request)
        {
            var lista_sveIsto = await _context.Rezervacijas.Where(x => x.UslugaId == request.UslugaId && x.TerminId == request.TerminId && x.DatumRezervacije.Date.CompareTo(request.DatumRezervacije.Date) == 0 && x.RezervacijaId != id).ToListAsync();
            var lista_istiKorisnik = await _context.Rezervacijas.Where(x => x.KorisnikId == request.KorisnikId && x.DatumRezervacije.Date.CompareTo(request.DatumRezervacije.Date) == 0 && x.RezervacijaId != id).ToListAsync();
            var korisnici = await _context.Korisniks.FindAsync(request.KorisnikId);

            if (request.arhivaZaKorisnika == true) //ako se zeli arhivirati rezervacija
            {
                return true;
            }
            else
            {
                if (lista_sveIsto.Count() != 0) return false;
                if (lista_istiKorisnik.Count() != 0) return false;
                if (korisnici.KorisnikUlogas.Count() != 0) return false;
            }
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

            var factory = new ConnectionFactory
            {
                HostName = Environment.GetEnvironmentVariable("RABBITMQ_HOST") ?? "localhost",
                Port = int.Parse(Environment.GetEnvironmentVariable("RABBITMQ_PORT") ?? "5672"),
                UserName = Environment.GetEnvironmentVariable("RABBITMQ_USERNAME") ?? "guest",
                Password = Environment.GetEnvironmentVariable("RABBITMQ_PASSWORD") ?? "guest",
                RequestedConnectionTimeout = TimeSpan.FromSeconds(30),
                RequestedHeartbeat = TimeSpan.FromSeconds(60),
                AutomaticRecoveryEnabled = true,
                NetworkRecoveryInterval = TimeSpan.FromSeconds(10),
            };

            using var connection = factory.CreateConnection();
            using var channel = connection.CreateModel();

            channel.QueueDeclare(queue: "reservation_created",
                                 durable: factory.HostName=="localhost"? false: true,
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

        public override async Task<Rezervacija> AddIncludeForGetById(IQueryable<Rezervacija> query, int id)
        {           
            query = query.Include(x => x.Korisnik.SlikaProfila);
            query = query.Include(x => x.Usluga.Kategorija);
            query = query.Include(x => x.Termin);           
            query = query.Include(x => x.Status);            
            var entity = await query.FirstOrDefaultAsync(x => x.RezervacijaId == id);
            return entity;
        }

        public override async Task AfterInsert(Rezervacija entity, RezervacijeInsertRequest insert)
        {
            entity.Sifra = "R" + entity.RezervacijaId.ToString("D6");
        }

        public async Task<bool> OtkaziRezervaciju(int rezervacijaId)
        {
            //rezervacija se moze otkazati samo ako je nova
            var rezervacija = await _context.Rezervacijas.FindAsync(rezervacijaId);
            var statusOtkazana = await _context.Statuses.FirstOrDefaultAsync(x => x.Opis == "Otkazana");
            if (statusOtkazana != null)
            {
                rezervacija.StatusId = statusOtkazana.StatusId;
                _context.SaveChanges();
                return true;
            }
            return false;
        }

        public async Task<dynamic> GetTermineZaUsluguIDatum(int uslugaId, DateTime datum)
        {
            var usluga_termini = await _context.UslugaTermins.Where(x => x.UslugaId == uslugaId).Select(x=>x.Termin).ToListAsync();
            var rezervacije_usluga_datum = await _context.Rezervacijas.Where(x => x.UslugaId == uslugaId && x.DatumRezervacije.Date == datum.Date).Select(x=>x.Termin).ToListAsync();
            var lista_termina = new List<dynamic>();

            foreach(var obj in usluga_termini)
            {
                if (rezervacije_usluga_datum.Contains(obj))
                {
                    lista_termina.Add(new { terminId= obj.TerminId, termin = obj.Opis, zauzet = true });
                }
                else
                {
                    lista_termina.Add(new { terminId = obj.TerminId, termin = obj.Opis, zauzet = false });
                }
            }
            return lista_termina.OrderBy(t=> TimeSpan.Parse(t.termin));
        }
    }
}
