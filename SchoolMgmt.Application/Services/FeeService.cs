using SchoolMgmt.Application.Interfaces;
using SchoolMgmt.Domain.Entities;
using SchoolMgmt.Infrastructure.Repositories;
using SchoolMgmt.Shared.Models.Fee;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Application.Services
{
    public class FeeService : IFeeService
    {
        private readonly FeeRepository _feeRepository;

        public FeeService(FeeRepository feeRepository)
        {
            _feeRepository = feeRepository;
        }

        public async Task<IEnumerable<FeeEntity>> GetAllFeesAsync(int organizationId)
        {
            return await _feeRepository.GetAllFeesAsync(organizationId);
        }

        public async Task<FeeEntity?> GetFeeByIdAsync(int feeId, int organizationId)
        {
            return await _feeRepository.GetFeeByIdAsync(feeId, organizationId);
        }

        public async Task<bool> UpsertFeeAsync(FeeDto dto, int modifiedBy)
        {
            var entity = new FeeEntity
            {
                FeeId = dto.FeeId,
                OrganizationId = dto.OrganizationId,
                ClassId = dto.ClassId,
                FeeType = dto.FeeType,
                Amount = dto.Amount,
                DueDate = dto.DueDate,
                Term = dto.Term,
                Session = dto.Session,
                Status = dto.Status
            };

            return await _feeRepository.UpsertFeeAsync(entity, modifiedBy);
        }

        public async Task<bool> DeleteFeeAsync(int feeId, int organizationId, int modifiedBy)
        {
            return await _feeRepository.DeleteFeeAsync(feeId, organizationId, modifiedBy);
        }
    }
}
