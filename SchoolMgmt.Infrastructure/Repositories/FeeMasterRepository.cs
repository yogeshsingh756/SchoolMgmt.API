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

        public async Task<IEnumerable<FeeTypeEntity>> GetFeeTypesAsync(int organizationId)
        {
            using var conn = _dbFactory.CreateConnection();
            return await conn.QueryAsync<FeeTypeEntity>(
                "sp_Admin_FeeTypes_GetAll",
                new { p_OrganizationId = organizationId },
                commandType: CommandType.StoredProcedure
            );
        }

        public async Task<IEnumerable<AcademicTermEntity>> GetTermsAsync(int organizationId)
        {
            using var conn = _dbFactory.CreateConnection();
            return await conn.QueryAsync<AcademicTermEntity>(
                "sp_Admin_Terms_GetAll",
                new { p_OrganizationId = organizationId },
                commandType: CommandType.StoredProcedure
            );
        }

        public async Task<IEnumerable<AcademicSessionEntity>> GetSessionsAsync(int organizationId)
        {
            using var conn = _dbFactory.CreateConnection();
            return await conn.QueryAsync<AcademicSessionEntity>(
                "sp_Admin_Sessions_GetAll",
                new { p_OrganizationId = organizationId },
                commandType: CommandType.StoredProcedure
            );
        }

        public async Task<bool> UpsertFeeTypeAsync(FeeTypeEntity entity, int modifiedBy)
        {
            using var conn = _dbFactory.CreateConnection();
            await conn.ExecuteAsync(
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
                commandType: CommandType.StoredProcedure
            );
            return true;
        }

        public async Task<bool> UpsertTermAsync(AcademicTermEntity entity, int modifiedBy)
        {
            using var conn = _dbFactory.CreateConnection();
            await conn.ExecuteAsync(
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
                commandType: CommandType.StoredProcedure
            );
            return true;
        }

        public async Task<bool> UpsertSessionAsync(AcademicSessionEntity entity, int modifiedBy)
        {
            using var conn = _dbFactory.CreateConnection();
            await conn.ExecuteAsync(
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
                commandType: CommandType.StoredProcedure
            );
            return true;
        }
    }
}
