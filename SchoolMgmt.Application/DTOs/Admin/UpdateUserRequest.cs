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

        public string Email { get; set; } = string.Empty;

        [Phone]
        public string? PhoneNumber { get; set; }

        // Optional Role-Specific Fields (same as Create)
        public string? Qualification { get; set; }
        public string? Designation { get; set; }
        public decimal? Salary { get; set; }
        public string? Occupation { get; set; }
        public string? Address { get; set; }
        public string? AdmissionNo { get; set; }
        public int? ParentId { get; set; }
        public int? ClassId { get; set; }
        public string? Gender { get; set; }
        public string? MotherName { get; set; }
        public string? Category { get; set; }
        public string? FatherName { get; set; }

    }
}
