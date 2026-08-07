using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Shared.Models.Fee
{
    public record ClassFeeMaster(
     int ClassFeeId, int OrganizationId, int ClassId, string? Section,
     int? SectionId, int? TermId, int? SessionId, int FeeTypeId, decimal Amount, DateTime? DueDate, bool IsActive);

    public record ConcessionUpsert(
    int ConcessionId, int StudentId, int FeeTypeId, string DiscountType, decimal DiscountValue, string? Remark, bool IsActive);

    public record InvoiceGenerateRequest(
        int StudentId, int ClassId, int? TermId, int? SessionId, DateTime InvoiceDate, DateTime? DueDate, string? Notes);

    public record PaymentCreateRequest(
        int StudentId,
        int? SessionId,
        string PaymentTarget,
        DateTime PaymentDate,
        string PaymentMode,
        string? ReferenceNo,
        string? Notes,
        decimal TotalPaidAmount);

    public record StudentOldFeeUpsert(
        int OldFeeId,
        int StudentId,
        int? SessionId,
        decimal TotalAmount,
        string? Notes,
        bool IsActive);

    public record StudentConcessionUpsert(
        int ConcessionId,
        int StudentId,
        int? SessionId,
        decimal Amount,
        string? Notes,
        bool IsActive);
}
