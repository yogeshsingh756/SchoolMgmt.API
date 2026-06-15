using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Shared.Models.Tenant
{
    public class TenantListDto
    {
        public int OrganizationId { get; set; }

        public string SchoolName { get; set; } = string.Empty;

        public string? Email { get; set; }

        public string? Phone { get; set; }

        public string? Domain { get; set; }

        public string? Timezone { get; set; }

        public string? Currency { get; set; }

        public bool IsTrial { get; set; }

        public DateTime? TrialExpiresAt { get; set; }

        public bool IsActive { get; set; }

        public string? TenantStatus { get; set; }

        public DateTime? CreatedOn { get; set; }

        public int? SubscriptionId { get; set; }

        public int? PlanId { get; set; }

        public string? PlanName { get; set; }

        public decimal? Price { get; set; }

        public DateTime? StartedAt { get; set; }

        public DateTime? ExpiresAt { get; set; }

        public string? SubscriptionStatus { get; set; }

        public int UserCount { get; set; }

        public int TeacherCount { get; set; }

        public int StudentCount { get; set; }

        public int ParentCount { get; set; }
    }
}
