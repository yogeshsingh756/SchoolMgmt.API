using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using SchoolMgmt.Domain.Entities;
using SchoolMgmt.Shared.Interfaces;
using SchoolMgmt.Shared.Models;
using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Infrastructure.Services
{
    public class JwtTokenService : IJwtTokenService
    {
        private readonly IConfiguration _config;

        public JwtTokenService(IConfiguration config)
        {
            _config = config;
        }

        public string GenerateAccessToken(UserTokenModel user, int expiryMinutes)
        {
            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_config["Jwt:Key"]!));
            var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

            var claims = new[]
            {
                new Claim(JwtRegisteredClaimNames.Sub, user.UserId.ToString()),
                new Claim("username", user.Username),
                new Claim("role", user.RoleName),
                new Claim("org", user.OrganizationId.ToString()),
                new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString())
            };

            var token = new JwtSecurityToken(
                issuer: _config["Jwt:Issuer"],
                audience: _config["Jwt:Audience"],
                claims: claims,
                expires: DateTime.UtcNow.AddMinutes(expiryMinutes),
                signingCredentials: creds
            );

            return new JwtSecurityTokenHandler().WriteToken(token);
        }

        public (string RefreshToken, DateTime ExpiresAt) GenerateRefreshToken()
        {
            var bytes = new byte[64];
            using var rng = RandomNumberGenerator.Create();
            rng.GetBytes(bytes);
            var token = Convert.ToBase64String(bytes)
                .Replace("+", "")
                .Replace("/", "")
                .Replace("=", "");

            return (token, DateTime.UtcNow.AddDays(30));
        }
    }
}
