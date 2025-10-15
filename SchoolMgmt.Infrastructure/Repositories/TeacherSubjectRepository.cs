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
    public class TeacherSubjectRepository
    {
        private readonly IDbConnectionFactory _dbFactory;

        public TeacherSubjectRepository(IDbConnectionFactory dbFactory)
        {
            _dbFactory = dbFactory;
        }

        public async Task<int> AssignAsync(TeacherSubjectEntity entity)
        {
            using var conn = _dbFactory.CreateConnection();
            var result = await conn.QueryFirstOrDefaultAsync<dynamic>(
                "sp_Admin_TeacherSubjects_Create",
                new
                {
                    p_OrganizationId = entity.OrganizationId,
                    p_TeacherId = entity.TeacherId,
                    p_ClassId = entity.ClassId,
                    p_SectionId = entity.SectionId,
                    p_SubjectId = entity.SubjectId,
                    p_IsPrimary = entity.IsPrimary,
                    p_CreatedBy = entity.CreatedBy
                },
                commandType: CommandType.StoredProcedure);
            return result?.TeacherSubjectId ?? 0;
        }

        public async Task<IEnumerable<TeacherSubjectEntity>> GetByTeacherAsync(int organizationId, int teacherId)
        {
            using var conn = _dbFactory.CreateConnection();
            return await conn.QueryAsync<TeacherSubjectEntity>(
                "sp_Admin_TeacherSubjects_GetByTeacher",
                new { p_OrganizationId = organizationId, p_TeacherId = teacherId },
                commandType: CommandType.StoredProcedure);
        }

        public async Task<bool> UnassignAsync(int organizationId, int teacherSubjectId, int modifiedBy)
        {
            using var conn = _dbFactory.CreateConnection();
            var result = await conn.ExecuteAsync(
                "sp_Admin_TeacherSubjects_Delete",
                new { p_OrganizationId = organizationId, p_TeacherSubjectId = teacherSubjectId, p_ModifiedBy = modifiedBy },
                commandType: CommandType.StoredProcedure);
            return result > 0;
        }
    }
}
