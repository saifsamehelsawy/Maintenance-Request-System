# 🔧 Maintenance Request System

A full-featured **ASP.NET Core 10** application combining **MVC Web UI** and **REST API** for managing maintenance requests in an organization.

---

## 🏗️ Architecture

```
┌───────────────────┐        ┌─────────────────────────┐
│  Razor MVC UI     │        │  Mobile / React / Postman│
└────────┬──────────┘        └────────────┬────────────┘
         │                                │
         ▼                                ▼
┌───────────────────┐        ┌─────────────────────────┐
│  MVC Controllers  │        │  API Controllers        │
│  /Account         │        │  /api/v1/auth           │
│  /Requests        │        │  /api/v1/requests       │
│  /Dashboard       │        │  /api/v1/categories     │
│  /Categories      │        │  /api/v1/users          │
│  /Users           │        │  /api/v1/dashboard      │
└────────┬──────────┘        └────────────┬────────────┘
         │                                │
         └──────────────┬─────────────────┘
                        ▼
              ┌──────────────────┐
              │  Services Layer  │
              │  (Business Logic)│
              │  RequestService  │
              │  CategoryService │
              │  UserService     │
              │  DashboardService│
              │  TokenService    │
              └────────┬─────────┘
                       ▼
              ┌──────────────────┐
              │  EF Core 10      │
              │  ApplicationDbCtx│
              └────────┬─────────┘
                       ▼
              ┌──────────────────┐
              │  SQL Server 2025 │
              │  MaintenanceDB   │
              └──────────────────┘
```

---

## 🚀 Technology Stack

| Component | Technology |
|-----------|-----------|
| Framework | ASP.NET Core 10 |
| Web UI | Razor MVC + Bootstrap 5 |
| REST API | ASP.NET Core Web API |
| ORM | Entity Framework Core 10 |
| Database | SQL Server 2025 Express |
| Auth | ASP.NET Core Identity + JWT Bearer |
| API Docs | Swagger / OpenAPI (Swashbuckle 9) |
| Logging | Microsoft.Extensions.Logging |
| Rate Limiting | Built-in ASP.NET Core Rate Limiter |

---

## 👥 Roles & Permissions

| Feature | Employee | Technician | Admin |
|---------|----------|------------|-------|
| View own requests | ✅ | ✅ (assigned) | ✅ All |
| Create request | ✅ | ❌ | ✅ |
| Edit own Pending | ✅ | ❌ | ✅ |
| Delete own Pending | ✅ | ❌ | ✅ All |
| Assign technician | ❌ | ❌ | ✅ |
| Change status | ❌ | ✅ (own) | ✅ |
| Manage categories | ❌ | ❌ | ✅ |
| Manage users | ❌ | ❌ | ✅ |
| Admin dashboard | ❌ | ❌ | ✅ |
| Technician dashboard | ❌ | ✅ | ❌ |
| Employee dashboard | ✅ | ❌ | ❌ |

---

## 📊 Status Transition Rules

```
Pending ──(Admin assigns)──► Assigned
Assigned ──(Technician starts)──► InProgress
InProgress ──(Technician resolves)──► Resolved
Resolved ──(Admin/Employee closes)──► Closed
Pending ──(Admin)──► Closed
```

---

## 🔑 Quick Start

### Prerequisites
- .NET 10 SDK
- SQL Server 2025 Express (or `.\sqlexpress`)

### Setup
```bash
# 1. Clone/navigate to project
cd MaintenanceRequestSystem

# 2. Run migrations (already done)
dotnet ef database update

# 3. Run the application
dotnet run

# 4. Open browser
# MVC UI:    https://localhost:5001
# Swagger:   https://localhost:5001/swagger
```

---

## 🔐 Demo Accounts

| Role | Email | Password |
|------|-------|----------|
| Admin | admin@maintenance.com | Admin@123 |
| Technician | tech@maintenance.com | Tech@123 |
| Employee | emp@maintenance.com | Emp@123 |

---

## 🌐 API Documentation

### Base URL
```
/api/v1
```

### Authentication
All protected endpoints require JWT Bearer token:
```
Authorization: Bearer {your_token}
```

### Get Token
```http
POST /api/v1/auth/login
Content-Type: application/json

{
  "email": "admin@maintenance.com",
  "password": "Admin@123"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "token": "eyJhbGci...",
    "expiresAt": "2025-09-05T12:00:00Z",
    "user": {
      "id": "...",
      "fullName": "System Administrator",
      "email": "admin@maintenance.com",
      "roles": ["Admin"]
    }
  }
}
```

