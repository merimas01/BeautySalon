using eBeautySalon;
using eBeautySalon.Controllers;
using eBeautySalon.Filters;
using eBeautySalon.Models;
using eBeautySalon.Models.Requests;
using eBeautySalon.Models.SearchObjects;
using eBeautySalon.Services;
using eBeautySalon.Services.Database;
using Microsoft.AspNetCore.Authentication;
using Microsoft.EntityFrameworkCore;
using Microsoft.OpenApi.Models;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddTransient<IUslugeService, UslugeService>();
builder.Services.AddTransient<IKorisniciService, KorisniciService>();
builder.Services.AddTransient<IKategorijeService, KategorijeService>();
builder.Services.AddTransient<IKomentariService, KomentariService>();
builder.Services.AddTransient<IOcjeneService, OcjeneService>();
//builder.Services.AddTransient
//    <ICRUDService<Komentari,BaseSearchObject,KomentariInsertRequest,KomentariUpdateRequest>,
//    BaseCRUDService<Komentari, Komentar, BaseSearchObject, KomentariInsertRequest, KomentariUpdateRequest>>(); //bez interfejsa i servisa

builder.Services.AddControllers(x =>
{
    x.Filters.Add<ErrorFilter>();
});
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen( c=>
    {
        c.AddSecurityDefinition("basicAuth", new Microsoft.OpenApi.Models.OpenApiSecurityScheme()
        {
            Type = Microsoft.OpenApi.Models.SecuritySchemeType.Http,
            Scheme = "basic"
        });

        c.AddSecurityRequirement(new Microsoft.OpenApi.Models.OpenApiSecurityRequirement()
        {
            {
                new OpenApiSecurityScheme
                {
                    Reference=new OpenApiReference{Type=ReferenceType.SecurityScheme, Id="basicAuth"}
                },
                new string[]{}
            }
        });
    }
);

builder.Services.AddAutoMapper(typeof(IKorisniciService));
builder.Services.AddAuthentication("BasicAuthentication")
    .AddScheme<AuthenticationSchemeOptions, BasicAuthenticationHandler>("BasicAuthentication", null);


var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
builder.Services.AddDbContext<BeautySalonContext>(options => options.UseSqlServer(connectionString));


var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();
