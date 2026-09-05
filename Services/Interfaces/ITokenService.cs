using MaintenanceRequestSystem.DTOs.Auth;
using MaintenanceRequestSystem.Models;

namespace MaintenanceRequestSystem.Services.Interfaces;

public interface ITokenService
{
    string GenerateToken(ApplicationUser user, IList<string> roles);
    DateTime GetExpirationDate();
}
