using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Hosting;

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// Enable serving default files (e.g., index.html) and static files
app.UseDefaultFiles();
app.UseStaticFiles();

app.Run();
