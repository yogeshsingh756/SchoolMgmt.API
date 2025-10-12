using Dapper;
using Microsoft.Extensions.Configuration;
using SchoolMgmt.Application.DTOs.Auth;
using SchoolMgmt.Application.Interfaces;
using SchoolMgmt.Domain.Entities;
using SchoolMgmt.Shared.Interfaces;
using SchoolMgmt.Shared.Models;
using System.Data;

namespace SchoolMgmt.Application.Services
{
    public class AuthService : IAuthService
    {
        private readonly IDbConnectionFactory _dbFactory;
        private readonly IJwtTokenService _jwtService;
        private readonly IConfiguration _config;
        private readonly IPermissionService _permissionService;

        public AuthService(IDbConnectionFactory dbFactory, IJwtTokenService jwtService, IConfiguration config, IPermissionService permissionService)
        {
            _dbFactory = dbFactory;
            _jwtService = jwtService;
            _config = config;
            _permissionService = permissionService;
        }

        public async Task<(bool Success, string? Message, AuthResponse? Response)> RegisterAsync(RegisterRequest req)
        {
            // Basic validation
            if (string.IsNullOrWhiteSpace(req.AdminPassword) || string.IsNullOrWhiteSpace(req.AdminUsername))
                return (false, "Invalid payload", null);

            // Hash password here
            var passwordHash = BCrypt.Net.BCrypt.HashPassword(req.AdminPassword, workFactor: 12);

            using var conn = _dbFactory.CreateConnection();
            var p = new DynamicParameters();
            p.Add("p_SchoolName", req.SchoolName);
            p.Add("p_Address", req.Address);
            p.Add("p_Phone", req.Phone);
            p.Add("p_Email", req.Email);
            p.Add("p_PlanId", req.PlanId);
            p.Add("p_IsTrial", req.IsTrial ? 1 : 0);
            p.Add("p_TrialDays", req.TrialDays);
            p.Add("p_AdminFirstName", req.AdminFirstName);
            p.Add("p_AdminLastName", req.AdminLastName);
            p.Add("p_AdminUsername", req.AdminUsername);
            p.Add("p_AdminEmail", req.AdminEmail);
            p.Add("p_AdminPasswordHash", passwordHash);
            p.Add("p_CreatedBy", 0);
            p.Add("p_AdminPhone", req.AdminPhone);

            p.Add("o_OrganizationId", dbType: DbType.Int32, direction: ParameterDirection.Output);
            p.Add("o_AdminUserId", dbType: DbType.Int32, direction: ParameterDirection.Output);
            p.Add("o_Status", dbType: DbType.String, size: 50, direction: ParameterDirection.Output);

            await conn.ExecuteAsync("sp_Org_Register", p, commandType: CommandType.StoredProcedure);

            var status = p.Get<string>("o_Status");
            if (!string.Equals(status, "OK", StringComparison.OrdinalIgnoreCase))
            {
                return (false, $"Registration failed: {status}", null);
            }

            var orgId = p.Get<int>("o_OrganizationId");
            var adminUserId = p.Get<int>("o_AdminUserId");

            // Auto-login: generate tokens
            // Create a lightweight User object to pass to token generation
            var user = new User
            {
                UserId = adminUserId,
                Username = req.AdminUsername,
                OrganizationId = orgId,
                Email = req.AdminEmail,
                RoleName = "Admin"
            };

            var expiryMinutes = int.Parse(_config["Jwt:ExpiryMinutes"] ?? "60");
            var tokenUser = new UserTokenModel
            {
                UserId = user.UserId,
                Username = user.Username,
                RoleName = user.RoleName,
                OrganizationId = user.OrganizationId
            };
            var accessToken = _jwtService.GenerateAccessToken(tokenUser, expiryMinutes);
            var (refreshToken, refreshExpiresAt) = _jwtService.GenerateRefreshToken();

            // persist refresh token via sp_RefreshToken_Create
            var p2 = new DynamicParameters();
            p2.Add("p_OrganizationId", orgId);
            p2.Add("p_UserId", adminUserId);
            p2.Add("p_Token", refreshToken);
            p2.Add("p_ExpiresAt", refreshExpiresAt);
            p2.Add("p_CreatedBy", adminUserId);
            p2.Add("o_RefreshTokenId", dbType: DbType.Int64, direction: ParameterDirection.Output);

            await conn.ExecuteAsync("sp_RefreshToken_Create", p2, commandType: CommandType.StoredProcedure);

            var refreshId = p2.Get<long>("o_RefreshTokenId");

            var response = new AuthResponse
            {
                AccessToken = accessToken,
                ExpiresInSeconds = expiryMinutes * 60,
                RefreshToken = refreshToken,
                RefreshExpiresAt = refreshExpiresAt,
                OrganizationId = orgId,
                UserId = adminUserId,
                Role = "Admin",
                Username = req.AdminUsername
            };

            return (true, null, response);
        }

