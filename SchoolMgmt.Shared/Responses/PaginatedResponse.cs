using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Shared.Responses
{
    public class PaginatedResponse<T> : ApiResponse<IEnumerable<T>>
    {
        public int TotalCount { get; set; }
        public int PageNumber { get; set; }
        public int PageSize { get; set; }

        public static PaginatedResponse<T> Create(IEnumerable<T> items, int total, int page, int size, string message = "Success")
        {
            return new PaginatedResponse<T>
            {
                Success = true,
                Message = message,
                Data = items,
                TotalCount = total,
                PageNumber = page,
                PageSize = size
            };
        }
    }
}
