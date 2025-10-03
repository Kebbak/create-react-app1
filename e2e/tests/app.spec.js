import { test, expect } from '@playwright/test';

test.describe('React App E2E Tests', () => {
  
  test('should load homepage and display React logo', async ({ page }) => {
    // Navigate to the homepage
    await page.goto('/');
    
    // Check page title
    await expect(page).toHaveTitle(/React App/);
    
    // Check that the React logo is visible
    const logo = page.locator('.App-logo');
    await expect(logo).toBeVisible();
    
    // Check that the "learn react" link is present
    const learnReactLink = page.getByRole('link', { name: /learn react/i });
    await expect(learnReactLink).toBeVisible();
  });

  test('should navigate to React documentation when clicking learn react link', async ({ page }) => {
    // Navigate to homepage
    await page.goto('/');
    
    // Find and click the "Learn React" link
    const learnReactLink = page.getByRole('link', { name: /learn react/i });
    
    // Start waiting for the new page before clicking
    const pagePromise = page.context().waitForEvent('page');
    await learnReactLink.click();
    
    // Get the new page
    const newPage = await pagePromise;
    await newPage.waitForLoadState();
    
    // Verify we're on the React documentation site
    expect(newPage.url()).toContain('reactjs.org');
  });

  test('should be responsive on mobile viewport', async ({ page }) => {
    // Set mobile viewport
    await page.setViewportSize({ width: 375, height: 667 });
    
    // Navigate to homepage
    await page.goto('/');
    
    // Check that content is still visible on mobile
    const logo = page.locator('.App-logo');
    await expect(logo).toBeVisible();
    
    const header = page.locator('.App-header');
    await expect(header).toBeVisible();
  });

  test('should display correct page structure', async ({ page }) => {
    await page.goto('/');
    
    // Check main app container
    const app = page.locator('.App');
    await expect(app).toBeVisible();
    
    // Check header section
    const header = page.locator('.App-header');
    await expect(header).toBeVisible();
    
    // Check that edit instruction text is present
    const editText = page.getByText(/Edit.*and save to reload/);
    await expect(editText).toBeVisible();
  });

});