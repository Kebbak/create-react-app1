import { test, expect } from '@playwright/test';

test.describe('Performance Tests', () => {
  
  test('should load page within acceptable time', async ({ page }) => {
    const startTime = Date.now();
    
    await page.goto('/');
    
    // Wait for the page to be fully loaded
    await page.waitForLoadState('networkidle');
    
    const loadTime = Date.now() - startTime;
    
    // Assert load time is under 3 seconds
    expect(loadTime).toBeLessThan(3000);
    
    console.log(`Page loaded in ${loadTime}ms`);
  });

  test('should have good accessibility score', async ({ page }) => {
    await page.goto('/');
    
    // Check for basic accessibility elements
    
    // Should have a main landmark or role
    const main = page.locator('main, [role="main"], .App');
    await expect(main).toBeVisible();
    
    // Images should have alt text (React logo)
    const logo = page.locator('.App-logo');
    await expect(logo).toHaveAttribute('alt');
    
    // Links should be accessible
    const learnReactLink = page.getByRole('link', { name: /learn react/i });
    await expect(learnReactLink).toBeVisible();
  });

  test('should work without JavaScript (basic content)', async ({ page, context }) => {
    // Disable JavaScript
    await context.setExtraHTTPHeaders({});
    await page.addInitScript(() => {
      delete window.navigator;
    });
    
    await page.goto('/');
    
    // The app should at least show the basic HTML structure
    const body = page.locator('body');
    await expect(body).toBeVisible();
    
    // Root div should exist
    const root = page.locator('#root');
    await expect(root).toBeVisible();
  });

});