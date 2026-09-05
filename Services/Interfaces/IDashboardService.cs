using MaintenanceRequestSystem.DTOs.Dashboard;

namespace MaintenanceRequestSystem.Services.Interfaces;

public interface IDashboardService
{
    Task<AdminDashboardDto> GetAdminDashboardAsync();
    Task<TechnicianDashboardDto> GetTechnicianDashboardAsync(string technicianId);
    Task<EmployeeDashboardDto> GetEmployeeDashboardAsync(string employeeId);
}
