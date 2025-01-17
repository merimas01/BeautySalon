using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace eBeautySalon.Models.Requests
{

    public class NovostLikeCommentInsertRequest
    {
        [Required]
        public int? KorisnikId { get; set; }

        [Required]
        public int? NovostId { get; set; }

        public bool? IsLike { get; set; }

        public string? Komentar { get; set; }

        [JsonIgnore]
        public DateTime? DatumKreiranja { get; set; } = DateTime.Now;
    }
}
