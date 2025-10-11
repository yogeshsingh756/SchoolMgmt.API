using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Application.DTOs.SuperAdmin
{
    public class UpdateTenantStatusRequest
    {
        public string NewStatus { get; set; } = "Active";
    }
}
