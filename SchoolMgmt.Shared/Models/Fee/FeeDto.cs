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
    public class InvoiceHeaderDto
    {
        public int InvoiceId { get; set; }
        public string InvoiceNo { get; set; }
        public int StudentId { get; set; }
        public string AdmissionNo { get; set; }
        public string StudentName { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Email { get; set; }
        public string Phone { get; set; }

        public DateTime InvoiceDate { get; set; }
        public DateTime? DueDate { get; set; }

        public int? TermId { get; set; }
        public int? SessionId { get; set; }

        public decimal TotalAmount { get; set; }
        public decimal TotalDiscount { get; set; }
        public decimal NetPayable { get; set; }
        public decimal PaidAmount { get; set; }
        public decimal BalanceAmount { get; set; }

        public string Status { get; set; }
        public string Notes { get; set; }
    }

    public class InvoiceItemDto
    {
        public int InvoiceItemId { get; set; }
        public int FeeTypeId { get; set; }
        public string FeeTypeName { get; set; }

        public decimal Amount { get; set; }
        public decimal DiscountAmount { get; set; }
        public decimal NetAmount { get; set; }
        public decimal PaidAmount { get; set; }
    }

    public class PaymentAllocationDto
    {
        public int AllocationId { get; set; }
        public int PaymentId { get; set; }
        public string ReceiptNo { get; set; }
        public int InvoiceItemId { get; set; }
        public decimal AllocatedAmount { get; set; }

        public DateTime PaymentDate { get; set; }
        public string PaymentMode { get; set; }
        public string ReferenceNo { get; set; }
        public decimal TotalPaidAmount { get; set; }
    }
}
