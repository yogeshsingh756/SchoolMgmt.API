using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Application.DTOs.Tenants
{
    public class TenantRegistrationResultDto
    {
        public bool Success { get; set; }
        public string Message { get; set; } = string.Empty;
        public int OrganizationId { get; set; }
        public int AdminUserId { get; set; }
    }
}
