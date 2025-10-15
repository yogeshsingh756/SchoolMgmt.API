using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Application.DTOs.Admin
{
    public class SectionDto
    {
        public int SectionId { get; set; }
        public int ClassId { get; set; }
        public string SectionName { get; set; } = string.Empty;
        public string? Description { get; set; }
        public int? ClassTeacherId { get; set; }
        public string? ClassTeacherName { get; set; }
        public int? Capacity { get; set; }
        public bool IsActive { get; set; } = true;
    }
}
