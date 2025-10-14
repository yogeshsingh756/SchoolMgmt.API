using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Shared.Models.Module
{
    public class Modules
    {
        public int ModuleId { get; set; }
        public string ModuleName { get; set; } = string.Empty;
        public string? Icon { get; set; }
        public string? RoutePath { get; set; }
        public int OrderNo { get; set; }
        public List<SubModules> SubModules { get; set; } = new();
    }
}
