using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Application.DTOs.Auth
{
    public class AuthResponse
    {
        public string AccessToken { get; set; } = string.Empty;
        public int ExpiresInSeconds { get; set; }
        public string RefreshToken { get; set; } = string.Empty;
        public DateTime RefreshExpiresAt { get; set; }
        public int OrganizationId { get; set; }
        public int UserId { get; set; }
        public string Role { get; set; } = string.Empty;
        public string Username { get; set; } = string.Empty;
        public List<UserPermissionDto> Permissions { get; set; } = new();
    }
}
