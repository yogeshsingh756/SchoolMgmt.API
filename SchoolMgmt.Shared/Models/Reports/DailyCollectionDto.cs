using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Shared.Models.Reports
{
    public class DailyCollectionDto
    {
        public DateTime CollectionDate { get; set; }
        public int PaymentsCount { get; set; }
        public decimal TotalCollected { get; set; }
        public decimal AllocatedAmount { get; set; }
        public decimal UnallocatedAmount { get; set; }
    }
}
