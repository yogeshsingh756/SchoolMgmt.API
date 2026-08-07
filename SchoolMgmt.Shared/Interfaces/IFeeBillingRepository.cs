using SchoolMgmt.Shared.Models.Fee;
using SchoolMgmt.Shared.Responses;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Shared.Interfaces
{
    public interface IFeeBillingRepository
    {
        Task<IEnumerable<dynamic>> GetClassFeeMasterAsync(int orgId, int page, int size, string search);
        Task<(int ClassFeeId, bool Success, string Message)> UpsertClassFeeAsync(ClassFeeMaster dto, int userId);
        Task<bool> DeleteClassFeeAsync(int orgId, int classFeeId, int userId);

        Task<IEnumerable<dynamic>> GetConcessionsAsync(int orgId, int studentId);
        Task<int> UpsertConcessionAsync(int orgId, ConcessionUpsert dto, int userId);

        Task<(int InvoiceId, string InvoiceNo)> GenerateInvoiceAsync(int orgId, InvoiceGenerateRequest req, int userId);
        Task<(IEnumerable<dynamic> Invoices, int TotalCount)> GetInvoicesAsync(
            int orgId, int page, int size, string? search,
            int? classId = null, string? status = null,
            DateTime? fromDate = null, DateTime? toDate = null,
            int? termId = null, int? sessionId = null);
        Task<(InvoiceHeaderDto header, IEnumerable<InvoiceItemDto> items, IEnumerable<PaymentAllocationDto> allocations)>
    GetInvoiceByIdAsync(int orgId, int invoiceId);
        Task<IEnumerable<dynamic>>  GetInvoicesByUserIdAsync(int orgId, int userId);

        Task<(bool Success, string Message, int PaymentId, string ReceiptNo, decimal Allocated, decimal Unallocated)> CreatePaymentAsync(int orgId, PaymentCreateRequest req, int userId);
        Task<(IEnumerable<dynamic> Payments, int TotalCount)> GetPaymentsAsync(
            int orgId, int page, int size, string? search,
            int? classId = null, int? sectionId = null, string? paymentMode = null,
            DateTime? fromDate = null, DateTime? toDate = null);
        Task<(dynamic? Header, IEnumerable<dynamic> Allocations)> GetPaymentByIdAsync(int orgId, int paymentId);

        Task<IEnumerable<dynamic>> GetStudentFeeBalancesAsync(int orgId, int classId, int? sectionId, int? sessionId, string? search);
        Task<(int OldFeeId, bool Success, string Message)> UpsertOldFeeAsync(int orgId, StudentOldFeeUpsert dto, int userId);
        Task<dynamic?> GetOldFeeByStudentAsync(int orgId, int studentId);
        Task<(bool Success, string Message)> DeleteOldFeeAsync(int orgId, int oldFeeId, int userId);

        Task<(int ConcessionId, bool Success, string Message)> UpsertStudentConcessionAsync(int orgId, StudentConcessionUpsert dto, int userId);
        Task<dynamic?> GetStudentConcessionByStudentAsync(int orgId, int studentId);
        Task<(bool Success, string Message)> DeleteStudentConcessionAsync(int orgId, int concessionId, int userId);

        Task<PaginatedResponse<StudentListModel>> GetAllStudentsAsync(
        int organizationId, int pageNumber, int pageSize, string search, int isDropdown = 0);
    }
}
