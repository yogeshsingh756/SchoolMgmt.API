using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Domain.Entities
{
    public class TenantDbEntity
    {
        public int OrganizationId { get; set; }
        public string SchoolName { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string TenantStatus { get; set; } = string.Empty;
        public DateTime CreatedOn { get; set; }
    }
}