        public async Task<(bool Success, string? Message, AuthResponse? Response)> LoginAsync(LoginRequest req)
        {
            using var conn = _dbFactory.CreateConnection();

            var p = new DynamicParameters();
            p.Add("p_Username", req.Username);

            var userRow = await conn.QueryFirstOrDefaultAsync<dynamic>("sp_Auth_GetUserByUsername", p, commandType: CommandType.StoredProcedure);
            if (userRow == null)
                return (false, "Invalid credentials", null);

            string storedHash = userRow.PasswordHash;
            bool isActive = userRow.IsActive;
            bool isDeleted = userRow.IsDeleted;

            if (!isActive || isDeleted)
                return (false, "Account inactive or deleted", null);

            // Verify password
            var verified = BCrypt.Net.BCrypt.Verify(req.Password, storedHash);
            if (!verified)
            {
                // optional: increase failed attempts via SP (if implemented)
                return (false, "Invalid credentials", null);
            }

            int userId = userRow.UserId;
            int orgId = userRow.OrganizationId;
            string roleName = userRow.RoleName ?? string.Empty;

            var user = new User
            {
                UserId = userId,
                Username = userRow.Username,
                OrganizationId = orgId,
                Email = userRow.Email,
                RoleName = roleName
            };

            var expiryMinutes = int.Parse(_config["Jwt:ExpiryMinutes"] ?? "60");
            var tokenUser = new UserTokenModel
            {
                UserId = user.UserId,
                Username = user.Username,
                RoleName = user.RoleName,
                OrganizationId = user.OrganizationId
            };
            var accessToken = _jwtService.GenerateAccessToken(tokenUser, expiryMinutes);
            var (refreshToken, refreshExpiresAt) = _jwtService.GenerateRefreshToken();

            // persist refresh token
            var p2 = new DynamicParameters();
            p2.Add("p_OrganizationId", orgId);
            p2.Add("p_UserId", userId);
            p2.Add("p_Token", refreshToken);
            p2.Add("p_ExpiresAt", refreshExpiresAt);
            p2.Add("p_CreatedBy", userId);
            p2.Add("o_RefreshTokenId", dbType: DbType.Int64, direction: ParameterDirection.Output);

            await conn.ExecuteAsync("sp_RefreshToken_Create", p2, commandType: CommandType.StoredProcedure);

            var effectivePermissions = await _permissionService.GetEffectivePermissionsAtLoginAsync(userId);

            // Convert to UserPermissionDto
            var permissions = effectivePermissions.Select(p => new UserPermissionDto
            {
                PermissionKey = p.PermissionKey,
                CanView = p.CanView,
                CanCreate = p.CanCreate,
                CanEdit = p.CanEdit,
                CanDelete = p.CanDelete
            }).ToList();
            var response = new AuthResponse
            {
                AccessToken = accessToken,
                ExpiresInSeconds = expiryMinutes * 60,
                RefreshToken = refreshToken,
                RefreshExpiresAt = refreshExpiresAt,
                OrganizationId = orgId,
                UserId = userId,
                Role = roleName,
                Username = req.Username,
                Permissions = permissions
            };

            return (true, null, response);
        }

