# Aurora Hotel - Playwright Tests

Automated end-to-end tests for Aurora Hotel Management System using Playwright.

## Prerequisites

- Node.js 16+ installed
- Aurora Hotel application running on `http://localhost:8080/AuroraHotel`
- Test user credentials:
  - Username: `admin`
  - Password: `admin123`

## Setup

1. Navigate to tests directory:
```bash
cd tests
```

2. Install dependencies:
```bash
npm install
```

3. Install Playwright browsers:
```bash
npx playwright install
```

## Running Tests

### Run all tests
```bash
npm test
```

### Run tests in headed mode (see browser)
```bash
npm run test:headed
```

### Run tests in debug mode
```bash
npm run test:debug
```

### Run specific test file
```bash
npm run test:service
```

### Run tests with UI mode
```bash
npm run test:ui
```

## Test Structure

```
tests/
├── package.json           # Dependencies and scripts
├── playwright.config.js   # Playwright configuration
├── specs/                 # Test specifications
│   └── service.spec.js   # Service Management CRUD tests
└── test-results/         # Test results and reports (generated)
```

## Test Coverage

### Service Management (service.spec.js)
- ✅ Navigate to Service Management page
- ✅ Display service list with table
- ✅ Create a new service
- ✅ Edit an existing service
- ✅ View service details
- ✅ Toggle service active status
- ✅ Delete a service (soft delete)
- ✅ Validate required fields
- ✅ Validate price is non-negative
- ✅ Handle pagination
- ✅ Cancel operations (create, edit, delete)

## Test Reports

After running tests, view the HTML report:
```bash
npx playwright show-report test-results/html
```

## Troubleshooting

### Application not running
Make sure the Aurora Hotel application is running:
```bash
# From project root
mvn clean package
mvn tomcat7:run
```

### Login fails
Verify test credentials in the database:
- Username: `admin`
- Password: `admin123`

### Tests timeout
Increase timeout in `playwright.config.js`:
```javascript
use: {
  actionTimeout: 30000, // Increase from 10000
}
```

## Writing New Tests

1. Create a new spec file in `specs/` directory
2. Import Playwright test utilities:
```javascript
const { test, expect } = require('@playwright/test');
```

3. Use the login helper function:
```javascript
async function login(page) {
  await page.goto('/login');
  await page.fill('input[name="username"]', 'admin');
  await page.fill('input[name="password"]', 'admin123');
  await page.click('button[type="submit"]');
  await page.waitForURL(/.*home.*/);
}
```

4. Write your tests:
```javascript
test.describe('Feature Name', () => {
  test.beforeEach(async ({ page }) => {
    await login(page);
  });

  test('should do something', async ({ page }) => {
    // Your test code
  });
});
```

## CI/CD Integration

To run tests in CI/CD pipeline:
```bash
# Set CI environment variable
CI=true npm test
```

This will:
- Run tests in headless mode
- Retry failed tests 2 times
- Run tests sequentially (not in parallel)
- Generate HTML report

## Resources

- [Playwright Documentation](https://playwright.dev)
- [Playwright Best Practices](https://playwright.dev/docs/best-practices)
- [Playwright API Reference](https://playwright.dev/docs/api/class-playwright)

