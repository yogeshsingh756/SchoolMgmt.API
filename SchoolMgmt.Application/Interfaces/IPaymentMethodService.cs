using SchoolMgmt.Application.DTOs.PaymentMethod;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Application.Interfaces
{
    public interface IPaymentMethodService
    {
        Task<bool> UpsertMethodAsync(PaymentMethodUpsertDto entity, int userId);
        Task<IEnumerable<PaymentMethodResponseDto>> GetMethodsAsync(int orgId);
        Task<PaymentMethodResponseDto> GetByTypeAsync(int orgId, string type);
    }
}
