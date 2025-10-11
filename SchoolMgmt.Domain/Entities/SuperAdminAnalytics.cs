using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Domain.Entities
{
    public class SuperAdminAnalytics
    {
        public int TotalTenants { get; set; }
        public int ActiveTenants { get; set; }
        public int InactiveTenants { get; set; }
        public int TotalUsers { get; set; }
        public int ActiveSubscriptions { get; set; }
        public int ExpiredSubscriptions { get; set; }
    }
}
