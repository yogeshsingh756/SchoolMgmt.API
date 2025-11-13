using SchoolMgmt.Application.DTOs.PaymentMethod;
using SchoolMgmt.Application.Interfaces;
using SchoolMgmt.Domain.Entities;
using SchoolMgmt.Infrastructure.Repositories;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace SchoolMgmt.Application.Services
{
    public class PaymentMethodService : IPaymentMethodService
    {
        private readonly PaymentMethodRepository _repository;

        public PaymentMethodService(PaymentMethodRepository repository)
        {
            _repository = repository;
        }

        public async Task<bool> UpsertMethodAsync(PaymentMethodUpsertDto dto, int userId)
        {
            var entity = new PaymentMethodEntity
            {
                OrganizationId = dto.OrganizationId,
                MethodType = dto.MethodType,
                UpiId = dto.UpiId,
                QrImageUrl = dto.QrImageUrl
            };

            return await _repository.UpsertPaymentMethodAsync(entity, userId);
        }

        public async Task<IEnumerable<PaymentMethodResponseDto>> GetMethodsAsync(int orgId)
        {
            var data = await _repository.GetPaymentMethodsAsync(orgId);

            return data.Select(x => new PaymentMethodResponseDto
            {
                PaymentMethodId = x.PaymentMethodId,
                MethodType = x.MethodType,
                UpiId = x.UpiId,
                QrImageUrl = x.QrImageUrl,
                IsActive = x.IsActive
            });
        }

        public async Task<PaymentMethodResponseDto> GetByTypeAsync(int orgId, string type)
        {
            var x = await _repository.GetPaymentMethodByTypeAsync(orgId, type);
            if (x == null) return null;

            return new PaymentMethodResponseDto
            {
                PaymentMethodId = x.PaymentMethodId,
                MethodType = x.MethodType,
                UpiId = x.UpiId,
                QrImageUrl = x.QrImageUrl,
                IsActive = x.IsActive
            };
        }
    }
}
