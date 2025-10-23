using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Shared.Models.Fee
{
    public class FeeDto
    {
        public int FeeId { get; set; }
        public int OrganizationId { get; set; }
        public int ClassId { get; set; }
        public string FeeType { get; set; } = string.Empty;
        public decimal Amount { get; set; }
        public DateTime? DueDate { get; set; }
        public string Term { get; set; } = string.Empty;
        public string Session { get; set; } = string.Empty;
        public string Status { get; set; } = "Pending";
    }
}
