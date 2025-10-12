using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Application.DTOs.Admin
{
    public class UpdateUserRequest
    {
        [Required]
        public int UserId { get; set; }

        [Required, StringLength(100)]
        public string FirstName { get; set; } = string.Empty;

        [StringLength(100)]
        public string? LastName { get; set; }

        [Required, EmailAddress]
        public string Email { get; set; } = string.Empty;

        [Phone]
        public string? Phone { get; set; }

        // Optional Role-Specific Fields (same as Create)
        public string? Qualification { get; set; }
        public string? Designation { get; set; }
        public decimal? Salary { get; set; }
        public string? Occupation { get; set; }
        public string? Address { get; set; }
        public string? AdmissionNo { get; set; }
        public int? ParentId { get; set; }
        public int? ClassId { get; set; }
    }
}
