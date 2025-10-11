using Microsoft.Extensions.Configuration;
using MySqlConnector;
using SchoolMgmt.Shared.Interfaces;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Infrastructure.Data
{
    public class DbConnectionFactory : IDbConnectionFactory
    {
        private readonly IConfiguration _config;

        public DbConnectionFactory(IConfiguration config)
        {
            _config = config;
        }

        public IDbConnection CreateConnection()
        {
            var connectionString = _config.GetConnectionString("DefaultConnection");
            return new MySqlConnection(connectionString);
        }
    }
}
