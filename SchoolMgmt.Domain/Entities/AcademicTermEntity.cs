using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Domain.Entities
{
    public class AcademicTermEntity
    {
        public int TermId { get; set; }
        public int OrganizationId { get; set; }
        public string TermName { get; set; } = string.Empty;
        public int? StartMonth { get; set; }
        public int? EndMonth { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime CreatedOn { get; set; }
    }
}
