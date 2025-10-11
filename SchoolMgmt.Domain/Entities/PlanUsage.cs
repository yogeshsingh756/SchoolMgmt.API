using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Domain.Entities
{
    public class PlanUsage
    {
        public int PlanId { get; set; }
        public string PlanName { get; set; } = string.Empty;
        public int TenantCount { get; set; }
        public int ActiveTenants { get; set; }
    }
}
