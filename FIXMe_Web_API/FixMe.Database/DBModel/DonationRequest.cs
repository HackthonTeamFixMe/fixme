//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace FixMe.Database.DBModel
{
    using System;
    using System.Collections.Generic;
    
    public partial class DonationRequest
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public DonationRequest()
        {
            this.Donations = new HashSet<Donation>();
        }
    
        public int Id { get; set; }
        public string Title { get; set; }
        public long Amount { get; set; }
        public Nullable<long> AmountLeft { get; set; }
        public int Category { get; set; }
        public string Description { get; set; }
        public double Longitude { get; set; }
        public double Latitude { get; set; }
        public string Address { get; set; }
        public int TimeFrame { get; set; }
        public string Image { get; set; }
        public int CreatedBy { get; set; }
        public System.DateTime CreatedOn { get; set; }
        public bool IsCompleted { get; set; }
        public string Status { get; set; }
    
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Donation> Donations { get; set; }
        public virtual User User { get; set; }
    }
}
