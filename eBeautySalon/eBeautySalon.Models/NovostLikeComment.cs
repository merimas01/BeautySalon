using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBeautySalon.Models
{
    public partial class NovostLikeComment
    {
        public int NovostLikeCommentId { get; set; }

        public int KorisnikId { get; set; }

        public bool? IsLike { get; set; }

        public string? Komentar { get; set; }

        public DateTime? DatumKreiranja { get; set; }

        public DateTime? DatumModifikovanja { get; set; }

        public int NovostId { get; set; }

        public virtual Korisnici Korisnik { get; set; } = null!;

        public virtual Novosti Novost { get; set; } = null!;
    }

}
