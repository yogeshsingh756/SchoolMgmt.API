using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Shared.Models
{
    public class UserTokenModel
    {
        public int UserId { get; set; }
        public string Username { get; set; } = string.Empty;
        public string RoleName { get; set; } = string.Empty;
        public int OrganizationId { get; set; }
    }
}
