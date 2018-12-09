using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;

namespace FixMe.API
{
    public static class WebApiConfig
    {
        public static void Register(HttpConfiguration config)
        {
            // Web API configuration and services

            // Web API routes
            config.MapHttpAttributeRoutes();

            config.Routes.MapHttpRoute(
                name: "DefaultApi",
                routeTemplate: "api/{controller}/{id}",
                defaults: new { id = RouteParameter.Optional }
            );

            // Implement Filter on All Methods Except Method with Filter Allow Anonymous
            //config.Filters.Add(new Helpers.AuthorizeAttribute());
            config.Formatters.XmlFormatter.SupportedMediaTypes.Add(new System.Net.Http.Headers.MediaTypeHeaderValue("multipart/form-data"));

        }
    }
}