        public async Task<(bool Success, string? Message, AuthResponse? Response)> RefreshAsync(string refreshToken)
        {
            using var conn = _dbFactory.CreateConnection();

            var pGet = new DynamicParameters();
            pGet.Add("p_Token", refreshToken);

            var tokenRow = await conn.QueryFirstOrDefaultAsync<dynamic>("sp_RefreshToken_Get", pGet, commandType: CommandType.StoredProcedure);
            if (tokenRow == null)
                return (false, "Invalid refresh token", null);

            DateTime expiresAt = tokenRow.ExpiresAt;
            bool isRevoked = tokenRow.RevokedAt != null;
            if (isRevoked || expiresAt <= DateTime.UtcNow)
                return (false, "Refresh token expired or revoked", null);

            int userId = (int)tokenRow.UserId;
            int orgId = (int)tokenRow.OrganizationId;

            // Revoke old token
            var pRevoke = new DynamicParameters();
            pRevoke.Add("p_Token", refreshToken);
            pRevoke.Add("p_RevokedAt", DateTime.UtcNow);
            pRevoke.Add("p_ModifiedBy", userId);
            await conn.ExecuteAsync("sp_RefreshToken_Revoke", pRevoke, commandType: CommandType.StoredProcedure);

            // Issue new tokens
            // We need user's basic info (username, role)
            var pUser = new DynamicParameters();
            pUser.Add("p_Username", tokenRow.Token); // we don't have username; best to fetch user row by userId - but sp_Auth_GetUserByUsername expects username
            // Instead, query Users by userId directly (simple query)
            var userRow = await conn.QueryFirstOrDefaultAsync<dynamic>("SELECT u.UserId, u.Username, u.Email, r.RoleName, u.OrganizationId FROM Users u LEFT JOIN Roles r ON u.RoleId = r.RoleId WHERE u.UserId = @UserId", new { UserId = userId });
            if (userRow == null)
                return (false, "User not found", null);

            var user = new User
            {
                UserId = userRow.UserId,
                Username = userRow.Username,
                OrganizationId = userRow.OrganizationId,
                Email = userRow.Email,
                RoleName = userRow.RoleName
            };

            var expiryMinutes = int.Parse(_config["Jwt:ExpiryMinutes"] ?? "60");
            var tokenUser = new UserTokenModel
            {
                UserId = user.UserId,
                Username = user.Username,
                RoleName = user.RoleName,
                OrganizationId = user.OrganizationId
            };
            var accessToken = _jwtService.GenerateAccessToken(tokenUser, expiryMinutes);
            var (newRefreshToken, newRefreshExpiresAt) = _jwtService.GenerateRefreshToken();

            var pCreate = new DynamicParameters();
            pCreate.Add("p_OrganizationId", orgId);
            pCreate.Add("p_UserId", userId);
            pCreate.Add("p_Token", newRefreshToken);
            pCreate.Add("p_ExpiresAt", newRefreshExpiresAt);
            pCreate.Add("p_CreatedBy", userId);
            pCreate.Add("o_RefreshTokenId", dbType: DbType.Int64, direction: ParameterDirection.Output);

            await conn.ExecuteAsync("sp_RefreshToken_Create", pCreate, commandType: CommandType.StoredProcedure);

            var response = new AuthResponse
            {
                AccessToken = accessToken,
                ExpiresInSeconds = expiryMinutes * 60,
                RefreshToken = newRefreshToken,
                RefreshExpiresAt = newRefreshExpiresAt,
                OrganizationId = orgId,
                UserId = userId,
                Role = user.RoleName ?? string.Empty,
                Username = user.Username
            };

            return (true, null, response);
        }

        public async Task<bool> LogoutAsync(string refreshToken, int performedByUserId)
        {
            using var conn = _dbFactory.CreateConnection();
            var p = new DynamicParameters();
            p.Add("p_Token", refreshToken);
            p.Add("p_RevokedAt", DateTime.UtcNow);
            p.Add("p_ModifiedBy", performedByUserId);
            await conn.ExecuteAsync("sp_RefreshToken_Revoke", p, commandType: CommandType.StoredProcedure);
            return true;
        }
    }
}
