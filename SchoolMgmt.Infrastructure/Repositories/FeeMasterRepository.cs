using Dapper;
using SchoolMgmt.Domain.Entities;
using SchoolMgmt.Shared.Interfaces;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Infrastructure.Repositories
{
    public class FeeMasterRepository
    {
        private readonly IDbConnectionFactory _dbFactory;

        public FeeMasterRepository(IDbConnectionFactory dbFactory)
        {
            _dbFactory = dbFactory;
        }

        // ---------- Fee Types ----------
        public async Task<IEnumerable<FeeTypeEntity>> GetFeeTypesAsync(int organizationId)
        {
            using var conn = _dbFactory.CreateConnection();
            return await conn.QueryAsync<FeeTypeEntity>(
                "sp_Admin_FeeTypes_GetAll",
                new { p_OrganizationId = organizationId },
                commandType: CommandType.StoredProcedure);
        }

        public async Task<FeeTypeEntity?> GetFeeTypeByIdAsync(int feeTypeId, int organizationId)
        {
            using var conn = _dbFactory.CreateConnection();
            return await conn.QueryFirstOrDefaultAsync<FeeTypeEntity>(
                "sp_Admin_FeeTypes_GetById",
                new { p_FeeTypeId = feeTypeId, p_OrganizationId = organizationId },
                commandType: CommandType.StoredProcedure);
        }

        public async Task<int> UpsertFeeTypeAsync(FeeTypeEntity entity, int modifiedBy)
        {
            using var conn = _dbFactory.CreateConnection();
            var result = await conn.QueryFirstAsync<dynamic>(
                "sp_Admin_FeeTypes_Upsert",
                new
                {
                    p_FeeTypeId = entity.FeeTypeId,
                    p_OrganizationId = entity.OrganizationId,
                    p_FeeTypeName = entity.FeeTypeName,
                    p_Description = entity.Description,
                    p_IsActive = entity.IsActive,
                    p_ModifiedBy = modifiedBy
                },
                commandType: CommandType.StoredProcedure);
            return (int)result.NewId;
        }

        public async Task<bool> DeleteFeeTypeAsync(int feeTypeId, int organizationId, int modifiedBy)
        {
            using var conn = _dbFactory.CreateConnection();
            await conn.ExecuteAsync(
                "sp_Admin_FeeTypes_Delete",
                new { p_FeeTypeId = feeTypeId, p_OrganizationId = organizationId, p_ModifiedBy = modifiedBy },
                commandType: CommandType.StoredProcedure);
            return true;
        }

        // ---------- Terms ----------
        public async Task<IEnumerable<AcademicTermEntity>> GetTermsAsync(int organizationId)
        {
            using var conn = _dbFactory.CreateConnection();
            return await conn.QueryAsync<AcademicTermEntity>(
                "sp_Admin_Terms_GetAll",
                new { p_OrganizationId = organizationId },
                commandType: CommandType.StoredProcedure);
        }

        public async Task<AcademicTermEntity?> GetTermByIdAsync(int termId, int organizationId)
        {
            using var conn = _dbFactory.CreateConnection();
            return await conn.QueryFirstOrDefaultAsync<AcademicTermEntity>(
                "sp_Admin_Terms_GetById",
                new { p_TermId = termId, p_OrganizationId = organizationId },
                commandType: CommandType.StoredProcedure);
        }

        public async Task<int> UpsertTermAsync(AcademicTermEntity entity, int modifiedBy)
        {
            using var conn = _dbFactory.CreateConnection();
            var result = await conn.QueryFirstAsync<dynamic>(
                "sp_Admin_Terms_Upsert",
                new
                {
                    p_TermId = entity.TermId,
                    p_OrganizationId = entity.OrganizationId,
                    p_TermName = entity.TermName,
                    p_StartMonth = entity.StartMonth,
                    p_EndMonth = entity.EndMonth,
                    p_IsActive = entity.IsActive,
                    p_ModifiedBy = modifiedBy
                },
                commandType: CommandType.StoredProcedure);
            return (int)result.NewId;
        }

        public async Task<bool> DeleteTermAsync(int termId, int organizationId, int modifiedBy)
        {
            using var conn = _dbFactory.CreateConnection();
            await conn.ExecuteAsync(
                "sp_Admin_Terms_Delete",
                new { p_TermId = termId, p_OrganizationId = organizationId, p_ModifiedBy = modifiedBy },
                commandType: CommandType.StoredProcedure);
            return true;
        }

        // ---------- Sessions ----------
        public async Task<IEnumerable<AcademicSessionEntity>> GetSessionsAsync(int organizationId)
        {
            using var conn = _dbFactory.CreateConnection();
            return await conn.QueryAsync<AcademicSessionEntity>(
                "sp_Admin_Sessions_GetAll",
                new { p_OrganizationId = organizationId },
                commandType: CommandType.StoredProcedure);
        }

        public async Task<AcademicSessionEntity?> GetSessionByIdAsync(int sessionId, int organizationId)
        {
            using var conn = _dbFactory.CreateConnection();
            return await conn.QueryFirstOrDefaultAsync<AcademicSessionEntity>(
                "sp_Admin_Sessions_GetById",
                new { p_SessionId = sessionId, p_OrganizationId = organizationId },
                commandType: CommandType.StoredProcedure);
        }

        public async Task<int> UpsertSessionAsync(AcademicSessionEntity entity, int modifiedBy)
        {
            using var conn = _dbFactory.CreateConnection();
            var result = await conn.QueryFirstAsync<dynamic>(
                "sp_Admin_Sessions_Upsert",
                new
                {
                    p_SessionId = entity.SessionId,
                    p_OrganizationId = entity.OrganizationId,
                    p_SessionName = entity.SessionName,
                    p_StartDate = entity.StartDate,
                    p_EndDate = entity.EndDate,
                    p_IsActive = entity.IsActive,
                    p_ModifiedBy = modifiedBy
                },
                commandType: CommandType.StoredProcedure);
            return (int)result.NewId;
        }

        public async Task<bool> DeleteSessionAsync(int sessionId, int organizationId, int modifiedBy)
        {
            using var conn = _dbFactory.CreateConnection();
            await conn.ExecuteAsync(
                "sp_Admin_Sessions_Delete",
                new { p_SessionId = sessionId, p_OrganizationId = organizationId, p_ModifiedBy = modifiedBy },
                commandType: CommandType.StoredProcedure);
            return true;
        }
    }
}
