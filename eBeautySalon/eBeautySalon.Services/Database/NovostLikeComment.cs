using System;
using System.Collections.Generic;

namespace eBeautySalon.Services.Database;

public partial class NovostLikeComment
{
    public int NovostLikeCommentId { get; set; }

    public int KorisnikId { get; set; }

    public bool? IsLike { get; set; }

    public string? Komentar { get; set; }

    public DateTime? DatumKreiranja { get; set; }

    public DateTime? DatumModifikovanja { get; set; }

    public int NovostId { get; set; }

    public virtual Korisnik Korisnik { get; set; } = null!;

    public virtual Novost Novost { get; set; } = null!;
}
