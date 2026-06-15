using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Shared.Models.Tenant
{
    public class GetTenantsRequest
    {
        public int PageNumber { get; set; } = 1;

        public int PageSize { get; set; } = 10;

        public string? Search { get; set; }

        public bool? IsActive { get; set; }

        public string? SubscriptionStatus { get; set; }

        public int? PlanId { get; set; }

        public string? TenantStatus { get; set; }
    }
}
