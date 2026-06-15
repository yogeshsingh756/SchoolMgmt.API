using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Shared.Models.Tenant
{
    public class PaginatedTenantResponse
    {
        public IEnumerable<TenantListDto> Tenants { get; set; }
            = new List<TenantListDto>();

        public int TotalCount { get; set; }

        public int PageNumber { get; set; }

        public int PageSize { get; set; }
    }
}
