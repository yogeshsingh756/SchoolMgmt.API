using SchoolMgmt.Application.Interfaces;
using SchoolMgmt.Domain.Entities;
using SchoolMgmt.Infrastructure.Repositories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Application.Services
{
    public class FeeMasterService : IFeeMasterService
    {
        private readonly FeeMasterRepository _repository;

        public FeeMasterService(FeeMasterRepository repository)
        {
            _repository = repository;
        }

        // Fee Types
        public Task<IEnumerable<FeeTypeEntity>> GetFeeTypesAsync(int organizationId)
            => _repository.GetFeeTypesAsync(organizationId);
        public Task<FeeTypeEntity?> GetFeeTypeByIdAsync(int feeTypeId, int organizationId)
            => _repository.GetFeeTypeByIdAsync(feeTypeId, organizationId);
        public Task<int> UpsertFeeTypeAsync(FeeTypeEntity entity, int modifiedBy)
            => _repository.UpsertFeeTypeAsync(entity, modifiedBy);
        public Task<bool> DeleteFeeTypeAsync(int feeTypeId, int organizationId, int modifiedBy)
            => _repository.DeleteFeeTypeAsync(feeTypeId, organizationId, modifiedBy);

        // Terms
        public Task<IEnumerable<AcademicTermEntity>> GetTermsAsync(int organizationId)
            => _repository.GetTermsAsync(organizationId);
        public Task<AcademicTermEntity?> GetTermByIdAsync(int termId, int organizationId)
            => _repository.GetTermByIdAsync(termId, organizationId);
        public Task<int> UpsertTermAsync(AcademicTermEntity entity, int modifiedBy)
            => _repository.UpsertTermAsync(entity, modifiedBy);
        public Task<bool> DeleteTermAsync(int termId, int organizationId, int modifiedBy)
            => _repository.DeleteTermAsync(termId, organizationId, modifiedBy);

        // Sessions
        public Task<IEnumerable<AcademicSessionEntity>> GetSessionsAsync(int organizationId)
            => _repository.GetSessionsAsync(organizationId);
        public Task<AcademicSessionEntity?> GetSessionByIdAsync(int sessionId, int organizationId)
            => _repository.GetSessionByIdAsync(sessionId, organizationId);
        public Task<int> UpsertSessionAsync(AcademicSessionEntity entity, int modifiedBy)
            => _repository.UpsertSessionAsync(entity, modifiedBy);
        public Task<bool> DeleteSessionAsync(int sessionId, int organizationId, int modifiedBy)
            => _repository.DeleteSessionAsync(sessionId, organizationId, modifiedBy);
    }
}
