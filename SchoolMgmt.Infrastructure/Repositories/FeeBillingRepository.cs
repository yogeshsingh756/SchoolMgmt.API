using Dapper;
using SchoolMgmt.Shared.Interfaces;
using SchoolMgmt.Shared.Models.Fee;
using System;
using System.Collections.Generic;
using System.Data;
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

        public async Task<int> UpsertClassFeeAsync(ClassFeeMaster dto, int userId)
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
            return (int)result.ClassFeeId;
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

        public async Task<IEnumerable<dynamic>> GetInvoicesAsync(int orgId, int page, int size, string search)
        {
            using var conn = _dbFactory.CreateConnection();
            return await conn.QueryAsync(
                "sp_Admin_Invoices_GetAll",
                new
                {
                    p_OrganizationId = orgId,
                    p_PageNumber = page,
                    p_PageSize = size,
                    p_Search = search
                },
                commandType: CommandType.StoredProcedure);
        }

        public async Task<(dynamic header, IEnumerable<dynamic> items, IEnumerable<dynamic> allocations)> GetInvoiceByIdAsync(int orgId, int invoiceId)
        {
            using var conn = _dbFactory.CreateConnection();
            using var multi = await conn.QueryMultipleAsync(
                "sp_Admin_Invoices_GetById",
                new { p_OrganizationId = orgId, p_InvoiceId = invoiceId },
                commandType: CommandType.StoredProcedure);

            var header = await multi.ReadFirstOrDefaultAsync();
            var items = await multi.ReadAsync();
            var allocations = await multi.ReadAsync();

            return (header, items, allocations);
        }

        //-------------------------------------------------
        // 4️⃣ PAYMENTS
        //-------------------------------------------------
        public async Task<(int PaymentId, string ReceiptNo, decimal Allocated, decimal Unallocated)> CreatePaymentAsync(int orgId, PaymentCreateRequest req, int userId)
        {
            using var conn = _dbFactory.CreateConnection();
            var result = await conn.QueryFirstAsync<dynamic>(
                "sp_Admin_Payments_CreateAndAllocate",
                new
                {
                    p_OrganizationId = orgId,
                    p_StudentId = req.StudentId,
                    p_PaymentDate = req.PaymentDate,
                    p_PaymentMode = req.PaymentMode,
                    p_ReferenceNo = req.ReferenceNo,
                    p_Notes = req.Notes,
                    p_TotalPaidAmount = req.TotalPaidAmount,
                    p_CreatedBy = userId
                },
                commandType: CommandType.StoredProcedure);

            return (
                (int)result.PaymentId,
                (string)result.ReceiptNo,
                (decimal)result.Allocated,
                (decimal)result.Unallocated
            );
        }

        public async Task<IEnumerable<dynamic>> GetPaymentsAsync(int orgId, int page, int size, string search)
        {
            using var conn = _dbFactory.CreateConnection();
            return await conn.QueryAsync(
                "sp_Admin_Payments_GetAll",
                new
                {
                    p_OrganizationId = orgId,
                    p_PageNumber = page,
                    p_PageSize = size,
                    p_Search = search
                },
                commandType: CommandType.StoredProcedure);
        }
    }
}
