using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Application.DTOs.SuperAdmin
{
    public class SubscriptionPlanDto
    {
        public int PlanId { get; set; }
        public string PlanName { get; set; } = string.Empty;
        public string? Description { get; set; }
        public decimal Price { get; set; }
        public string BillingCycle { get; set; } = "Monthly";
        public int? CustomMonths { get; set; }
        public bool IsActive { get; set; }
    }
}
