using MaintenanceRequestSystem.Extensions;

var builder = WebApplication.CreateBuilder(args);

// ── Services ──────────────────────────────────────────────────────────────
builder.Services.AddDatabase(builder.Configuration);
builder.Services.AddIdentityServices();
builder.Services.AddApplicationServices();

builder.Services.AddControllersWithViews();

// ── App Pipeline ──────────────────────────────────────────────────────────
var app = builder.Build();

if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    app.UseHsts();
}

app.UseStaticFiles();
app.UseRouting();

app.UseAuthentication();
app.UseAuthorization();

// MVC routes
app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Dashboard}/{action=Index}/{id?}");

// Map root URL
app.MapGet("/", context =>
{
    if (context.User.Identity?.IsAuthenticated == true)
        context.Response.Redirect("/Dashboard");
    else
        context.Response.Redirect("/Account/Login");
    return Task.CompletedTask;
});

// ── Seed Database ─────────────────────────────────────────────────────────
await SeedData.InitializeAsync(app.Services);

app.Run();

// ── Seed Data ─────────────────────────────────────────────────────────────
public static class SeedData
{
    public static async Task InitializeAsync(IServiceProvider serviceProvider)
    {
        using var scope = serviceProvider.CreateScope();
        var services = scope.ServiceProvider;

        try
        {
            var userManager = services.GetRequiredService<Microsoft.AspNetCore.Identity.UserManager<MaintenanceRequestSystem.Models.ApplicationUser>>();
            var roleManager = services.GetRequiredService<Microsoft.AspNetCore.Identity.RoleManager<Microsoft.AspNetCore.Identity.IdentityRole>>();
            var logger = services.GetRequiredService<ILogger<Program>>();

            // Create roles
            string[] roles = ["Admin", "Technician", "Employee"];
            foreach (var role in roles)
            {
                if (!await roleManager.RoleExistsAsync(role))
                {
                    await roleManager.CreateAsync(new Microsoft.AspNetCore.Identity.IdentityRole(role));
                    logger.LogInformation("Role created: {Role}", role);
                }
            }

            // Seed Admin
            await SeedUserAsync(userManager, logger,
                email: "admin@maintenance.com",
                fullName: "System Administrator",
                department: "IT",
                password: "Admin@123",
                role: "Admin");

            // Seed Technician
            await SeedUserAsync(userManager, logger,
                email: "tech@maintenance.com",
                fullName: "Ahmed Hassan",
                department: "Maintenance",
                password: "Tech@123",
                role: "Technician");

            // Seed Employee
            await SeedUserAsync(userManager, logger,
                email: "emp@maintenance.com",
                fullName: "Sara Mohamed",
                department: "HR",
                password: "Emp@123",
                role: "Employee");

            logger.LogInformation("Database seeded successfully");
        }
        catch (Exception ex)
        {
            var logger = services.GetRequiredService<ILogger<Program>>();
            logger.LogError(ex, "Error seeding database");
        }
    }

    private static async Task SeedUserAsync(
        Microsoft.AspNetCore.Identity.UserManager<MaintenanceRequestSystem.Models.ApplicationUser> userManager,
        ILogger logger,
        string email, string fullName, string department, string password, string role)
    {
        if (await userManager.FindByEmailAsync(email) == null)
        {
            var user = new MaintenanceRequestSystem.Models.ApplicationUser
            {
                UserName = email,
                Email = email,
                FullName = fullName,
                Department = department,
                IsActive = true,
                CreatedAt = DateTime.UtcNow,
                EmailConfirmed = true
            };

            var result = await userManager.CreateAsync(user, password);
            if (result.Succeeded)
            {
                await userManager.AddToRoleAsync(user, role);
                logger.LogInformation("Seeded user: {Email} ({Role})", email, role);
            }
            else
            {
                logger.LogError("Failed to seed user {Email}: {Errors}", email,
                    string.Join(", ", result.Errors.Select(e => e.Description)));
            }
        }
    }
}
