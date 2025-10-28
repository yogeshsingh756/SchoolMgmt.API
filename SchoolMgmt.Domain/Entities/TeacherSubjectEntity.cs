using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Domain.Entities
{
    public class TeacherSubjectEntity
    {
        public int TeacherSubjectId { get; set; }
        public int OrganizationId { get; set; }
        public int TeacherId { get; set; }
        public int ClassId { get; set; }
        public int? SectionId { get; set; }
        public int SubjectId { get; set; }
        public bool IsPrimary { get; set; }
        public bool IsActive { get; set; }
        public DateTime CreatedOn { get; set; }
        public int CreatedBy { get; set; }
        public string? SectionName { get; set; }
        public string? SubjectName { get; set; }

    }
}
