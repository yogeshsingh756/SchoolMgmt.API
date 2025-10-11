using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Application.DTOs.Auth
{

    public sealed class AuthResult
    {
        public string AccessToken { get; set; } = default!;
        public DateTime AccessTokenExpiresAt { get; set; }
        public string RefreshToken { get; set; } = default!;
        public DateTime RefreshTokenExpiresAt { get; set; }
        public int UserId { get; set; }
        public int OrganizationId { get; set; }
        public IReadOnlyList<string> Roles { get; set; } = Array.Empty<string>();
    }
}
