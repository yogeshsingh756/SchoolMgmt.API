using SchoolMgmt.Application.Interfaces;
using SchoolMgmt.Domain.Entities;
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

        public async Task<IEnumerable<FeeTypeEntity>> GetFeeTypesAsync(int organizationId)
            => await _repository.GetFeeTypesAsync(organizationId);

        public async Task<IEnumerable<AcademicTermEntity>> GetTermsAsync(int organizationId)
            => await _repository.GetTermsAsync(organizationId);

        public async Task<IEnumerable<AcademicSessionEntity>> GetSessionsAsync(int organizationId)
            => await _repository.GetSessionsAsync(organizationId);

        public async Task<bool> UpsertFeeTypeAsync(FeeTypeEntity entity, int modifiedBy)
            => await _repository.UpsertFeeTypeAsync(entity, modifiedBy);

        public async Task<bool> UpsertTermAsync(AcademicTermEntity entity, int modifiedBy)
            => await _repository.UpsertTermAsync(entity, modifiedBy);

        public async Task<bool> UpsertSessionAsync(AcademicSessionEntity entity, int modifiedBy)
            => await _repository.UpsertSessionAsync(entity, modifiedBy);
    }
}
