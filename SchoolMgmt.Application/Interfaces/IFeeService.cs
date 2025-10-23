using SchoolMgmt.Domain.Entities;
using SchoolMgmt.Shared.Models.Fee;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Application.Interfaces
{
    public interface IFeeService
    {
        Task<IEnumerable<FeeEntity>> GetAllFeesAsync(int organizationId);
        Task<FeeEntity?> GetFeeByIdAsync(int feeId, int organizationId);
        Task<bool> UpsertFeeAsync(FeeDto dto, int modifiedBy);
        Task<bool> DeleteFeeAsync(int feeId, int organizationId, int modifiedBy);
    }
}
