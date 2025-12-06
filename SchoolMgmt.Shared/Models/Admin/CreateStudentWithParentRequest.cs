using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Shared.Models.Admin
{
    public class CreateStudentWithParentRequest
    {
        public int OrganizationId { get; set; }
        public int CreatedBy { get; set; }

        /// <summary>
        /// If null => create NEW parent
        /// If not null => use EXISTING parent (Parents.ParentId)
        /// </summary>
        public int? ParentId { get; set; }

        // Parent fields (used only if ParentId is null)
        public string? ParentFirstName { get; set; }
        public string? ParentLastName { get; set; }
        public string? ParentUsername { get; set; }
        public string? ParentEmail { get; set; }
        public string? ParentPasswordHash { get; set; }
        public string? ParentPhoneNumber { get; set; }
        public string? ParentOccupation { get; set; }
        public string? ParentAddress { get; set; }

        // Student fields (always used)
        public string StudentFirstName { get; set; } = null!;
        public string StudentLastName { get; set; } = null!;
        public string StudentUsername { get; set; } = null!;
        public string? StudentEmail { get; set; }
        public string StudentPasswordHash { get; set; } = null!;
        public string StudentPhoneNumber { get; set; } = null!;
        public string? AdmissionNo { get; set; }
        public int? ClassId { get; set; }

        public bool IsExistingParent => ParentId.HasValue;
    }
}
