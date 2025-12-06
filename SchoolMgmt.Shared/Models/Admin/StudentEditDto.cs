using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Shared.Models.Admin
{
    public class StudentEditDto
    {
        public int StudentUserId { get; set; }
        public int StudentId { get; set; }
        public int OrganizationId { get; set; }

        public string StudentFirstName { get; set; } = null!;
        public string StudentLastName { get; set; } = null!;
        public string StudentUsername { get; set; } = null!;
        public string? StudentEmail { get; set; }
        public string StudentPhoneNumber { get; set; } = null!;

        public string? AdmissionNo { get; set; }
        public DateTime? AdmissionDate { get; set; }

        public int? ClassId { get; set; }
        public string? ClassName { get; set; }

        // 🔹 for dropdown selected value
        public int? ParentId { get; set; }
    }
}
