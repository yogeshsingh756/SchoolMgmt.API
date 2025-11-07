using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Application.DTOs.FeesDTO
{
    public record ClassFeeMasterDto(
     int ClassFeeId, int OrganizationId, int ClassId, string? Section,
     int? TermId, int? SessionId, int FeeTypeId, decimal Amount, DateTime? DueDate, bool IsActive);

    public record ConcessionUpsertDto(
        int ConcessionId, int StudentId, int FeeTypeId, string DiscountType, decimal DiscountValue, string? Remark, bool IsActive);

    public record InvoiceGenerateRequest(
        int StudentId, int ClassId, int? TermId, int? SessionId, DateTime InvoiceDate, DateTime? DueDate, string? Notes);

    public record PaymentCreateRequest(
        int StudentId, DateTime PaymentDate, string PaymentMode, string? ReferenceNo, string? Notes, decimal TotalPaidAmount);
}
