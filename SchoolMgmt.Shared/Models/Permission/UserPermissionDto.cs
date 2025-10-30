using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Shared.Models.Permission
{
    public class UserPermissionDto
    {
        public int UserId { get; set; }
        public int PermissionId { get; set; }
        public string PermissionName { get; set; } = string.Empty;
        public string ModuleName { get; set; } = string.Empty;
        public bool CanView { get; set; }
        public bool CanCreate { get; set; }
        public bool CanEdit { get; set; }
        public bool CanDelete { get; set; }
    }
    public class UserPermissionDtoV2
    {
        public int UserId { get; set; }                 // optional, useful if joined later
        public int PermissionId { get; set; }
        public string PermissionKey { get; set; } = string.Empty;   // ✅ Added
        public string PermissionName { get; set; } = string.Empty;
        public string ModuleName { get; set; } = string.Empty;
        public string? SubModuleName { get; set; }      // ✅ Added
        public bool IsAssigned { get; set; }            // ✅ Added
        public bool CanView { get; set; }
        public bool CanCreate { get; set; }
        public bool CanEdit { get; set; }
        public bool CanDelete { get; set; }
    }

}
