using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FixMe.Model
{
    public class DonationRequestModel
    {
        public int DonationRequestId { get; set; }
        public int UserId { get; set; }
        public string Title { get; set; }
        public long Amount { get; set; }
        public long? AmountRecieved { get; set; }
        public double? AmountCompletedPercentage { get; set; }
        public int Category { get; set; }
        public string Description { get; set; }
        public double Longitude { get; set; }
        public double Latitude { get; set; }
        public string Address { get; set; }
        public int TimeFrame { get; set; }
        public string Image { get; set; }
        public string Status { get; set; }
        public UserModel User { get; set; }
    }

    public class DonatinoModel
    {
        public int DonationRequestId { get; set; }
        public long AmountDonated { get; set; }
        public int UserId { get; set; }
    }
}
