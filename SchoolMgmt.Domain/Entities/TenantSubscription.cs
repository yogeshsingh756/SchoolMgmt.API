using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Domain.Entities
{
    public class TenantSubscription
    {
        public int TenantSubscriptionId { get; set; }
        public int OrganizationId { get; set; }
        public int PlanId { get; set; }
        public DateTime StartedAt { get; set; } = DateTime.UtcNow;
        public DateTime? ExpiresAt { get; set; }
        public bool IsTrial { get; set; } = false;
        public string Status { get; set; } = "Active";
        public bool AutoRenew { get; set; } = false;
        public string? PaymentMethod { get; set; }
        public string? LastPaymentRef { get; set; }
    }
}
