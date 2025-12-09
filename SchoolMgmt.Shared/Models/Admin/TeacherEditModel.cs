using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Shared.Models.Admin
{
    public class TeacherEditModel
    {
        // Keys
        public int TeacherUserId { get; set; }    // Users.UserId
        public int TeacherId { get; set; }        // Teachers.TeacherId
        public int OrganizationId { get; set; }

        // Basic info
        public string TeacherFirstName { get; set; }
        public string TeacherLastName { get; set; }
        public string TeacherUsername { get; set; }
        public string TeacherEmail { get; set; }
        public string TeacherPhoneNumber { get; set; }

        // Teacher-specific fields
        public string Qualification { get; set; }
        public string Designation { get; set; }
        public decimal? Salary { get; set; }

        // Address from Users table
        public string Address { get; set; }

        // Metadata
        public bool IsActive { get; set; }
        public DateTime CreatedOn { get; set; }
        public DateTime? ModifiedOn { get; set; }
        public int CreatedBy { get; set; }
        public int? ModifiedBy { get; set; }
    }
}
