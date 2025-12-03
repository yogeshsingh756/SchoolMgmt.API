using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Application.DTOs.Admin
{
    public class AdminUserDto
    {
        public int UserId { get; set; }
        public string FullName { get; set; } = string.Empty;
        public string Username { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string Phone { get; set; } = string.Empty;
        public string RoleName { get; set; } = string.Empty;
        public string Status { get; set; } = string.Empty;
        public DateTime CreatedOn { get; set; }
        public DateTime LastModified { get; set; }
        public string ModifiedByName { get; set; } = string.Empty;

        // CHANGED: role-specific fields
        public string? Occupation { get; set; }          
        public string? Address { get; set; }             

        public string? Qualification { get; set; }       
        public string? Designation { get; set; }         
        public decimal? Salary { get; set; }             

        public string? AdmissionNo { get; set; }         
        public int? CurrentClassId { get; set; }         
        public string? ClassName { get; set; }
    }

    public class PaginatedUserResponse
    {
        public IEnumerable<AdminUserDto> Users { get; set; } = new List<AdminUserDto>();
        public int TotalCount { get; set; }
        public int PageNumber { get; set; }
        public int PageSize { get; set; }
    }
}
