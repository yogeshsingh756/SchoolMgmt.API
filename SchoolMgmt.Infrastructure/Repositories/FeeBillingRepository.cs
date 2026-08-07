using Azure;
using Dapper;
using SchoolMgmt.Shared.Interfaces;
using SchoolMgmt.Shared.Models.Fee;
using SchoolMgmt.Shared.Responses;
using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Infrastructure.Repositories
{
    public class FeeBillingRepository : IFeeBillingRepository
    {
        private readonly IDbConnectionFactory _dbFactory;

        public FeeBillingRepository(IDbConnectionFactory dbFactory)
        {
            _dbFactory = dbFactory;
        }

        // --------------------------------------
        // 1️⃣ CLASS FEE MASTER
        // --------------------------------------
        public async Task<IEnumerable<dynamic>> GetClassFeeMasterAsync(int orgId, int page, int size, string search)
        {
            using var conn = _dbFactory.CreateConnection();
            var result = await conn.QueryAsync("sp_Admin_ClassFeeMaster_GetAll",
                new { p_OrganizationId = orgId, p_PageNumber = page, p_PageSize = size, p_Search = search },
                commandType: CommandType.StoredProcedure);
            return result;
        }

        public async Task<(int ClassFeeId, bool Success, string Message)> UpsertClassFeeAsync(ClassFeeMaster dto, int userId)
        {
            using var conn = _dbFactory.CreateConnection();
            var result = await conn.QueryFirstAsync<dynamic>(
                "sp_Admin_ClassFeeMaster_Upsert",
                new
                {
                    p_ClassFeeId = dto.ClassFeeId,
                    p_OrganizationId = dto.OrganizationId,
                    p_ClassId = dto.ClassId,
                    p_Section = dto.Section,
                    p_SectionId = dto.SectionId,
                    p_TermId = dto.TermId,
                    p_SessionId = dto.SessionId,
                    p_FeeTypeId = dto.FeeTypeId,
                    p_Amount = dto.Amount,
                    p_DueDate = dto.DueDate,
                    p_IsActive = dto.IsActive,
                    p_ModifiedBy = userId
                },
                commandType: CommandType.StoredProcedure
            );
            int id = result.ClassFeeId == null ? 0 : (int)result.ClassFeeId;
            int success = result.SuccessFlag == null ? (id > 0 ? 1 : 0) : Convert.ToInt32(result.SuccessFlag);
            string msg = result.Message?.ToString() ?? (success == 1 ? "Saved" : "Failed");
            return (id, success == 1, msg);
        }

        public async Task<bool> DeleteClassFeeAsync(int orgId, int classFeeId, int userId)
        {
            using var conn = _dbFactory.CreateConnection();
            var result = await conn.QueryFirstOrDefaultAsync<dynamic>(
                "sp_Admin_ClassFeeMaster_Delete",
                new
                {
                    p_OrganizationId = orgId,
                    p_ClassFeeId = classFeeId,
                    p_ModifiedBy = userId
                },
                commandType: CommandType.StoredProcedure);
            return result != null;
        }

        //-------------------------------------------------
        // 2️⃣ CONCESSIONS
        //-------------------------------------------------
        public async Task<IEnumerable<dynamic>> GetConcessionsAsync(int orgId, int studentId)
        {
            using var conn = _dbFactory.CreateConnection();
            return await conn.QueryAsync(
                "sp_Admin_Concessions_GetByStudent",
                new { p_OrganizationId = orgId, p_StudentId = studentId },
                commandType: CommandType.StoredProcedure);
        }

        public async Task<int> UpsertConcessionAsync(int orgId, ConcessionUpsert dto, int userId)
        {
            using var conn = _dbFactory.CreateConnection();
            var result = await conn.QueryFirstAsync<dynamic>(
                "sp_Admin_Concessions_Upsert",
                new
                {
                    p_OrganizationId = orgId,
                    p_ConcessionId = dto.ConcessionId,
                    p_StudentId = dto.StudentId,
                    p_FeeTypeId = dto.FeeTypeId,
                    p_DiscountType = dto.DiscountType,
                    p_DiscountValue = dto.DiscountValue,
                    p_Remark = dto.Remark,
                    p_IsActive = dto.IsActive,
                    p_ModifiedBy = userId
                },
                commandType: CommandType.StoredProcedure);
            return (int)result.ConcessionId;
        }

        //-------------------------------------------------
        // 3️⃣ INVOICES - Generate + Get
        //-------------------------------------------------
        public async Task<(int InvoiceId, string InvoiceNo)> GenerateInvoiceAsync(int orgId, InvoiceGenerateRequest req, int userId)
        {
            using var conn = _dbFactory.CreateConnection();
            var result = await conn.QueryFirstAsync<dynamic>(
                "sp_Admin_Invoices_GenerateForStudent",
                new
                {
                    p_OrganizationId = orgId,
                    p_StudentId = req.StudentId,
                    p_ClassId = req.ClassId,
                    p_TermId = req.TermId,
                    p_SessionId = req.SessionId,
                    p_InvoiceDate = req.InvoiceDate,
                    p_DueDate = req.DueDate,
                    p_Notes = req.Notes,
                    p_CreatedBy = userId
                },
                commandType: CommandType.StoredProcedure);
            return ((int)result.InvoiceId, (string)result.InvoiceNo);
        }

        public async Task<(IEnumerable<dynamic> Invoices, int TotalCount)> GetInvoicesAsync(
            int orgId, int page, int size, string? search,
            int? classId = null, string? status = null,
            DateTime? fromDate = null, DateTime? toDate = null,
            int? termId = null, int? sessionId = null)
        {
            using var conn = _dbFactory.CreateConnection();
            using var multi = await conn.QueryMultipleAsync(
                "sp_Admin_Invoices_GetAll",
                new
                {
                    p_OrganizationId = orgId,
                    p_PageNumber = page,
                    p_PageSize = size,
                    p_Search = search,
                    p_ClassId = classId,
                    p_Status = status,
                    p_FromDate = fromDate?.Date,
                    p_ToDate = toDate?.Date,
                    p_TermId = termId,
                    p_SessionId = sessionId
                },
                commandType: CommandType.StoredProcedure);

            var invoices = (await multi.ReadAsync<dynamic>()).ToList();
            var totalCount = (await multi.ReadFirstOrDefaultAsync<int?>()) ?? invoices.Count;
            return (invoices, totalCount);
        }

        public async Task<IEnumerable<dynamic>> GetInvoicesByUserIdAsync(int orgId, int userId)
        {
            using var conn = _dbFactory.CreateConnection();
            return await conn.QueryAsync(
                "sp_Admin_Invoices_ByUserId",
                new
                {
                    p_OrganizationId = orgId,
                    p_UserId = userId

                },
                commandType: CommandType.StoredProcedure);
        }

        public async Task<(InvoiceHeaderDto header, IEnumerable<InvoiceItemDto> items, IEnumerable<PaymentAllocationDto> allocations)>
    GetInvoiceByIdAsync(int orgId, int invoiceId)
        {
            using var conn = _dbFactory.CreateConnection();
            using var multi = await conn.QueryMultipleAsync(
                "sp_Admin_Invoices_GetById",
                new { p_OrganizationId = orgId, p_InvoiceId = invoiceId },
                commandType: CommandType.StoredProcedure);

            var header = await multi.ReadFirstOrDefaultAsync<InvoiceHeaderDto>();
            var items = await multi.ReadAsync<InvoiceItemDto>();
            var allocations = await multi.ReadAsync<PaymentAllocationDto>();

            return (header, items, allocations);
        }

        //-------------------------------------------------
        // 4️⃣ PAYMENTS
        //-------------------------------------------------
        public async Task<(bool Success, string Message, int PaymentId, string ReceiptNo, decimal Allocated, decimal Unallocated)> CreatePaymentAsync(int orgId, PaymentCreateRequest req, int userId)
        {
            using var conn = _dbFactory.CreateConnection();
            var result = await conn.QueryFirstAsync<dynamic>(
                "sp_Admin_Payments_Collect",
                new
                {
                    p_OrganizationId = orgId,
                    p_StudentId = req.StudentId,
                    p_SessionId = req.SessionId,
                    p_PaymentTarget = string.IsNullOrWhiteSpace(req.PaymentTarget) ? "TermFee" : req.PaymentTarget,
                    p_PaymentDate = req.PaymentDate,
                    p_PaymentMode = req.PaymentMode,
                    p_ReferenceNo = req.ReferenceNo,
                    p_Notes = req.Notes,
                    p_TotalPaidAmount = req.TotalPaidAmount,
                    p_CreatedBy = userId
                },
                commandType: CommandType.StoredProcedure);

            int success = result.SuccessFlag == null ? 0 : Convert.ToInt32(result.SuccessFlag);
            return (
                success == 1,
                result.Message?.ToString() ?? "",
                result.PaymentId == null ? 0 : (int)result.PaymentId,
                result.ReceiptNo?.ToString() ?? "",
                result.Allocated == null ? 0 : (decimal)result.Allocated,
                result.Unallocated == null ? 0 : (decimal)result.Unallocated
            );
        }

        public async Task<(dynamic? Header, IEnumerable<dynamic> Allocations)> GetPaymentByIdAsync(int orgId, int paymentId)
        {
            using var conn = _dbFactory.CreateConnection();
            using var multi = await conn.QueryMultipleAsync(
                "sp_Admin_Payment_GetById",
                new { p_OrganizationId = orgId, p_PaymentId = paymentId },
                commandType: CommandType.StoredProcedure);
            var header = await multi.ReadFirstOrDefaultAsync();
            var allocations = (await multi.ReadAsync()).ToList();
            return (header, allocations);
        }

        public async Task<IEnumerable<dynamic>> GetStudentFeeBalancesAsync(int orgId, int classId, int? sectionId, int? sessionId, string? search)
        {
            using var conn = _dbFactory.CreateConnection();
            return await conn.QueryAsync(
                "sp_Admin_StudentFeeBalances_ByClass",
                new
                {
                    p_OrganizationId = orgId,
                    p_ClassId = classId,
                    p_SectionId = sectionId,
                    p_SessionId = sessionId,
                    p_Search = search
                },
                commandType: CommandType.StoredProcedure);
        }

        public async Task<(int OldFeeId, bool Success, string Message)> UpsertOldFeeAsync(int orgId, StudentOldFeeUpsert dto, int userId)
        {
            using var conn = _dbFactory.CreateConnection();
            var result = await conn.QueryFirstAsync<dynamic>(
                "sp_Admin_StudentOldFee_Upsert",
                new
                {
                    p_OldFeeId = dto.OldFeeId,
                    p_OrganizationId = orgId,
                    p_StudentId = dto.StudentId,
                    p_SessionId = dto.SessionId,
                    p_TotalAmount = dto.TotalAmount,
                    p_Notes = dto.Notes,
                    p_IsActive = dto.IsActive,
                    p_ModifiedBy = userId
                },
                commandType: CommandType.StoredProcedure);
            int id = result.OldFeeId == null ? 0 : (int)result.OldFeeId;
            int success = result.SuccessFlag == null ? 0 : Convert.ToInt32(result.SuccessFlag);
            return (id, success == 1, result.Message?.ToString() ?? "");
        }

        public async Task<dynamic?> GetOldFeeByStudentAsync(int orgId, int studentId)
        {
            using var conn = _dbFactory.CreateConnection();
            return await conn.QueryFirstOrDefaultAsync(
                "sp_Admin_StudentOldFee_GetByStudent",
                new { p_OrganizationId = orgId, p_StudentId = studentId },
                commandType: CommandType.StoredProcedure);
        }

        public async Task<(bool Success, string Message)> DeleteOldFeeAsync(int orgId, int oldFeeId, int userId)
        {
            using var conn = _dbFactory.CreateConnection();
            var result = await conn.QueryFirstAsync<dynamic>(
                "sp_Admin_StudentOldFee_Delete",
                new { p_OrganizationId = orgId, p_OldFeeId = oldFeeId, p_ModifiedBy = userId },
                commandType: CommandType.StoredProcedure);
            int success = result.SuccessFlag == null ? 0 : Convert.ToInt32(result.SuccessFlag);
            return (success == 1, result.Message?.ToString() ?? "");
        }

        public async Task<(int ConcessionId, bool Success, string Message)> UpsertStudentConcessionAsync(int orgId, StudentConcessionUpsert dto, int userId)
        {
            using var conn = _dbFactory.CreateConnection();
            var result = await conn.QueryFirstAsync<dynamic>(
                "sp_Admin_StudentConcession_Upsert",
                new
                {
                    p_ConcessionId = dto.ConcessionId,
                    p_OrganizationId = orgId,
                    p_StudentId = dto.StudentId,
                    p_SessionId = dto.SessionId,
                    p_Amount = dto.Amount,
                    p_Notes = dto.Notes,
                    p_IsActive = dto.IsActive,
                    p_ModifiedBy = userId
                },
                commandType: CommandType.StoredProcedure);
            int id = result.ConcessionId == null ? 0 : (int)result.ConcessionId;
            int success = result.SuccessFlag == null ? 0 : Convert.ToInt32(result.SuccessFlag);
            return (id, success == 1, result.Message?.ToString() ?? "");
        }

        public async Task<dynamic?> GetStudentConcessionByStudentAsync(int orgId, int studentId)
        {
            using var conn = _dbFactory.CreateConnection();
            return await conn.QueryFirstOrDefaultAsync(
                "sp_Admin_StudentConcession_GetByStudent",
                new { p_OrganizationId = orgId, p_StudentId = studentId },
                commandType: CommandType.StoredProcedure);
        }

        public async Task<(bool Success, string Message)> DeleteStudentConcessionAsync(int orgId, int concessionId, int userId)
        {
            using var conn = _dbFactory.CreateConnection();
            var result = await conn.QueryFirstAsync<dynamic>(
                "sp_Admin_StudentConcession_Delete",
                new { p_OrganizationId = orgId, p_ConcessionId = concessionId, p_ModifiedBy = userId },
                commandType: CommandType.StoredProcedure);
            int success = result.SuccessFlag == null ? 0 : Convert.ToInt32(result.SuccessFlag);
            return (success == 1, result.Message?.ToString() ?? "");
        }

        public async Task<(IEnumerable<dynamic> Payments, int TotalCount)> GetPaymentsAsync(
            int orgId, int page, int size, string? search,
            int? classId = null, int? sectionId = null, string? paymentMode = null,
            DateTime? fromDate = null, DateTime? toDate = null)
        {
            using var conn = _dbFactory.CreateConnection();
            using var multi = await conn.QueryMultipleAsync(
                "sp_Admin_Payments_GetAll",
                new
                {
                    p_OrganizationId = orgId,
                    p_PageNumber = page,
                    p_PageSize = size,
                    p_Search = search,
                    p_ClassId = classId,
                    p_SectionId = sectionId,
                    p_PaymentMode = paymentMode,
                    p_FromDate = fromDate?.Date,
                    p_ToDate = toDate?.Date
                },
                commandType: CommandType.StoredProcedure);

            var payments = (await multi.ReadAsync<dynamic>()).ToList();
            var totalCount = (await multi.ReadFirstOrDefaultAsync<int?>()) ?? payments.Count;
            return (payments, totalCount);
        }

        public async Task<PaginatedResponse<StudentListModel>> GetAllStudentsAsync(
    int organizationId, int pageNumber, int pageSize, string search, int isDropdown = 0)
        {
            using var conn = _dbFactory.CreateConnection();
            var parameters = new DynamicParameters();

            parameters.Add("p_OrganizationId", organizationId);
            parameters.Add("p_PageNumber", pageNumber);
            parameters.Add("p_PageSize", pageSize);
            parameters.Add("p_Search", search);
            parameters.Add("p_IsDropdown", isDropdown);

            using var multi = await conn.QueryMultipleAsync(
                "sp_Admin_Students_GetAll",
                parameters,
                commandType: CommandType.StoredProcedure);

            var students = (await multi.ReadAsync<StudentListModel>()).ToList();
            int totalRecords;

            // ✅ HANDLE DROPDOWN MODE
            if (isDropdown == 1)
            {
                totalRecords = students.Count;
            }
            else
            {
                totalRecords = (await multi.ReadAsync<int>()).FirstOrDefault();
            }

            return PaginatedResponse<StudentListModel>.Create(
                students,
                totalRecords,
                pageNumber,
                pageSize
            );
        }

    }
}

