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
        Task<IEnumerable<FeeTypeEntity>> GetFeeTypesAsync(int organizationId);
        Task<IEnumerable<AcademicTermEntity>> GetTermsAsync(int organizationId);
        Task<IEnumerable<AcademicSessionEntity>> GetSessionsAsync(int organizationId);

        Task<bool> UpsertFeeTypeAsync(FeeTypeEntity entity, int modifiedBy);
        Task<bool> UpsertTermAsync(AcademicTermEntity entity, int modifiedBy);
        Task<bool> UpsertSessionAsync(AcademicSessionEntity entity, int modifiedBy);
    }
}
