using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FixMe.Model;
using FixMe.Database.DBModel;

namespace FixMe.Repository
{
    public class DonationRepo
    {
        private AccountRepo _account;
        public DonationRepo()
        {
            _account = new AccountRepo();
        }

        public void RequestForNewDonation(DonationRequestModel model)
        {
            using (var db = new FixMeEntities())
            {
                var tempModel = new DonationRequest
                {
                    Address = model.Address,
                    Amount = model.Amount,
                    Category = model.Category,
                    CreatedOn = DateTime.Now,
                    CreatedBy = model.UserId,
                    Description = model.Description,
                    Image = model.Image,
                    Latitude = model.Latitude,
                    Longitude = model.Longitude,
                    TimeFrame = model.TimeFrame,
                    Title = model.Title,
                    AmountLeft = 0,
                    Status = "Un Verified",
                    IsCompleted = false
                };

                db.DonationRequests.Add(tempModel);
                db.SaveChanges();
            }
        }

        public List<DonationRequestModel> GetDonationsByCategory(int category)
        {
            using (var db = new FixMeEntities())
            {
                var lst = db.DonationRequests.Where(x => x.Category == category && x.IsCompleted == false).ToList();

                var requestList = new List<DonationRequestModel>();
                foreach (var donationRequest in lst)
                {
                    double? percentage = (Convert.ToDouble(donationRequest.AmountLeft) / Convert.ToDouble(donationRequest.Amount)) * 100.0;
                    var request = new DonationRequestModel {
                        DonationRequestId = donationRequest.Id,
                        Address = donationRequest.Address,
                        Amount = donationRequest.Amount,
                        AmountRecieved = donationRequest.AmountLeft,
                        AmountCompletedPercentage = percentage,
                        Category = donationRequest.Category,
                        Description = donationRequest.Description,
                        Image = donationRequest.Image,
                        Latitude = donationRequest.Latitude,
                        Longitude = donationRequest.Longitude,
                        TimeFrame = donationRequest.TimeFrame,
                        Title = donationRequest.Title,
                        Status = donationRequest.Status,
                        UserId = donationRequest.User.Id,
                        User = new UserModel
                        {
                            CNIC = donationRequest.User.CNIC,
                            Email = donationRequest.User.Email,
                            MobileNumber = donationRequest.User.MobileNumber,
                            Name = donationRequest.User.Name
                        }
                    };

                    requestList.Add(request);
                }

                return requestList;
            }
        }

        public void CreateDonation(DonatinoModel model)
        {
            using (var db = new FixMeEntities())
            {
                var tempModel = new Donation
                {
                    DonationRequestId = model.DonationRequestId,
                    AmountDonated = model.AmountDonated,
                    DonatedBy = model.UserId,
                    DonatedOn = DateTime.Now
                };

                db.Donations.Add(tempModel);
                db.SaveChanges();

                AddDonationAmountToDonationRequestAccount(model.DonationRequestId, model.AmountDonated);
            }
        }

        private void AddDonationAmountToDonationRequestAccount(int Id, long amountDonated)
        {
            using (var db = new FixMeEntities())
            {
                var donationRequest = db.DonationRequests.Find(Id);
                donationRequest.AmountLeft = donationRequest.AmountLeft + amountDonated;
                db.SaveChanges();
            }
        }

        public List<DonationRequestModel> GetDonationsByUser(int id)
        {
            using (var db = new FixMeEntities())
            {
                var donations = db.Donations.Where(x => x.DonatedBy == id).ToList();
                donations = donations.GroupBy(x => x.DonationRequestId)
                                  .Select(g => g.First())
                                  .ToList();


                var requestList = new List<DonationRequestModel>();

                foreach (var donation in donations)
                {
                    var donationRequest = db.DonationRequests.FirstOrDefault(x => x.Id == donation.DonationRequestId);

                    if(donationRequest != null)
                    {
                        double? percentage = (Convert.ToDouble(donationRequest.AmountLeft) / Convert.ToDouble(donationRequest.Amount)) * 100.0;
                        var request = new DonationRequestModel
                        {
                            DonationRequestId = donationRequest.Id,
                            Address = donationRequest.Address,
                            Amount = donationRequest.Amount,
                            AmountRecieved = donationRequest.AmountLeft,
                            AmountCompletedPercentage = percentage,
                            Category = donationRequest.Category,
                            Description = donationRequest.Description,
                            Image = donationRequest.Image,
                            Latitude = donationRequest.Latitude,
                            Longitude = donationRequest.Longitude,
                            TimeFrame = donationRequest.TimeFrame,
                            Title = donationRequest.Title,
                            Status = donationRequest.Status,
                            UserId = donationRequest.User.Id,
                            User = new UserModel
                            {
                                CNIC = donationRequest.User.CNIC,
                                Email = donationRequest.User.Email,
                                MobileNumber = donationRequest.User.MobileNumber,
                                Name = donationRequest.User.Name
                            }
                        };
                        requestList.Add(request);
                    }
                }

                return requestList;
            }
        }
    }
}
