using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMe.Model
{
    public class RegisterModel
    {
        public string MobileNumber { get; set; }
        public string MobileInstanceId { get; set; }
        public string MobileKey { get; set; }
        public string EmailAddress { get; set; }
        public string Name { get; set; }
        public string CNIC { get; set; }
    }

    public class VerifyModel
    {
        public bool isFirstTimeLogin { get; set; }
    }
}
