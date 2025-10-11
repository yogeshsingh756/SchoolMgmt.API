using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Domain.Entities
{
    public class Organization
    {
        public int OrganizationId { get; set; }
        public string SchoolName { get; set; } = string.Empty;
        public string? Address { get; set; }
        public string? Phone { get; set; }
        public string? Email { get; set; }
        public int? SubscriptionPlanId { get; set; }
        public bool IsTrial { get; set; }
        public DateTime? TrialExpiresAt { get; set; }
        public string TenantStatus { get; set; } = "Pending";
        public string? Timezone { get; set; }
        public string? Currency { get; set; }
        public string? Domain { get; set; }
        public bool IsActive { get; set; } = true;
        public bool IsDeleted { get; set; } = false;
        public DateTime CreatedOn { get; set; } = DateTime.UtcNow;
        public DateTime? ModifiedOn { get; set; }
        public int? ModifiedBy { get; set; }
        public int? CreatedBy { get; set; }
    }
}
