using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using SchoolMgmt.Shared.Interfaces;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;

namespace SchoolMgmt.API.Filters
{
    [AttributeUsage(AttributeTargets.Method | AttributeTargets.Class, AllowMultiple = true)]
    public class AuthorizePermissionAttribute : Attribute, IAsyncAuthorizationFilter
    {
        private readonly string _permissionKey;

        public AuthorizePermissionAttribute(string permissionKey)
        {
            _permissionKey = permissionKey;
        }

        public async Task OnAuthorizationAsync(AuthorizationFilterContext context)
        {
            var permissionService = context.HttpContext.RequestServices.GetService<IPermissionService>();
            var user = context.HttpContext.User;

            if (user?.Identity == null || !user.Identity.IsAuthenticated)
            {
                context.Result = new UnauthorizedResult();
                return;
            }

            var userIdClaim = user.FindFirst(ClaimTypes.NameIdentifier)
                ?? user.FindFirst(JwtRegisteredClaimNames.Sub);

            if (userIdClaim == null || !int.TryParse(userIdClaim.Value, out var userId))
            {
                context.Result = new UnauthorizedResult();
                return;
            }

            // Check cache in HttpContext.Items first (avoid repeated DB calls)
            if (!context.HttpContext.Items.TryGetValue("UserPermissions", out var cachedPerms))
            {
                var effectivePerms = await permissionService!.GetEffectivePermissionsAsync(userId);
                context.HttpContext.Items["UserPermissions"] = effectivePerms;
                cachedPerms = effectivePerms;
            }

            var permissions = cachedPerms as IEnumerable<dynamic>;

            var hasPermission = permissions?.Any(p =>
                string.Equals(p.PermissionKey, _permissionKey, StringComparison.OrdinalIgnoreCase)
                && (p.CanView || p.CanCreate || p.CanEdit || p.CanDelete)) ?? false;

            if (!hasPermission)
            {
                context.Result = new ForbidResult();
                return;
            }
        }
    }
}
