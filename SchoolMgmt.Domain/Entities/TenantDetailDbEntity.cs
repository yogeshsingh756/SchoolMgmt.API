using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Domain.Entities
{
    public class TenantDetailDbEntity
    {
        public int OrganizationId { get; set; }
        public string SchoolName { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string Phone { get; set; } = string.Empty;
        public string PlanName { get; set; } = string.Empty;
        public DateTime StartedAt { get; set; }
        public DateTime ExpiresAt { get; set; }
        public string SubscriptionStatus { get; set; } = string.Empty;
        public bool IsActive { get; set; }
        public int UserCount { get; set; }
    }
}
