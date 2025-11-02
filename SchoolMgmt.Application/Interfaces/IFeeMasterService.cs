using SchoolMgmt.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Application.Interfaces
{
    public interface IFeeMasterService
    {
        // Fee Types
        Task<IEnumerable<FeeTypeEntity>> GetFeeTypesAsync(int organizationId);
        Task<FeeTypeEntity?> GetFeeTypeByIdAsync(int feeTypeId, int organizationId);
        Task<int> UpsertFeeTypeAsync(FeeTypeEntity entity, int modifiedBy);
        Task<bool> DeleteFeeTypeAsync(int feeTypeId, int organizationId, int modifiedBy);

        // Terms
        Task<IEnumerable<AcademicTermEntity>> GetTermsAsync(int organizationId);
        Task<AcademicTermEntity?> GetTermByIdAsync(int termId, int organizationId);
        Task<int> UpsertTermAsync(AcademicTermEntity entity, int modifiedBy);
        Task<bool> DeleteTermAsync(int termId, int organizationId, int modifiedBy);

        // Sessions
        Task<IEnumerable<AcademicSessionEntity>> GetSessionsAsync(int organizationId);
        Task<AcademicSessionEntity?> GetSessionByIdAsync(int sessionId, int organizationId);
        Task<int> UpsertSessionAsync(AcademicSessionEntity entity, int modifiedBy);
        Task<bool> DeleteSessionAsync(int sessionId, int organizationId, int modifiedBy);
    }
}
