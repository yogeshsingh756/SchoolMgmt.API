using Dapper;
using SchoolMgmt.Domain.Entities;
using SchoolMgmt.Shared.Interfaces;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace SchoolMgmt.Infrastructure.Repositories
{
    public class PaymentMethodRepository
    {
        private readonly IDbConnectionFactory _dbFactory;

        public PaymentMethodRepository(IDbConnectionFactory dbFactory)
        {
            _dbFactory = dbFactory;
        }

        public async Task<bool> UpsertPaymentMethodAsync(PaymentMethodEntity entity, int createdBy)
        {
            using var conn = _dbFactory.CreateConnection();

            string sql = @"
        INSERT INTO OrganizationPaymentMethods
        (PaymentMethodId, OrganizationId, MethodType, UpiId, QrImageUrl, CreatedBy)
        VALUES
        (@PaymentMethodId, @OrganizationId, @MethodType, @UpiId, @QrImageUrl, @CreatedBy)
        ON DUPLICATE KEY UPDATE
            MethodType = VALUES(MethodType),
            UpiId = VALUES(UpiId),
            QrImageUrl = VALUES(QrImageUrl),
            ModifiedBy = @CreatedBy,
            ModifiedOn = NOW();
    ";

            await conn.ExecuteAsync(sql, new
            {
                entity.PaymentMethodId,    // ⭐ NEW
                entity.OrganizationId,
                entity.MethodType,
                entity.UpiId,
                entity.QrImageUrl,
                CreatedBy = createdBy
            });

            return true;
        }

        public async Task<IEnumerable<PaymentMethodEntity>> GetPaymentMethodsAsync(int orgId)
        {
            using var conn = _dbFactory.CreateConnection();
            return await conn.QueryAsync<PaymentMethodEntity>(
                @"SELECT * FROM OrganizationPaymentMethods
                  WHERE OrganizationId=@org AND IsActive=1",
                new { org = orgId });
        }

        public async Task<PaymentMethodEntity> GetPaymentMethodByTypeAsync(int orgId, string type)
        {
            using var conn = _dbFactory.CreateConnection();
            return await conn.QueryFirstOrDefaultAsync<PaymentMethodEntity>(
                @"SELECT * 
                  FROM OrganizationPaymentMethods
                  WHERE OrganizationId=@org AND MethodType=@type AND IsActive=1",
                new { org = orgId, type });
        }
    }
}
