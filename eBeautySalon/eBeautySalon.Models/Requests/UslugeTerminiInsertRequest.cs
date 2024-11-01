using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace eBeautySalon.Models.Requests
{
    public class UslugeTerminiInsertRequest
    {
        [Required]
        public int UslugaId { get; set; }
        [Required]
        public int TerminId { get; set; }
        [JsonIgnore]
        public DateTime DatumIzmjene { get; set; } = DateTime.Now;
        [JsonIgnore]
        public bool? IsPrikazan { get; set; } = true;

    }
}
