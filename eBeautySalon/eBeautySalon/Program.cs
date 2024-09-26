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
builder.Services.AddTransient<IRecenzijaUsluznikaService, RecenzijaUsluznikaService>();
builder.Services.AddTransient<IRecenzijaUslugeService, RecenzijaUslugeService>();
builder.Services.AddTransient<INovostiService, NovostiService>();
builder.Services.AddTransient<ISlikaNovostiService, SlikaNovostiService>();
builder.Services.AddTransient<ISlikaProfilaService, SlikaProfilaService>();
builder.Services.AddTransient<ISlikaUslugeService, SlikaUslugeService>();
builder.Services.AddTransient<ITerminiService, TerminiService>();
builder.Services.AddTransient<IRezervacijeService, RezervacijeService>();
builder.Services.AddTransient<IZaposleniciService, ZaposleniciService>();
builder.Services.AddTransient<IZaposleniciUslugeService, ZaposleniciUslugeService>();
builder.Services.AddTransient<IKorisniciUlogeService, KorisniciUlogeService>();
builder.Services.AddTransient<IUlogeService, UlogeService>();

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
builder.Services.AddDbContext<IB200070Context>(options => options.UseSqlServer(connectionString));


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

using (var scope = app.Services.CreateScope())
{
    var dataContext = scope.ServiceProvider.GetRequiredService<IB200070Context>();

    var con = dataContext.Database.GetConnectionString();

    if (dataContext.Database.EnsureCreated())
    {        
        dataContext.Database.Migrate();
    }
}




app.Run();
