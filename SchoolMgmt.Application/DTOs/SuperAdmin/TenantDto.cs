using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Application.DTOs.SuperAdmin
{
    public class TenantDto
    {
        public int OrganizationId { get; set; }
        public string SchoolName { get; set; } = string.Empty;
        public string? Email { get; set; }
        public string TenantStatus { get; set; } = "Pending";
        public DateTime CreatedOn { get; set; }
    }
}
