using Microsoft.Owin.Security;
using Microsoft.Owin.Security.OAuth;
using FixMe.Repository;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using System.Web;

namespace FixMe.API
{
    public class AuthorizationServerProvider : OAuthAuthorizationServerProvider
    {
        private AccountRepo _account;
        public AuthorizationServerProvider()
        {
            _account = new AccountRepo();
        }
        public override async Task ValidateClientAuthentication(OAuthValidateClientAuthenticationContext context)
        {
            context.Validated();
        }

        public override async Task GrantResourceOwnerCredentials(OAuthGrantResourceOwnerCredentialsContext context)
        {
            var identity = new ClaimsIdentity(context.Options.AuthenticationType);

            if (!string.IsNullOrEmpty(context.UserName))
            {
                if (_account.AuthanticteAccount(context.UserName))
                {
                    int userId = _account.GetUserIdByMobileNo(context.UserName);
                    identity.AddClaim(new Claim(ClaimTypes.Name, context.UserName));
                    var props = new AuthenticationProperties(new Dictionary<string, string>{
                    {
                        "userId", Convert.ToString(userId)
                    }});

                    var ticket = new AuthenticationTicket(identity, props);
                    context.Validated(ticket);
                }
                else
                {
                    context.SetError("Not Found", "Mobile number not found...");
                    return;
                }
            }
            else
            {
                context.SetError("Error", "Please provide username parameter...");
                return;
            }
        }
        public override Task TokenEndpoint(OAuthTokenEndpointContext context)
        {
            try
            {
                foreach (KeyValuePair<string, string> property in context.Properties.Dictionary)
                {
                    context.AdditionalResponseParameters.Add(property.Key, property.Value);
                }

                return Task.FromResult<object>(null);
            }
            catch (Exception ex)
            {
                
                return null;
            }

        }

    }
}