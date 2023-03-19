using System;
using System.Text;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.IdentityModel.Tokens;

namespace JwtAuthenticationExample
{
    class Program
    {
        static void Main(string[] args)
        {
            var host = new WebHostBuilder()
                .UseKestrel()
                .UseUrls("https://localhost:5001")
                .ConfigureServices(services =>
                {
                    services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
                        .AddJwtBearer(options =>
                        {
                            options.TokenValidationParameters = new TokenValidationParameters
                            {
                                ValidateIssuer = true,
                                ValidateAudience = true,
                                ValidateLifetime = true,
                                ValidateIssuerSigningKey = true,
                                ValidIssuer = "your-issuer",
                                ValidAudience = "your-audience",
                                IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes("your-secret-key"))
                            };
                        });
                })
                .Configure(app =>
                {
                    app.UseAuthentication();

                    app.Run(async context =>
                    {
                        var jwt = context.Request.Headers["Authorization"].ToString().Replace("Bearer ", "");
                        if (!string.IsNullOrEmpty(jwt))
                        {
                            // Authenticate JWT token
                            // You can implement your own logic here to validate the token
                            await context.Response.WriteAsync("Authenticated");
                        }
                        else
                        {
                            context.Response.StatusCode = 401;
                            await context.Response.WriteAsync("Unauthorized");
                        }
                    });
                })
                .Build();

            host.Run();
        }
    }
}
