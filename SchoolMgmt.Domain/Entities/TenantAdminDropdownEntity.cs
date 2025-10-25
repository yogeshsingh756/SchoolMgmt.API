using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Domain.Entities
{
    public class TenantAdminDropdownEntity
    {
        public int AdminUserId { get; set; }
        public string AdminName { get; set; }
        public string OrganizationName { get; set; }
        public string RoleName { get; set; }
        public string Email { get; set; }
        public string Username { get; set; }
    }
}
