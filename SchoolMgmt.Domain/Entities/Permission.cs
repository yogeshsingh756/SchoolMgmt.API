using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Domain.Entities
{
    public class Permission
    {
        public int PermissionId { get; set; }
        public string PermissionKey { get; set; }
        public string PermissionName { get; set; }
        public int? ModuleId { get; set; }
        public int? SubModuleId { get; set; }
        public string ModuleName { get; set; }
        public string Description { get; set; }
        public bool IsActive { get; set; }
        public DateTime CreatedOn { get; set; }
    }
}
