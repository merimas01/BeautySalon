﻿using AutoMapper;
using eBeautySalon.Models;
using eBeautySalon.Models.Requests;
using eBeautySalon.Models.SearchObjects;
using eBeautySalon.Services.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBeautySalon.Services
{
    public class UslugeService : BaseCRUDService<Usluge,Usluga, UslugeSearchObject, UslugeInsertRequest, UslugeUpdateRequest> , IUslugeService
    {
        public UslugeService(BeautySalonContext context, IMapper mapper) : base(context, mapper)
        {
        }
    }
}
