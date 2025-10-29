using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Domain.Entities
{
    public class SubModule
    {
        public int SubModuleId { get; set; }
        public int ModuleId { get; set; }
        public string SubModuleName { get; set; } = string.Empty;
        public string? Description { get; set; }
        public string? RoutePath { get; set; }
        public int OrderNo { get; set; }
        public bool IsActive { get; set; }
        public DateTime  CreatedOn { get; set; }
        public string AssignedRoleIds { get; set; }
    }
}
