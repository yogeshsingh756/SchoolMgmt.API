using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Shared.Responses
{
    /// <summary>
    /// Generic wrapper for all API responses.
    /// </summary>
    public class ApiResponse<T>
    {
        public bool Success { get; set; }
        public string Message { get; set; } = string.Empty;
        public string? Code { get; set; }   // ✅ Optional error code
        public T? Data { get; set; }

        public static ApiResponse<T> Ok(T data, string message = "Success")
            => new() { Success = true, Message = message, Data = data };

        public static ApiResponse<T> Fail(string message, string? code = null)
            => new() { Success = false, Message = message, Code = code };
    }

    /// <summary>
    /// Non-generic convenience version for simple responses.
    /// </summary>
    public class ApiResponse : ApiResponse<object?>
    {
        public new static ApiResponse Ok(string message = "Success")
            => new() { Success = true, Message = message };

        public new static ApiResponse Fail(string message, string? code = null)
            => new() { Success = false, Message = message, Code = code };
    }
}
