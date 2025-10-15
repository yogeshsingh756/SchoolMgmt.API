using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Shared.Models.Subject
{
    public class SubjectDto
    {
        public int SubjectId { get; set; }
        public string SubjectName { get; set; } = string.Empty;
        public string? SubjectCode { get; set; }
        public string? Description { get; set; }
        public bool IsActive { get; set; }
    }
}
