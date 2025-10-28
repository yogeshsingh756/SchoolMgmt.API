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
    public class ClassSubjectRepository
    {
        private readonly IDbConnectionFactory _dbFactory;

        public ClassSubjectRepository(IDbConnectionFactory dbFactory)
        {
            _dbFactory = dbFactory;
        }

        public async Task<int> CreateAsync(ClassSubjectEntity entity)
        {
            using var conn = _dbFactory.CreateConnection();
            var result = await conn.QueryFirstOrDefaultAsync<dynamic>(
                "sp_Admin_ClassSubjects_Create",
                new
                {
                    p_OrganizationId = entity.OrganizationId,
                    p_ClassId = entity.ClassId,
                    p_SubjectId = entity.SubjectId,
                    p_CreatedBy = entity.CreatedBy
                },
                commandType: CommandType.StoredProcedure);
            return result != null ? Convert.ToInt32(result.ClassSubjectId) : 0;
        }

        public async Task<IEnumerable<dynamic>> GetByClassAsync(int organizationId, int classId)
        {
            using var conn = _dbFactory.CreateConnection();
            return await conn.QueryAsync<dynamic>(
                "sp_Admin_ClassSubjects_GetByClass",
                new { p_OrganizationId = organizationId, p_ClassId = classId },
                commandType: CommandType.StoredProcedure);
        }

        public async Task<bool> DeleteAsync(int organizationId, int classSubjectId, int modifiedBy)
        {
            using var conn = _dbFactory.CreateConnection();
            var result = await conn.ExecuteAsync(
                "sp_Admin_ClassSubjects_Delete",
                new { p_OrganizationId = organizationId, p_ClassSubjectId = classSubjectId, p_ModifiedBy = modifiedBy },
                commandType: CommandType.StoredProcedure);
            return result > 0;
        }
    }
}
