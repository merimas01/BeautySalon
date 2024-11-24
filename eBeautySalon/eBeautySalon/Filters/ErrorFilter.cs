using eBeautySalon.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using System.Net;

namespace eBeautySalon.Filters
{
    public class ErrorFilter : ExceptionFilterAttribute
    {
        //kad god se desi exception, ova metoda ce se pozvati
        public override void OnException(ExceptionContext context)
        {
            if (context.Exception is UserException)
            {
                context.ModelState.AddModelError("ERROR", context.Exception.Message);
                context.HttpContext.Response.StatusCode = (int)HttpStatusCode.BadRequest; //400
            }
            else //ako je samo Exception   
            {
                context.ModelState.AddModelError("ERROR", "Server side error");
                context.HttpContext.Response.StatusCode = (int)HttpStatusCode.InternalServerError; //500
            }

            var list = context.ModelState.Where(x => x.Value.Errors.Count() > 0)
                .ToDictionary(x => x.Key, y => y.Value.Errors.Select(x => x.ErrorMessage));

            context.Result = new JsonResult(new { errors = list });

        }
    }
}
