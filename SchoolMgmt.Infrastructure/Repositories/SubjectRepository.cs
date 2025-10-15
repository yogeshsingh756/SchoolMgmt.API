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
    public class SubjectRepository
    {
        private readonly IDbConnectionFactory _dbFactory;

        public SubjectRepository(IDbConnectionFactory dbFactory)
        {
            _dbFactory = dbFactory;
        }

        public async Task<(IEnumerable<SubjectEntity> Records, int TotalCount)> GetAllAsync(int organizationId, int pageNumber, int pageSize)
        {
            using var conn = _dbFactory.CreateConnection();
            using var multi = await conn.QueryMultipleAsync(
                "sp_Admin_Subjects_GetAll",
                new { p_OrganizationId = organizationId, p_PageNumber = pageNumber, p_PageSize = pageSize },
                commandType: CommandType.StoredProcedure);

            var records = await multi.ReadAsync<SubjectEntity>();
            var total = await multi.ReadFirstAsync<int>();

            return (records, total);
        }

        public async Task<int> CreateAsync(SubjectEntity subject)
        {
            using var conn = _dbFactory.CreateConnection();
            var result = await conn.QueryFirstOrDefaultAsync<dynamic>(
                "sp_Admin_Subjects_Create",
                new
                {
                    p_OrganizationId = subject.OrganizationId,
                    p_SubjectName = subject.SubjectName,
                    p_SubjectCode = subject.SubjectCode,
                    p_Description = subject.Description,
                    p_CreatedBy = subject.CreatedBy
                },
                commandType: CommandType.StoredProcedure);

            return result?.SubjectId ?? 0;
        }

        public async Task<SubjectEntity?> GetByIdAsync(int organizationId, int subjectId)
        {
            using var conn = _dbFactory.CreateConnection();
            return await conn.QueryFirstOrDefaultAsync<SubjectEntity>(
                "sp_Admin_Subjects_GetById",
                new { p_OrganizationId = organizationId, p_SubjectId = subjectId },
                commandType: CommandType.StoredProcedure);
        }

        public async Task<bool> UpdateAsync(SubjectEntity subject)
        {
            using var conn = _dbFactory.CreateConnection();
            var result = await conn.ExecuteAsync(
                "sp_Admin_Subjects_Update",
                new
                {
                    p_OrganizationId = subject.OrganizationId,
                    p_SubjectId = subject.SubjectId,
                    p_SubjectName = subject.SubjectName,
                    p_SubjectCode = subject.SubjectCode,
                    p_Description = subject.Description,
                    p_IsActive = subject.IsActive,
                    p_ModifiedBy = subject.ModifiedBy
                },
                commandType: CommandType.StoredProcedure);
            return result > 0;
        }

        public async Task<bool> DeleteAsync(int organizationId, int subjectId, int modifiedBy)
        {
            using var conn = _dbFactory.CreateConnection();
            var result = await conn.ExecuteAsync(
                "sp_Admin_Subjects_Delete",
                new { p_OrganizationId = organizationId, p_SubjectId = subjectId, p_ModifiedBy = modifiedBy },
                commandType: CommandType.StoredProcedure);
            return result > 0;
        }
    }
}
