using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using FixMe.Repository;
using FixMe.Model;
using System.Web.Http;
using System.Web.Http.Description;

namespace FixMe.API.Controllers
{
    public class AccountController : ApiController
    {
        private AccountRepo _account;
        public AccountController()
        {
            _account = new AccountRepo();
        }

        [ResponseType(typeof(bool))]
        [Route("api/account/register")]
        public IHttpActionResult RegisterMobileNo(RegisterModel model)
        {
            try
            {
                _account.RegisterMobile(model);
                return Json(new { success = true, message = "Mobile number registered successfully..." });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = ex.Message });
            }
        }

        [HttpGet]
        [ResponseType(typeof(VerifyModel))]
        [Route("api/account/verify")]
        public IHttpActionResult VerifyMobileNo(string mobileNo)
        {
            try
            {
                if (!mobileNo.Contains('+'))
                    mobileNo = mobileNo.Replace(" ", "+");
                bool isFirstTimeLogin = _account.FindNumber(mobileNo);
                return Json(new { success = true, isFirstTimeLogin });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = ex.Message });
            }
        }
    }
}
