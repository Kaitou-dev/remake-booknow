# Thymeleaf Refactoring Implementation Guide

## Project Structure

```
src/main/resources/
├── static/
│   ├── css/
│   │   ├── global.css              # Global styles
│   │   ├── staff.css               # Staff-specific styles
│   │   └── customer.css            # Customer-specific styles
│   │
│   └── js/
│       ├── common.js                # Common utilities
│       ├── staff-sidebar.js         # Sidebar logic
│       └── customer-navbar.js       # Navbar logic
│
└── templates/
    ├── fragments/
    │   ├── common/
    │   │   ├── head.html           # Common head section
    │   │   ├── logo.html           # BookNow logo
    │   │   └── scripts.html        # Common scripts
    │   │
    │   ├── staff/
    │   │   ├── sidebar.html        # Staff sidebar navigation
    │   │   ├── mobile-header.html  # Mobile header
    │   │   └── user-info.html      # User profile info
    │   │
    │   ├── customer/
    │   │   ├── navbar.html         # Customer navbar
    │   │   ├── footer.html         # Customer footer
    │   │   └── profile-dropdown.html # Profile dropdown
    │   │
    │   └── housekeeping/
    │       ├── header.html         # Housekeeping header
    │       └── footer.html         # Housekeeping footer
    │
    ├── layouts/
    │   ├── base-layout.html        # Base layout
    │   ├── staff-layout.html       # Staff dashboard layout
    │   ├── customer-layout.html    # Customer-facing layout
    │   └── housekeeping-layout.html # Housekeeping layout
    │
    ├── staff/
    │   ├── dashboard.html          # Staff dashboard
    │   ├── booking-list.html       # Booking list
    │   ├── booking-detail.html     # Booking detail
    │   └── ... (other staff pages)
    │
    ├── customer/
    │   ├── index.html              # Homepage
    │   ├── login.html              # Login page
    │   ├── room-detail.html        # Room detail
    │   └── ... (other customer pages)
    │
    └── housekeeping/
        ├── dashboard.html          # Housekeeping dashboard
        └── ... (other housekeeping pages)
```

## Key Thymeleaf Concepts Used

### 1. Fragments (`th:fragment`)
Define reusable components that can be included anywhere.

### 2. Layout Dialect (`layout:decorate`)
Extend base layouts with content blocks.

### 3. Fragment Replacement (`th:replace`, `th:insert`)
Include fragments in templates.

### 4. Conditional Rendering (`th:if`, `sec:authorize`)
Show/hide content based on conditions.

### 5. Variables (`th:text`, `th:attr`)
Dynamic content injection.

## Implementation Steps

### Step 1: Add Dependencies (pom.xml)

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-thymeleaf</artifactId>
</dependency>
<dependency>
    <groupId>nz.net.ultraq.thymeleaf</groupId>
    <artifactId>thymeleaf-layout-dialect</artifactId>
</dependency>
```

### Step 2: Configure Thymeleaf (application.properties)

```properties
spring.thymeleaf.cache=false
spring.thymeleaf.prefix=classpath:/templates/
spring.thymeleaf.suffix=.html
spring.thymeleaf.mode=HTML
spring.thymeleaf.encoding=UTF-8
```

### Step 3: Create Fragment Files
See the generated fragment files in the `templates/fragments/` directory.

### Step 4: Create Layout Files
See the generated layout files in the `templates/layouts/` directory.

### Step 5: Migrate Pages
Convert existing pages to use layouts. Examples provided in respective directories.

### Step 6: Update Controllers

```java
@Controller
public class StaffController {

    @GetMapping("/staff/dashboard")
    public String dashboard(Model model, @AuthenticationPrincipal UserDetails userDetails) {
        model.addAttribute("pageTitle", "Staff Dashboard");
        model.addAttribute("activePage", "dashboard");
        model.addAttribute("userName", userDetails.getUsername());
        model.addAttribute("userRole", "Nhân viên");

        // Add dashboard data
        model.addAttribute("todayBookings", 8);
        model.addAttribute("availableRooms", 5);

        return "staff/dashboard";
    }
}
```

## Migration Checklist

- [ ] Install Thymeleaf and Layout Dialect dependencies
- [ ] Create `static/css/global.css` and `static/js/common.js`
- [ ] Create all fragment files in `templates/fragments/`
- [ ] Create all layout files in `templates/layouts/`
- [ ] Migrate staff pages (Staff_dashboard.html → staff/dashboard.html)
- [ ] Migrate customer pages (index.html → customer/index.html)
- [ ] Migrate housekeeping pages
- [ ] Update all controllers to use new paths
- [ ] Test all pages for correct rendering
- [ ] Remove old HTML files from project root

## Benefits After Refactoring

✅ **90% reduction** in code duplication
✅ **Single source of truth** for all UI components
✅ **Easy maintenance** - update once, applies everywhere
✅ **Type-safe** - Spring Security integration
✅ **SEO-friendly** - server-side rendering
✅ **Fast development** - new pages in minutes

## Support

For issues or questions, refer to:
- Thymeleaf Docs: https://www.thymeleaf.org/documentation.html
- Layout Dialect: https://ultraq.github.io/thymeleaf-layout-dialect/
