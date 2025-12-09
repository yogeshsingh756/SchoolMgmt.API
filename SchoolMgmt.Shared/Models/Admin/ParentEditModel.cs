using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Shared.Models.Admin
{
    public class ParentEditModel
    {
        // Keys
        public int ParentUserId { get; set; }      // Users.UserId
        public int ParentId { get; set; }          // Parents.ParentId
        public int OrganizationId { get; set; }

        // Basic info
        public string ParentFirstName { get; set; }

        public string ParentLastName { get; set; }

        public string ParentUsername { get; set; }
        public string ParentEmail { get; set; }

        public string ParentPhoneNumber { get; set; }

        // Parent-specific
        public string Occupation { get; set; }

        // Address comes from Users table
        public string Address { get; set; }

        // Metadata
        public bool IsActive { get; set; }

        public DateTime CreatedOn { get; set; }

        public DateTime? ModifiedOn { get; set; }

        public int CreatedBy { get; set; }

        public int? ModifiedBy { get; set; }
    }
}
