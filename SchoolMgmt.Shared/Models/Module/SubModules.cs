using SchoolMgmt.Shared.Models.Permission;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Shared.Models.Module
{
    public class SubModules
    {
        public int SubModuleId { get; set; }
        public string SubModuleName { get; set; } = string.Empty;
        public string? RoutePath { get; set; }
        public List<Permissions> Permissions { get; set; } = new();
    }
}
