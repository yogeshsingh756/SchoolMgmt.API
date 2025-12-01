using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Shared.Models.Reports
{
    public class ClassOutstandingDto
    {
        public int ClassId { get; set; }
        public string ClassName { get; set; } = string.Empty;
        public int InvoiceCount { get; set; }
        public decimal GrossAmount { get; set; }
        public decimal PaidAmount { get; set; }
        public decimal OutstandingAmount { get; set; }
    }
}
