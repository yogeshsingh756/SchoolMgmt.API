using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Application.DTOs.User
{
    public class RenewSubscriptionRequest
    {
        public int PlanId { get; set; }
        public bool IsTrial { get; set; }
        public int? CustomMonths { get; set; }
    }
}
