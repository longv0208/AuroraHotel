// @ts-check
const { test, expect } = require('@playwright/test');

/**
 * Smoke tests to verify server is running
 */

test.describe('Smoke Tests', () => {
  
  test('Server should be running and accessible', async ({ page }) => {
    const response = await page.goto('/');
    expect(response.status()).toBeLessThan(400);
  });

  test('Login page should be accessible', async ({ page }) => {
    await page.goto('/login');
    await expect(page).toHaveTitle(/Aurora Hotel/);
    await expect(page.locator('h2')).toContainText('Aurora Hotel');
  });

  test('Login page should have username and password fields', async ({ page }) => {
    await page.goto('/login');
    
    // Check for username field
    const usernameField = page.locator('input[name="username"]');
    await expect(usernameField).toBeVisible();
    
    // Check for password field
    const passwordField = page.locator('input[name="password"]');
    await expect(passwordField).toBeVisible();
    
    // Check for submit button
    const submitButton = page.locator('button[type="submit"]');
    await expect(submitButton).toBeVisible();
  });
});

