using FixMe.Model;
using FixMe.Repository;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;
using System.Web.Http.Description;

namespace FixMe.API.Controllers
{
    public class DonationController : ApiController
    {
        private DonationRepo _dontaion;
        public DonationController()
        {
            _dontaion = new DonationRepo();
        }

        [HttpPost]
        [ResponseType(typeof(DonationRequestModel))]
        [Route("api/donation/request")]
        public IHttpActionResult CreateNewDonationRequest(DonationRequestModel model)
        {
            try
            {
                var context = HttpContext.Current.Request;

                var tempModel = new DonationRequestModel
                {
                    Title = context.Form["Title"],
                    Address = context.Form["Address"],
                    Category = Convert.ToInt32(context.Form["Category"]),
                    Description = context.Form["Description"],
                    Latitude = Convert.ToDouble(context.Form["Latitude"]),
                    Longitude = Convert.ToDouble(context.Form["Longitude"]),
                    TimeFrame = Convert.ToInt32(context.Form["TimeFrame"]),
                    Amount = Convert.ToInt64(context.Form["Amount"]),
                    UserId = Convert.ToInt32(context.Form["UserId"])
                };

                foreach (string file in context.Files)
                {
                    var postedFile = context.Files[file];
                    if (postedFile != null && postedFile.ContentLength > 0)
                    {
                        int MaxContentLength = 1024 * 1024 * 5; //Size = 5 MB

                        IList<string> AllowedFileExtensions = new List<string> { ".jpg", ".png" };
                        var ext = postedFile.FileName.Substring(postedFile.FileName.LastIndexOf('.'));
                        var extension = ext.ToLower();
                        if (!AllowedFileExtensions.Contains(extension))
                        {
                            return Json(new { success = false, message = "Please Upload image of type .jpg" });
                        }
                        else if (postedFile.ContentLength > MaxContentLength)
                        {
                            return Json(new { success = false, message = "Please Upload a file upto 5 MB." });
                        }
                        else
                        {
                            var currentTimeStamp = DateTime.Now.ToShortDateString().Replace(" ", "-").Replace("/", "-") + "T" + DateTime.Now.ToLongTimeString().Replace(":", "-").Replace(" ", "-");
                            tempModel.Image = "/Content/Images/DonationRequest/" + "Image_" + currentTimeStamp + extension;

                            var imagePath = HttpContext.Current.Server.MapPath("~" + tempModel.Image);
                            postedFile.SaveAs(imagePath);

                            tempModel.Image = Request.RequestUri.Scheme + "://" + Request.RequestUri.Authority + tempModel.Image;
                        }
                    }
                }

                _dontaion.RequestForNewDonation(tempModel);
                return Json(new { success = true, message = "Donation request created successfully..." });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = ex.Message});
            }
        }


        [HttpGet]
        [ResponseType(typeof(List<DonationRequestModel>))]
        [Route("api/donations/{category}")]
        public IHttpActionResult GetDonationsByCategoryId(int category)
        {
            try
            {
                List<DonationRequestModel> donationsRequired = _dontaion.GetDonationsByCategory(category);
                return Json(new { success = true, donationsRequired });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = ex.Message });
            }
        }

        [HttpGet]
        [ResponseType(typeof(List<DonationRequestModel>))]
        [Route("api/donations/user/{id}")]
        public IHttpActionResult GetDonationsByUser(int id)
        {
            try
            {
                List<DonationRequestModel> donationsRequired = _dontaion.GetDonationsByUser(id);
                return Json(new { success = true, donationsRequired });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = ex.Message });
            }
        }

        [HttpPost]
        [ResponseType(typeof(string))]
        [Route("api/donation/create")]
        public IHttpActionResult CreateDonation(DonatinoModel model)
        {
            try
            {
                _dontaion.CreateDonation(model);
                
                return Json(new { success = true, message = "You have successfully donated" });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = ex.Message });
            }
        }

    }
}
