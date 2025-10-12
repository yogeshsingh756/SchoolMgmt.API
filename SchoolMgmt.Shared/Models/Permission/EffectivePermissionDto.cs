using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Shared.Models.Permission
{
    public class EffectivePermissionDto
    {
        public int PermissionId { get; set; }
        public string PermissionKey { get; set; } = string.Empty;
        public string ModuleName { get; set; } = string.Empty;
        public bool CanView { get; set; }
        public bool CanCreate { get; set; }
        public bool CanEdit { get; set; }
        public bool CanDelete { get; set; }
    }
}
