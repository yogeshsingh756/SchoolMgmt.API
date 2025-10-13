using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Domain.Entities
{
    public class DbRole
    {
        public int RoleId { get; set; }
        public string RoleName { get; set; } = string.Empty;
    }
}
