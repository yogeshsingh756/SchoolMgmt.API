using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Shared.Models.Permission
{
    public class PermissionDto
    {
        public int PermissionId { get; set; }
        public string PermissionKey { get; set; } = string.Empty;
        public string PermissionName { get; set; } = string.Empty;
        public string ModuleName { get; set; } = string.Empty;
        public string? Description { get; set; }
        public bool IsActive { get; set; } = true;
    }
}
