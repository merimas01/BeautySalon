﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace eBeautySalon.Models.Requests
{
    public class ZaposleniciUslugeUpdateRequest
    {
        [Required]
        public int ZaposlenikId { get; set; }

        [Required]
        public int UslugaId { get; set; }

        [JsonIgnore]
        public DateTime? DatumModificiranja { get; set; } = DateTime.Now;

    }
}
