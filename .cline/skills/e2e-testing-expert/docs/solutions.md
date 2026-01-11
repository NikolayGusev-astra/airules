# 💡 Решения для E2E Testing Expert Skill

## 🚀 Базовая настройка Playwright

```typescript
// tests/e2e/example.spec.ts
import { test, expect } from '@playwright/test'

test('homepage has title', async ({ page }) => {
  await page.goto('https://example.com')
  await expect(page).toHaveTitle(/Example Domain/)
})
```

## 🔄 Page Object Model

```typescript
// pages/LoginPage.ts
export class LoginPage {
  constructor(private page: Page) {}
  
  async login(username: string, password: string) {
    await this.page.fill('[name="username"]', username)
    await this.page.fill('[name="password"]', password)
    await this.page.click('button[type="submit"]')
  }
}

// tests/e2e/login.spec.ts
test('user can login', async ({ page }) => {
  const loginPage = new LoginPage(page)
  await loginPage.login('user', 'pass')
  await expect(page).toHaveURL(/dashboard/)
})
```

## 📊 CI/CD Integration

```yaml
name: E2E Tests
on: [push]
jobs:
  test:
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
      - run: npm ci
      - run: npx playwright install --with-deps
      - run: npm run test:e2e
      - uses: actions/upload-artifact@v3
        with:
          name: playwright-report
          path: playwright-report/