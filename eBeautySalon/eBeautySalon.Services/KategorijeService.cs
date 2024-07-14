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
    public class KategorijeService : BaseCRUDService<Kategorije,Kategorija,KategorijeSearchObject, KategorijeInsertRequest, KategorijeUpdateRequest>, IKategorijeService
    {
        public KategorijeService(BeautySalonContext context, IMapper mapper) : base(context,mapper)
        {
        }

        public override IQueryable<Kategorija> AddFilter(IQueryable<Kategorija> query, KategorijeSearchObject? search = null)
        {
            if (!string.IsNullOrWhiteSpace(search?.Naziv))
            {
                query = query.Where(x => x.Naziv.StartsWith(search.Naziv));
            }
            if (!string.IsNullOrWhiteSpace(search?.Opis))
            {
                query = query.Where(x => x.Opis != null && x.Opis.StartsWith(search.Opis));
            }
           
            return base.AddFilter(query, search);
        }

        //public override IQueryable<Kategorija> AddInclude(IQueryable<Kategorija> query, KategorijeSearchObject? search = null)
        //{
        //    if (search?.isUslugeIncluded == true)
        //    {
        //        query = query.Include("Uslugas");
        //    }
        //    return base.AddInclude(query, search);
        //}
    }
}
