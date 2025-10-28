using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Application.DTOs.Admin
{
    public class AssignSubjectRequest
    {
        public int ClassId { get; set; }
        public int? SectionId { get; set; }
        public int SubjectId { get; set; }
        public bool IsPrimary { get; set; }
    }
}
