using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace eBeautySalon.Models.Requests
{
    public class OcjeneInsertRequest
    {
        public string Opis { get; set; } = null!;

        [JsonIgnore]
        public DateTime DatumKreiranja { get; set; } = DateTime.Now;

        public int? KorisnikId { get; set; }

        public int? UslugaId { get; set; }
    }
}
