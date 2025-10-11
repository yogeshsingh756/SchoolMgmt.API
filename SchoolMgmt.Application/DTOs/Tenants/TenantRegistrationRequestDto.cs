using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Application.DTOs.Tenants
{
    public class TenantRegistrationRequestDto
    {
        public string SchoolName { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string Phone { get; set; } = string.Empty;
        public string Address { get; set; } = string.Empty;
        public int SubscriptionPlanId { get; set; }
        public string AdminFirstName { get; set; } = string.Empty;
        public string AdminLastName { get; set; } = string.Empty;
        public string AdminUsername { get; set; } = string.Empty;
        public string AdminPassword { get; set; } = string.Empty;
        public string AdminEmail { get; set; } = string.Empty;
    }
}
