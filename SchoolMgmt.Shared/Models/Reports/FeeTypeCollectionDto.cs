using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Shared.Models.Reports
{
    public class FeeTypeCollectionDto
    {
        public int FeeTypeId { get; set; }
        public string FeeTypeName { get; set; } = string.Empty;
        public decimal InvoicedAmount { get; set; }
        public decimal CollectedAmount { get; set; }
        public decimal OutstandingAmount { get; set; }
    }
}
