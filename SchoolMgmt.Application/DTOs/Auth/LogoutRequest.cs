﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Application.DTOs.Auth
{
    public class LogoutRequest { public string RefreshToken { get; set; } = string.Empty; }
}