---

### Auth Endpoints

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| POST | `/api/v1/auth/register` | No | Register new user |
| POST | `/api/v1/auth/login` | No | Login & get JWT |
| POST | `/api/v1/auth/logout` | Yes | Logout |

---

### Requests Endpoints

| Method | Endpoint | Role | Description |
|--------|----------|------|-------------|
| GET | `/api/v1/requests` | All | Get paginated requests |
| POST | `/api/v1/requests` | Employee | Create request |
| GET | `/api/v1/requests/{id}` | All | Get request details |
| PUT | `/api/v1/requests/{id}` | Employee/Admin | Update request |
| DELETE | `/api/v1/requests/{id}` | Employee/Admin | Soft delete |
| POST | `/api/v1/requests/{id}/assign` | Admin | Assign technician |
| PUT | `/api/v1/requests/{id}/status` | Technician/Admin | Change status |
| GET | `/api/v1/requests/{id}/comments` | All | Get comments |
| POST | `/api/v1/requests/{id}/comments` | All | Add comment |
| GET | `/api/v1/requests/{id}/history` | All | Get history |

#### Query Parameters for GET `/api/v1/requests`
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| page | int | 1 | Page number |
| pageSize | int | 10 | Items per page (max 100) |
| search | string | - | Search in title/description |
| status | enum | - | Pending/Assigned/InProgress/Resolved/Closed |
| priority | enum | - | Low/Medium/High/Critical |
| categoryId | int | - | Filter by category |
| technicianId | string | - | Filter by technician |
| dateFrom | datetime | - | Created after |
| dateTo | datetime | - | Created before |
| sortBy | string | createdAt | createdAt/title/status/priority/updatedAt |
| sortDirection | string | desc | asc/desc |

---

### Categories Endpoints

| Method | Endpoint | Role | Description |
|--------|----------|------|-------------|
| GET | `/api/v1/categories` | All | Get all categories |
| GET | `/api/v1/categories/{id}` | All | Get category |
| POST | `/api/v1/categories` | Admin | Create category |
| PUT | `/api/v1/categories/{id}` | Admin | Update category |
| DELETE | `/api/v1/categories/{id}` | Admin | Delete category |

---

### Users Endpoints

| Method | Endpoint | Role | Description |
|--------|----------|------|-------------|
| GET | `/api/v1/users` | Admin | Get all users |
| GET | `/api/v1/users/{id}` | Admin | Get user |
| PUT | `/api/v1/users/{id}` | Admin | Update user |
| PUT | `/api/v1/users/{id}/activate` | Admin | Activate user |
| PUT | `/api/v1/users/{id}/deactivate` | Admin | Deactivate user |
| GET | `/api/v1/users/technicians` | Admin | Get all technicians |

---

### Dashboard Endpoints

| Method | Endpoint | Role | Description |
|--------|----------|------|-------------|
| GET | `/api/v1/dashboard/admin` | Admin | Admin statistics |
| GET | `/api/v1/dashboard/technician` | Technician | Technician statistics |
| GET | `/api/v1/dashboard/employee` | Employee | Employee statistics |

---

## 📝 Standard Response Format

**Success:**
```json
{
  "success": true,
  "message": "Request retrieved successfully",
  "data": { ... }
}
```

**Error:**
```json
{
  "success": false,
  "message": "Request not found",
  "errors": null
}
```

**Validation Error:**
```json
{
  "success": false,
  "message": "Validation failed",
  "errors": [
    { "field": "Title", "message": "Title is required" }
  ]
}
```

---

## 📁 Project Structure

