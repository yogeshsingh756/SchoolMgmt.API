using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Application.DTOs.Tenants
{
    public class UpdateTenantDto
    {
        public int OrganizationId { get; set; }
        public string SchoolName { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string Phone { get; set; } = string.Empty;
        public string Address { get; set; } = string.Empty;
        public int SubscriptionPlanId { get; set; }
    }
}
