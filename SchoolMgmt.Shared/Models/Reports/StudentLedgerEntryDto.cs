using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Shared.Models.Reports
{
    public class StudentLedgerEntryDto
    {
        public DateTime TxnDate { get; set; }
        public string Description { get; set; } = string.Empty;
        public int? InvoiceId { get; set; }
        public int? InvoiceItemId { get; set; }
        public int? FeeTypeId { get; set; }
        public string FeeTypeName { get; set; } = string.Empty;
        public decimal Debit { get; set; }
        public decimal Credit { get; set; }
    }
}