```
MaintenanceRequestSystem/
├── Controllers/
│   ├── AccountController.cs       # MVC Login/Register/Logout
│   ├── DashboardController.cs     # MVC Dashboard
│   ├── RequestsController.cs      # MVC Requests (CRUD)
│   ├── CategoriesController.cs    # MVC Categories
│   ├── UsersController.cs         # MVC Users
│   └── API/
│       ├── AuthApiController.cs       # POST /api/v1/auth/*
│       ├── RequestsApiController.cs   # /api/v1/requests
│       ├── CategoriesApiController.cs # /api/v1/categories
│       ├── UsersApiController.cs      # /api/v1/users
│       └── DashboardApiController.cs  # /api/v1/dashboard/*
│
├── Models/
│   ├── ApplicationUser.cs
│   ├── MaintenanceRequest.cs
│   ├── Category.cs
│   ├── RequestComment.cs
│   ├── RequestHistory.cs
│   └── Enums/
│       ├── RequestStatus.cs  # Pending/Assigned/InProgress/Resolved/Closed
│       ├── Priority.cs       # Low/Medium/High/Critical
│       └── RequestAction.cs  # For audit history
│
├── DTOs/
│   ├── Auth/          # LoginDto, RegisterDto, AuthResponseDto
│   ├── Requests/      # CreateRequestDto, RequestListDto, RequestDetailsDto...
│   ├── Categories/    # CategoryDto, CreateCategoryDto, UpdateCategoryDto
│   ├── Users/         # UserDto, UpdateUserDto
│   ├── Dashboard/     # AdminDashboardDto, TechnicianDashboardDto, EmployeeDashboardDto
│   └── Common/        # ApiResponse<T>, PagedResult<T>, ValidationError
│
├── Services/
│   ├── Interfaces/
│   │   ├── IRequestService.cs
│   │   ├── ICategoryService.cs
│   │   ├── IUserService.cs
│   │   ├── IDashboardService.cs
│   │   └── ITokenService.cs
│   ├── RequestService.cs    # Full business logic (shared by MVC + API)
│   ├── CategoryService.cs
│   ├── UserService.cs
│   ├── DashboardService.cs
│   └── TokenService.cs      # JWT generation
│
├── Data/
│   ├── ApplicationDbContext.cs
│   └── Migrations/
│
├── Middleware/
│   └── GlobalExceptionMiddleware.cs  # API → JSON, MVC → Error page
│
├── Extensions/
│   └── ServiceExtensions.cs  # DI, JWT, Identity, Swagger, CORS, RateLimiting
│
├── Helpers/
│   └── RequestNumberGenerator.cs  # REQ-2025-0001
│
├── Views/
│   ├── Account/ (Login, Register, AccessDenied)
│   ├── Dashboard/ (AdminDashboard, TechnicianDashboard, EmployeeDashboard)
│   ├── Requests/ (Index, Details, Create, Edit)
│   ├── Categories/ (Index, Create, Edit)
│   ├── Users/ (Index, Details, Edit)
│   └── Shared/ (_Layout.cshtml)
│
├── Program.cs       # Full pipeline setup + DB Seeding
├── appsettings.json # JWT, CORS, RateLimiting, DB connection
└── README.md
```

---

## ⚙️ Configuration

`appsettings.json`:
```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=.\\sqlexpress;Database=MaintenanceRequestDB;..."
  },
  "Jwt": {
    "Key": "...(min 32 chars)...",
    "Issuer": "MaintenanceRequestSystem",
    "Audience": "MaintenanceRequestSystemUsers",
    "ExpirationMinutes": "60"
  },
  "Cors": {
    "AllowedOrigins": ["http://localhost:3000", "http://localhost:4200"]
  },
  "RateLimiting": {
    "LoginWindowMinutes": "1",
    "LoginMaxAttempts": "5"
  }
}
```

> ⚠️ **Security**: In production, store JWT Key in User Secrets or Environment Variables, never in source code.

---

## 🧪 Testing with Swagger

1. Open `https://localhost:5001/swagger`
2. Click `POST /api/v1/auth/login`
3. Enter credentials → Execute
4. Copy the `token` from response
5. Click **Authorize** button (top right)
6. Enter: `Bearer {your_token}`
7. Test any protected endpoint

---

## 🔒 Security Features

- ✅ JWT Bearer Authentication for API
- ✅ Cookie Authentication for MVC
- ✅ Role-based Authorization (Admin/Technician/Employee)
- ✅ Resource-level Authorization (Employee sees only own requests)
- ✅ Rate Limiting on auth endpoints (5 req/min)
- ✅ Soft Delete (data never permanently lost)
- ✅ Password never returned in any response
- ✅ Global Exception Handler (no stack traces in production)
- ✅ CORS configured per environment
- ✅ Input validation with Data Annotations

---

## 🌱 Seed Data

On first run, the application automatically creates:
- **5 Categories**: Electrical, Plumbing, HVAC, IT Equipment, Furniture
- **3 Roles**: Admin, Technician, Employee
- **3 Users**: admin, tech, emp (credentials above)
