using SchoolMgmt.Shared.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Shared.Interfaces
{
    public interface IJwtTokenService
    {
        string GenerateAccessToken(UserTokenModel user, int expiryMinutes);
        (string RefreshToken, DateTime ExpiresAt) GenerateRefreshToken();
    }
}
