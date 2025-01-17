using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBeautySalon.Models.SearchObjects
{
    public class NovostLikeCommentSearchObject : BaseSearchObject
    { 
        public int? KorisnikId { get; set; }

        public int? NovostId { get; set; }

        public bool? IsLike { get; set; }

        public bool? isComment { get; set; }

        public string? Komentar { get; set; }

        public bool? isNovostIncluded { get; set; }

        public bool? isKorisnikIncluded { get; set; }
    }
}
