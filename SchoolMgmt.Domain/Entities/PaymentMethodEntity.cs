using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Domain.Entities
{
    public class PaymentMethodEntity
    {
        public int PaymentMethodId { get; set; }
        public int OrganizationId { get; set; }

        /// <summary>
        /// QR or UPI
        /// </summary>
        public string MethodType { get; set; } = string.Empty;

        public string UpiId { get; set; }
        public string QrImageUrl { get; set; }

        public bool IsActive { get; set; } = true;

        public int CreatedBy { get; set; }
        public DateTime CreatedOn { get; set; }

        public int? ModifiedBy { get; set; }
        public DateTime? ModifiedOn { get; set; }
    }
}
