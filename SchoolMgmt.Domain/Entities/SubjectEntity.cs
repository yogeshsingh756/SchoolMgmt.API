using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Domain.Entities
{
    public class SubjectEntity
    {
        public int SubjectId { get; set; }
        public int OrganizationId { get; set; }
        public string SubjectName { get; set; } = string.Empty;
        public string? SubjectCode { get; set; }
        public string? Description { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime CreatedOn { get; set; }
        public DateTime? ModifiedOn { get; set; }
        public int CreatedBy { get; set; }
        public int ModifiedBy { get; set; }


    }
}
