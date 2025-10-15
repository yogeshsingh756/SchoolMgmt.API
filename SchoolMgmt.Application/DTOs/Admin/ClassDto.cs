using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Application.DTOs.Admin
{
    public class ClassDto
    {
        public int ClassId { get; set; }
        public string ClassName { get; set; } = string.Empty;
        public string? Description { get; set; }
        public int? ClassTeacherId { get; set; }
        public string? ClassTeacherName { get; set; }
        public string? AcademicYear { get; set; }
        public int? OrderNo { get; set; }
        public bool IsActive { get; set; } = true;
    }
}
