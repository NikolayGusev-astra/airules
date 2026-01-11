# 🚀 Продвинутые паттерны для E2E Testing Expert Skill

---

## ⚡ Visual Regression Testing

```typescript
// tests/e2e/visual.spec.ts
import { test, expect } from '@playwright/test'

test('visual regression', async ({ page }) => {
  await page.goto('https://example.com')
  await expect(page).toHaveScreenshot('homepage.png', {
    maxDiffPixels: 100
  })
})
```

## 🔄 API Testing

```typescript
// tests/api/api.spec.ts
import { test, request } from '@playwright/test'

test('API endpoint returns correct data', async ({ request }) => {
  const response = await request.get('/api/users')
  expect(response.ok()).toBeTruthy()
  const data = await response.json()
  expect(data).toHaveLength(10)
})
```

## 🎭 Data-Driven Testing

```typescript
// tests/e2e/data-driven.spec.ts
import { test } from '@playwright/test'

const testData = [
  { username: 'user1', password: 'pass1' },
  { username: 'user2', password: 'pass2' }
]

for (const { username, password } of testData) {
  test(`login with ${username}`, async ({ page }) => {
    await page.goto('/login')
    await page.fill('[name="username"]', username)
    await page.fill('[name="password"]', password)
    await page.click('button[type="submit"]')
    await expect(page).toHaveURL('/dashboard')
  })
}