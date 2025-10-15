using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Shared.Models.Subject
{
    public class ClassSubjectDto
    {
        public int ClassSubjectId { get; set; }
        public int ClassId { get; set; }
        public int SubjectId { get; set; }
        public string? SubjectName { get; set; }
        public string? SubjectCode { get; set; }
        public bool IsActive { get; set; }
    }
}
