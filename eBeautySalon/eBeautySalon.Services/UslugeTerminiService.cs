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
    public class UslugeTerminiService : BaseCRUDService<UslugeTermini, UslugaTermin, UslugeTerminiSearchObject, UslugeTerminiInsertRequest, UslugeTerminiUpdateRequest>, IUslugeTerminiService
    {
        public UslugeTerminiService(Ib200070Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<UslugaTermin> AddFilter(IQueryable<UslugaTermin> query, UslugeTerminiSearchObject? search = null)
        {
            if(search.uslugaId != null)
            {
                query = query.Where(x => x.UslugaId == search.uslugaId).AsQueryable();
            }
            return base.AddFilter(query, search);
        }

        public override IQueryable<UslugaTermin> AddInclude(IQueryable<UslugaTermin> query, UslugeTerminiSearchObject? search = null)
        {
            if ( search.isUslugaIncluded == true)
            {
                query = query.Include(x => x.Usluga.SlikaUsluge);
                query = query.Include(x => x.Usluga.Kategorija);
            }
            if ( search.isTerminIncluded == true)
            {
                query = query.Include(x => x.Termin);
            }
            return base.AddInclude(query, search);
        }
    }
}
