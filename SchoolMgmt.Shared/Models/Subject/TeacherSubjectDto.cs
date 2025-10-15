using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Shared.Models.Subject
{
    public class TeacherSubjectDto
    {
        public int TeacherSubjectId { get; set; }
        public int TeacherId { get; set; }
        public int ClassId { get; set; }
        public int? SectionId { get; set; }
        public int SubjectId { get; set; }
        public string? SubjectName { get; set; }
        public string? ClassName { get; set; }
        public string? SectionName { get; set; }
        public bool IsPrimary { get; set; }
        public bool IsActive { get; set; }
    }
}
