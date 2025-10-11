using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using System.Security.Claims;

namespace SchoolMgmt.API.Filters
{
    [AttributeUsage(AttributeTargets.Class | AttributeTargets.Method, AllowMultiple = true)]
    public class RoleAuthorizeAttribute : Attribute, IAuthorizationFilter
    {
        private readonly string[] _roles;
        public RoleAuthorizeAttribute(params string[] roles) => _roles = roles;

        public void OnAuthorization(AuthorizationFilterContext context)
        {
            var user = context.HttpContext.User;
            if (user?.Identity == null || !user.Identity.IsAuthenticated)
            {
                context.Result = new UnauthorizedResult();
                return;
            }

            var roleClaim = user.Claims.FirstOrDefault(c => c.Type == "role")?.Value
                            ?? user.Claims.FirstOrDefault(c => c.Type == "roles")?.Value;

            if (string.IsNullOrEmpty(roleClaim) || !_roles.Contains(roleClaim, StringComparer.OrdinalIgnoreCase))
            {
                context.Result = new ForbidResult();
            }
        }
    }
}
