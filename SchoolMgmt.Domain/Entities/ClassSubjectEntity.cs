using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Domain.Entities
{
    public class ClassSubjectEntity
    {
        public int ClassSubjectId { get; set; }
        public int OrganizationId { get; set; }
        public int ClassId { get; set; }
        public int SubjectId { get; set; }
        public bool IsActive { get; set; }
        public DateTime CreatedOn { get; set; }
        public int CreatedBy { get; set; }

    }
}
