using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Application.DTOs.Module
{
    public class ModuleDto
    {
        public int ModuleId { get; set; }
        public string ModuleName { get; set; } = string.Empty;
        public string? Description { get; set; }
        public string? Icon { get; set; }
        public string? RoutePath { get; set; }
        public int OrderNo { get; set; }
        public bool IsActive { get; set; }
        public DateTime CreatedOn { get; set; }
        public List<int> AssignedRoleIds { get; set; } = new();
    }
}
