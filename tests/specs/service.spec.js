// @ts-check
const { test, expect } = require('@playwright/test');

/**
 * Service Management CRUD Tests
 * Tests all CRUD operations for Service Management feature
 */

// Test data
const testService = {
  name: 'Playwright Test Service',
  category: 'Giải trí',
  price: '150000',
  unit: 'lần',
  description: 'Dịch vụ test tự động bằng Playwright'
};

const updatedService = {
  name: 'Updated Test Service',
  category: 'Spa & Massage',
  price: '250000',
  unit: 'giờ',
  description: 'Dịch vụ đã được cập nhật'
};

// Login helper function
async function login(page) {
  await page.goto('/login');
  await page.fill('input[name="username"]', 'admin');
  await page.fill('input[name="password"]', 'admin123');
  await page.click('button[type="submit"]');
  
  // Wait for navigation to complete
  await page.waitForURL(/.*home.*/);
}

test.describe('Service Management CRUD Operations', () => {
  
  test.beforeEach(async ({ page }) => {
    // Login before each test
    await login(page);
  });

  test('1. Should navigate to Service Management page', async ({ page }) => {
    // Click on Management dropdown
    await page.click('#adminDropdown');
    
    // Click on Service Management link
    await page.click('a:has-text("Service Management")');
    
    // Verify we're on the service list page
    await expect(page).toHaveURL(/.*service.*view=list.*/);
    await expect(page.locator('h2')).toContainText('Quản lý dịch vụ');
  });

  test('2. Should display service list with table', async ({ page }) => {
    await page.goto('/service?view=list');
    
    // Check if table exists
    const table = page.locator('table');
    await expect(table).toBeVisible();
    
    // Check table headers
    await expect(page.locator('th:has-text("Tên dịch vụ")')).toBeVisible();
    await expect(page.locator('th:has-text("Danh mục")')).toBeVisible();
    await expect(page.locator('th:has-text("Giá")')).toBeVisible();
    await expect(page.locator('th:has-text("Đơn vị")')).toBeVisible();
  });

  test('3. Should create a new service', async ({ page }) => {
    await page.goto('/service?view=list');
    
    // Click "Add new service" button
    await page.click('a:has-text("Thêm dịch vụ mới")');
    
    // Verify we're on create page
    await expect(page).toHaveURL(/.*service.*view=create.*/);
    await expect(page.locator('h2')).toContainText('Thêm dịch vụ mới');
    
    // Fill in the form
    await page.fill('input[name="serviceName"]', testService.name);
    await page.selectOption('select[name="category"]', testService.category);
    await page.fill('input[name="price"]', testService.price);
    await page.fill('input[name="unit"]', testService.unit);
    await page.fill('textarea[name="description"]', testService.description);
    
    // Submit the form
    await page.click('button[type="submit"]');
    
    // Verify redirect to list page with success message
    await expect(page).toHaveURL(/.*service.*view=list.*created=1.*/);
    await expect(page.locator('.alert-success')).toContainText('Tạo dịch vụ thành công');
    
    // Verify the service appears in the list
    await expect(page.locator(`td:has-text("${testService.name}")`)).toBeVisible();
  });

  test('4. Should edit an existing service', async ({ page }) => {
    await page.goto('/service?view=list');
    
    // Find the test service and click edit button
    const serviceRow = page.locator(`tr:has-text("${testService.name}")`);
    await expect(serviceRow).toBeVisible();
    
    await serviceRow.locator('a[title="Sửa"]').click();
    
    // Verify we're on edit page
    await expect(page).toHaveURL(/.*service.*view=edit.*/);
    await expect(page.locator('h2')).toContainText('Chỉnh sửa dịch vụ');
    
    // Verify form is pre-filled
    await expect(page.locator('input[name="serviceName"]')).toHaveValue(testService.name);
    
    // Update the form
    await page.fill('input[name="serviceName"]', updatedService.name);
    await page.selectOption('select[name="category"]', updatedService.category);
    await page.fill('input[name="price"]', updatedService.price);
    await page.fill('input[name="unit"]', updatedService.unit);
    await page.fill('textarea[name="description"]', updatedService.description);
    
    // Submit the form
    await page.click('button[type="submit"]');
    
    // Verify redirect to list page with success message
    await expect(page).toHaveURL(/.*service.*view=list.*updated=1.*/);
    await expect(page.locator('.alert-success')).toContainText('Cập nhật dịch vụ thành công');
    
    // Verify the updated service appears in the list
    await expect(page.locator(`td:has-text("${updatedService.name}")`)).toBeVisible();
  });

  test('5. Should view service details on edit page', async ({ page }) => {
    await page.goto('/service?view=list');
    
    // Find the updated test service and click edit
    const serviceRow = page.locator(`tr:has-text("${updatedService.name}")`);
    await serviceRow.locator('a[title="Sửa"]').click();
    
    // Verify all fields are correctly displayed
    await expect(page.locator('input[name="serviceName"]')).toHaveValue(updatedService.name);
    await expect(page.locator('select[name="category"]')).toHaveValue(updatedService.category);
    await expect(page.locator('input[name="price"]')).toHaveValue(updatedService.price);
    await expect(page.locator('input[name="unit"]')).toHaveValue(updatedService.unit);
    await expect(page.locator('textarea[name="description"]')).toHaveValue(updatedService.description);
    
    // Verify active status checkbox
    await expect(page.locator('input[name="isActive"]')).toBeChecked();
  });

  test('6. Should toggle service active status', async ({ page }) => {
    await page.goto('/service?view=list');
    
    // Find the test service and click edit
    const serviceRow = page.locator(`tr:has-text("${updatedService.name}")`);
    await serviceRow.locator('a[title="Sửa"]').click();
    
    // Uncheck active status
    await page.uncheck('input[name="isActive"]');
    
    // Submit the form
    await page.click('button[type="submit"]');
    
    // Verify redirect to list page
    await expect(page).toHaveURL(/.*service.*view=list.*updated=1.*/);
    
    // Verify the service shows as inactive
    const updatedRow = page.locator(`tr:has-text("${updatedService.name}")`);
    await expect(updatedRow.locator('.badge:has-text("Ngừng")')).toBeVisible();
  });

  test('7. Should delete a service (soft delete)', async ({ page }) => {
    await page.goto('/service?view=list');
    
    // Find the test service and click delete button
    const serviceRow = page.locator(`tr:has-text("${updatedService.name}")`);
    await expect(serviceRow).toBeVisible();
    
    await serviceRow.locator('a[title="Xóa"]').click();
    
    // Verify we're on delete confirmation page
    await expect(page).toHaveURL(/.*service.*view=delete.*/);
    await expect(page.locator('h2')).toContainText('Xóa dịch vụ');
    
    // Verify service details are shown
    await expect(page.locator(`td:has-text("${updatedService.name}")`)).toBeVisible();
    
    // Confirm deletion
    await page.click('button:has-text("Xác nhận xóa")');
    
    // Verify redirect to list page with success message
    await expect(page).toHaveURL(/.*service.*view=list.*deleted=1.*/);
    await expect(page.locator('.alert-success')).toContainText('Xóa dịch vụ thành công');
  });

  test('8. Should validate required fields on create', async ({ page }) => {
    await page.goto('/service?view=create');
    
    // Try to submit empty form
    await page.click('button[type="submit"]');
    
    // HTML5 validation should prevent submission
    // Check if we're still on create page
    await expect(page).toHaveURL(/.*service.*view=create.*/);
  });

  test('9. Should validate price is non-negative', async ({ page }) => {
    await page.goto('/service?view=create');
    
    // Fill form with negative price
    await page.fill('input[name="serviceName"]', 'Test Negative Price');
    await page.selectOption('select[name="category"]', 'Khác');
    await page.fill('input[name="price"]', '-1000');
    
    // HTML5 validation should prevent submission
    await page.click('button[type="submit"]');
    
    // Should still be on create page
    await expect(page).toHaveURL(/.*service.*view=create.*/);
  });

  test('10. Should handle pagination if more than 10 services', async ({ page }) => {
    await page.goto('/service?view=list');
    
    // Check if pagination exists
    const pagination = page.locator('.pagination');
    
    // If pagination exists, test it
    if (await pagination.isVisible()) {
      // Click on page 2 if it exists
      const page2Link = page.locator('.page-link:has-text("2")');
      if (await page2Link.isVisible()) {
        await page2Link.click();
        await expect(page).toHaveURL(/.*page=2.*/);
      }
    }
  });

  test('11. Should cancel create operation', async ({ page }) => {
    await page.goto('/service?view=create');
    
    // Fill some data
    await page.fill('input[name="serviceName"]', 'Test Cancel');
    
    // Click cancel button
    await page.click('a:has-text("Hủy")');
    
    // Should redirect back to list
    await expect(page).toHaveURL(/.*service.*view=list.*/);
  });

  test('12. Should cancel edit operation', async ({ page }) => {
    await page.goto('/service?view=list');
    
    // Click edit on any service
    const firstEditButton = page.locator('a[title="Sửa"]').first();
    if (await firstEditButton.isVisible()) {
      await firstEditButton.click();
      
      // Click cancel
      await page.click('a:has-text("Hủy")');
      
      // Should redirect back to list
      await expect(page).toHaveURL(/.*service.*view=list.*/);
    }
  });

  test('13. Should cancel delete operation', async ({ page }) => {
    await page.goto('/service?view=list');
    
    // Click delete on any service
    const firstDeleteButton = page.locator('a[title="Xóa"]').first();
    if (await firstDeleteButton.isVisible()) {
      await firstDeleteButton.click();
      
      // Click back button
      await page.click('a:has-text("Quay lại")');
      
      // Should redirect back to list
      await expect(page).toHaveURL(/.*service.*view=list.*/);
    }
  });
});

