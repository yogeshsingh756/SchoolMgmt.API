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
    public class FeeRepository
    {
        private readonly IDbConnectionFactory _dbFactory;

        public FeeRepository(IDbConnectionFactory dbFactory)
        {
            _dbFactory = dbFactory;
        }

        public async Task<IEnumerable<FeeEntity>> GetAllFeesAsync(int organizationId)
        {
            using var conn = _dbFactory.CreateConnection();
            return await conn.QueryAsync<FeeEntity>(
                "sp_Fees_GetAllByOrganization",
                new { p_OrganizationId = organizationId },
                commandType: CommandType.StoredProcedure);
        }

        public async Task<FeeEntity?> GetFeeByIdAsync(int feeId, int organizationId)
        {
            using var conn = _dbFactory.CreateConnection();
            return await conn.QueryFirstOrDefaultAsync<FeeEntity>(
                "sp_Fees_GetById",
                new { p_FeeId = feeId, p_OrganizationId = organizationId },
                commandType: CommandType.StoredProcedure);
        }

        public async Task<bool> UpsertFeeAsync(FeeEntity fee, int modifiedBy)
        {
            using var conn = _dbFactory.CreateConnection();
            await conn.ExecuteAsync(
                "sp_Fees_Upsert",
                new
                {
                    p_FeeId = fee.FeeId,
                    p_OrganizationId = fee.OrganizationId,
                    p_ClassId = fee.ClassId,
                    p_FeeType = fee.FeeType,
                    p_Amount = fee.Amount,
                    p_DueDate = fee.DueDate,
                    p_Term = fee.Term,
                    p_Session = fee.Session,
                    p_Status = fee.Status,
                    p_ModifiedBy = modifiedBy
                },
                commandType: CommandType.StoredProcedure);
            return true;
        }

        public async Task<bool> DeleteFeeAsync(int feeId, int organizationId, int modifiedBy)
        {
            using var conn = _dbFactory.CreateConnection();
            await conn.ExecuteAsync(
                "sp_Fees_Delete",
                new { p_FeeId = feeId, p_OrganizationId = organizationId, p_ModifiedBy = modifiedBy },
                commandType: CommandType.StoredProcedure);
            return true;
        }
    }
}
