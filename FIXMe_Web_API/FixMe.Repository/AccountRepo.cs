using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using FixMe.Database.DBModel;
using FixMe.Model;

namespace FixMe.Repository
{
    public class AccountRepo
    {
        public AccountRepo()
        {

        }

        public void RegisterMobile(RegisterModel model)
        {
            using (var db = new FixMeEntities())
            {
                var user = new User
                {
                    MobileNumber = model.MobileNumber,
                    MobileInstanceId = model.MobileInstanceId,
                    MobileKey = model.MobileKey,
                    CNIC = model.CNIC,
                    Name = model.Name,
                    Email = model.EmailAddress,
                    RegisteredOn = DateTime.Now,

                };
                db.Users.Add(user);
                db.SaveChanges();
            }
        }

        public bool FindNumber(string mobileNo)
        {
            using (var db = new FixMeEntities())
            {
                var user = db.Users.FirstOrDefault(x => x.MobileNumber == mobileNo);

                if (user == null)
                    return true;
            }
            return false;
        }

        public bool AuthanticteAccount(string mobileNo)
        {
            using (var db = new FixMeEntities())
            {
                var user = db.Users.FirstOrDefault(x => x.MobileNumber == mobileNo);

                if (user == null)
                    return false;
            }
            return true;
        }

        public int GetUserIdByMobileNo(string mobileNo)
        {
            int Id = 0;
            using (var db = new FixMeEntities())
            {
                var user = db.Users.FirstOrDefault(x => x.MobileNumber == mobileNo);

                if (user == null)
                    return Id;

                Id = user.Id;
            }
            return Id;
        }

        public int GetCurrentUserID()
        {
            var identity = (ClaimsIdentity)HttpContext.Current.User.Identity;
            var mobileNo = identity.Claims.Where(c => c.Type == ClaimTypes.Name).Select(c => c.Value).SingleOrDefault();
            return GetUserIdByMobileNo(mobileNo);
        }

    }
}
