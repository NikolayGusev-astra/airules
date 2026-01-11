# ⚠️ Известные проблемы для E2E Testing Expert Skill

Этот файл содержит известные проблемы и их решения для E2E тестирования.

---

## 🔥 Критические проблемы

### Проблема: Тесты нестабильны (flaky)

**Симптомы:**
- Тесты проходят иногда, иногда нет
- Нет явной причины неудачи
- Flaky тесты в CI/CD

**Причины:**
1. Отсутствие ожидания (waits)
2. Асинхронные операции не завершены
3. Состояние гонки (race conditions)
4. Сетевые задержки

**Решения:**
```typescript
// ✅ Правильно (с ожиданием)
await page.waitForSelector('.button', { timeout: 5000 });
await page.click('.button');
await expect(page.locator('.result')).toBeVisible();

// ❌ Неправильно (без ожидания)
await page.click('.button');
expect(page.locator('.result')).toBeVisible();
```

**Полезные ссылки:**
- [Playwright Best Practices](https://playwright.dev/docs/best-practices)
- [Context7: E2E Testing](https://www.context7.ai)

---

### Проблема: Таймаут теста

**Симптомы:**
- Ошибка: "Timeout exceeded"
- Тесты не завершаются
- Long-running tests

**Причины:**
1. Слишком короткий таймаут
2. Медленный API/база данных
3. Бесконечный цикл

**Решения:**
```typescript
// ✅ Увеличить таймаут
test('slow operation', async ({ page }) => {
  test.setTimeout(30000);  // 30 секунд
  
  await page.goto('/slow-page');
  await expect(page.locator('.content')).toBeVisible();
});
```

**Полезные ссылки:**
- [Playwright Timeouts](https://playwright.dev/docs/test-timeouts)
- [Context7: Test Optimization](https://www.context7.ai)

---

## ⚠️ Общие проблемы

### Проблема: Селекторы нестабильны

**Симптомы:**
- Не может найти элемент
- Селектор работает иногда
- Ошибка: "Element not found"

**Причины:**
1. Использование хрупких селекторов (CSS classes)
2. Динамические ID
3. Изменения DOM между действиями

**Решения:**
```typescript
// ✅ Правильно (стабильные селекторы)
await page.locator('button:has-text("Submit")').click();
await page.locator('[data-testid="submit-button"]').click();

// ❌ Неправильно (хрупкие селекторы)
await page.locator('.btn-primary-lg.active').click();
```

**Полезные ссылки:**
- [Playwright Selectors](https://playwright.dev/docs/selectors)
- [Context7: Stable Selectors](https://www.context7.ai)

---

### Проблема: CI/CD интеграция не работает

**Симптомы:**
- Тесты работают локально, но не в CI
- Ошибка: "Browser not found"
- Display problems

**Причины:**
1. CI среда без GUI
2. Отсутствие xvfb для headless
3. Неправильная конфигурация

**Решения:**
```yaml
# ✅ GitHub Actions конфигурация
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
      - run: npm ci
      - run: npx playwright install --with-deps
      - run: npx playwright test
```

**Полезные ссылки:**
- [Playwright CI/CD](https://playwright.dev/docs/ci)
- [Context7: CI Integration](https://www.context7.ai)

---

### Проблема: Тесты покрывают не все сценарии

**Симптомы:**
- Пропускаются важные функции
- Нет тестов для edge cases
- Низкое покрытие

**Причины:**
1. Фокус только на happy path
2. Нет тестов для ошибочных ситуаций
3. Неполные user stories

**Решения:**
```typescript
// ✅ Проверить все сценарии
describe('User Login', () => {
  test('success with valid credentials', async () => {
    // Happy path
  });

  test('fail with invalid password', async () => {
    // Error case
  });

  test('fail with locked account', async () => {
    // Edge case
  });

  test('fail with network error', async () => {
    // Network failure
  });
});
```

**Полезные ссылки:**
- [Test Coverage](https://playwright.dev/docs/test-codegen)
- [Context7: Test Design](https://www.context7.ai)

---

## 📚 Дополнительные ресурсы

- [Playwright Documentation](https://playwright.dev)
- [Test Best Practices](https://kentcdodds.com/blog/common-testing-mistakes)
- [Context7: E2E Testing](https://www.context7.ai)