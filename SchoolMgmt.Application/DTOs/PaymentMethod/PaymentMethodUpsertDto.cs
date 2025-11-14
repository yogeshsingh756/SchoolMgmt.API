using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Application.DTOs.PaymentMethod
{
    public class PaymentMethodUpsertDto
    {
        public int PaymentMethodId { get; set; }
        public string MethodType { get; set; }  // QR or UPI
        public string UpiId { get; set; }
        public string QrImageUrl { get; set; }
        public int OrganizationId { get; set; } = 0;
    }
}
