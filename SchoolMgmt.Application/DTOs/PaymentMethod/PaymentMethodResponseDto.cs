using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Application.DTOs.PaymentMethod
{
    public class PaymentMethodResponseDto
    {
        public int PaymentMethodId { get; set; }
        public string MethodType { get; set; }
        public string UpiId { get; set; }
        public string QrImageUrl { get; set; }
        public bool IsActive { get; set; }
    }
}
