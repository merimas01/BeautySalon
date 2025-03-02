using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBeautySalon.Models
{
    public class Statusi
    {
        public int StatusId { get; set; }
        public string Opis { get; set; } = null!;
        public string? Sifra { get; set; }

        //public virtual ICollection<Rezervacije> Rezervacijas { get; set; } = new List<Rezervacije>();
    }
}
