using System;
using System.Threading.Tasks;
using System.Web.Http;
using Microsoft.Owin;
using Microsoft.Owin.Security.OAuth;
using Owin;
using FixMe.API;

[assembly: OwinStartup(typeof(FixMe.API.OWINStartup))]

namespace FixMe.API
{
    public class OWINStartup
    {
        public void Configuration(IAppBuilder app)
        {
            app.UseCors(Microsoft.Owin.Cors.CorsOptions.AllowAll);
           
            var options = new OAuthAuthorizationServerOptions
            {
                AllowInsecureHttp = true,
                TokenEndpointPath = new PathString("/api/token"),
                AccessTokenExpireTimeSpan = TimeSpan.FromDays(12),
                Provider = new AuthorizationServerProvider()
            };
            app.UseOAuthAuthorizationServer(options);
            app.UseOAuthBearerAuthentication(new OAuthBearerAuthenticationOptions());

            HttpConfiguration config = new HttpConfiguration();
            WebApiConfig.Register(config);
        }
    }
}
