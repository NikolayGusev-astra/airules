# 🔍 Chrome MCP Integration

Полное руководство по использованию Chrome MCP для E2E тестирования и автоматизации браузера через AI.

## 📖 Оглавление

- [Что такое Chrome MCP](#что-такое-chrome-mcp)
- [Установка и настройка](#установка-и-настройка)
- [Основные команды](#основные-команды)
- [Паттерны использования](#паттерны-использования)
- [Лучшие практики](#лучшие-практики)
- [Интеграция с ролями](#интеграция-с-ролями)

## 🤔 Что такое Chrome MCP?

**Chrome MCP** (Model Context Protocol) — сервер, который позволяет AI-инструментам (Cline, Claude) управлять браузером Chrome через DevTools Protocol.

### Возможности

```
✅ Навигация по страницам
✅ Клик на элементы
✅ Заполнение форм
✅ Снимки экрана
✅ Анализ HTML (snapshots)
✅ Network requests анализ
✅ Console messages
✅ Performance profiling
✅ Эмуляция устройств
✅ Эмуляция сетевых условий
```

### Преимущества перед традиционными инструментами

| Аспект | Playwright | Chrome MCP |
|--------|------------|-------------|
| **AI Integration** | Нет | ✅ Полная интеграция |
| **Dynamic Actions** | Предопределённые | ✅ Адаптивные |
| **Error Recovery** | Скрипт ломается | ✅ AI сам исправляет |
| **Context Awareness** | Нет | ✅ Понимает контекст |
| **Debugging** | Сложно | ✅ AI объясняет ошибки |

## ⚙️ Установка и настройка

### Шаг 1: Установка Chrome MCP сервера

```bash
npm install -g @modelcontextprotocol/server-chrome-devtools
```

### Шаг 2: Подключение к Cline/Claude

В настройках Cline или Claude добавить MCP сервер:

```json
{
  "mcpServers": {
    "chrome-devtools": {
      "command": "npx",
      "args": ["-y", "chrome-devtools-mcp@latest"]
    }
  }
}
```

### Шаг 3: Запуск Chrome

Открыть Chrome с remote debugging:

```bash
# Windows
chrome.exe --remote-debugging-port=9222

# macOS
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --remote-debugging-port=9222

# Linux
google-chrome --remote-debugging-port=9222
```

## 🎮 Основные команды

### 1. Навигация

#### Открыть страницу

```javascript
// Navigate to URL
await chrome_navigate_page('type', 'url', 'url', 'https://example.com');

// Navigation history
await chrome_navigate_page('type', 'back');

await chrome_navigate_page('type', 'forward');

await chrome_navigate_page('type', 'reload', 'ignoreCache', false);
```

#### Выбрать страницу

```javascript
// Get all pages
const pages = await chrome_list_pages();

// Select page by index
await chrome_select_page('pageIdx', 0);

// Create new page
await chrome_new_page('url', 'https://example.com');
```

#### Изменить размер

```javascript
// Resize to desktop
await chrome_resize_page('width', 1920, 'height', 1080);

// Resize to mobile (iPhone 12)
await chrome_resize_page('width', 390, 'height', 844);

// Resize to tablet (iPad Pro)
await chrome_resize_page('width', 1024, 'height', 1366);
```

### 2. Взаимодействие с элементами

#### Получить snapshot

```javascript
// Take text snapshot (a11y tree)
const snapshot = await chrome_take_snapshot();

// With verbose mode
const verboseSnapshot = await chrome_take_snapshot('verbose', true);

// Save to file
await chrome_take_snapshot('filePath', './snapshot.txt');
```

#### Клик на элемент

```javascript
// Single click
await chrome_click('uid', 'element-uid');

// Double click
await chrome_click('uid', 'element-uid', 'dblClick', true);
```

#### Заполнить форму

```javascript
// Fill single field
await chrome_fill('uid', 'input-uid', 'value', 'John Doe');

// Fill multiple fields at once
await chrome_fill_form('elements', [
  { uid: 'name-input', value: 'John Doe' },
  { uid: 'email-input', value: 'john@example.com' },
  { uid: 'password-input', value: 'secret123' }
]);
```

#### Нажать клавишу

```javascript
// Single key
await chrome_press_key('key', 'Enter');

// Key combination
await chrome_press_key('key', 'Control+A');

// Arrow navigation
await chrome_press_key('key', 'ArrowDown');
```

#### Upload файл

```javascript
await chrome_upload_file('uid', 'file-input', 'filePath', '/path/to/file.pdf');
```

### 3. Ожидание и проверка

#### Ожидание текста

```javascript
// Wait for text to appear
await chrome_wait_for('text', 'Welcome');

// With timeout (ms)
await chrome_wait_for('text', 'Success', 'timeout', 10000);
```

#### Hover на элемент

```javascript
await chrome_hover('uid', 'element-uid');
```

#### Drag and Drop

```javascript
await chrome_drag('from_uid', 'source-element', 'to_uid', 'target-element');
```

### 4. Скриншоты и снимки

#### Скриншот страницы

```javascript
// Full page screenshot
await chrome_take_screenshot('fullPage', true);

// Specific element
await chrome_take_screenshot('uid', 'element-uid');

// Custom format and quality
await chrome_take_screenshot(
  'format', 'jpeg',
  'quality', 80
);

// Save to file
await chrome_take_screenshot('filePath', './screenshot.png');
```

#### Снимок элемента

```javascript
// Take snapshot of page content
const snapshot = await chrome_take_snapshot();
```

### 5. Анализ сети

#### Список запросов

```javascript
// List all network requests
const requests = await chrome_list_network_requests();

// Filter by resource type
const jsRequests = await chrome_list_network_requests('resourceTypes', ['script']);

// Pagination
const page1 = await chrome_list_network_requests('pageSize', 20, 'pageIdx', 0);
const page2 = await chrome_list_network_requests('pageSize', 20, 'pageIdx', 1);

// Include preserved requests (last 3 navigations)
const allRequests = await chrome_list_network_requests('includePreservedRequests', true);
```

#### Детали запроса

```javascript
// Get specific request
const request = await chrome_get_network_request('reqid', 123);

// Get currently selected request
const selectedRequest = await chrome_get_network_request();
```

### 6. Console сообщения

#### Список сообщений

```javascript
// List all console messages
const messages = await chrome_list_console_messages();

// Filter by type
const errors = await chrome_list_console_messages('types', ['error']);
const warnings = await chrome_list_console_messages('types', ['warn']);

// Pagination
const page1 = await chrome_list_console_messages('pageSize', 50, 'pageIdx', 0);

// Include preserved messages
const allMessages = await chrome_list_console_messages('includePreservedMessages', true);
```

#### Детали сообщения

```javascript
// Get specific message
const message = await chrome_get_console_message('msgid', 456);
```

### 7. Эмуляция

#### Сетевые условия

```javascript
// Emulate Slow 3G
await chrome_emulate('networkConditions', 'Slow 3G');

// Emulate Fast 4G
await chrome_emulate('networkConditions', 'Fast 4G');

// No emulation
await chrome_emulate('networkConditions', 'No emulation');

// Offline
await chrome_emulate('networkConditions', 'Offline');
```

#### CPU throttling

```javascript
// CPU slowdown (1x = no throttling, 20x = max)
await chrome_emulate('cpuThrottlingRate', 4);
```

#### Geolocation

```javascript
// Set geolocation
await chrome_emulate('geolocation', {
  'latitude': 55.7558,
  'longitude': 37.6176
});

// Clear geolocation
await chrome_emulate('geolocation', null);
```

### 8. Performance

#### Запуск trace

```javascript
// Start trace with reload
await chrome_performance_start_trace('reload', true, 'autoStop', true);

// Start trace without reload
await chrome_performance_start_trace('reload', false, 'autoStop', false);
```

#### Остановка trace

```javascript
// Stop trace and get results
const results = await chrome_performance_stop_trace();
```

#### Анализ insight

```javascript
// Analyze specific insight
await chrome_performance_analyze_insight(
  'insightSetId', 'insight-set-123',
  'insightName', 'LCPBreakdown'
);
```

### 9. Диалоги браузера

#### Обработка диалогов

```javascript
// Accept dialog
await chrome_handle_dialog('action', 'accept', 'promptText', 'Hello');

// Dismiss dialog
await chrome_handle_dialog('action', 'dismiss');
```

## 🔄 Паттерны использования

### Паттерн 1: E2E User Flow

```javascript
const testUserFlow = async () => {
  // 1. Navigate to page
  await chrome_navigate_page('type', 'url', 'url', 'https://app.example.com/login');
  
  // 2. Take snapshot to see elements
  const snapshot = await chrome_take_snapshot();
  console.log('Page snapshot:', snapshot);
  
  // 3. Fill login form
  await chrome_fill_form('elements', [
    { uid: 'email-input', value: 'user@example.com' },
    { uid: 'password-input', value: 'password123' }
  ]);
  
  // 4. Submit form
  await chrome_click('uid', 'submit-button');
  
  // 5. Wait for success
  await chrome_wait_for('text', 'Welcome back!');
  
  // 6. Take screenshot
  await chrome_take_screenshot('filePath', './login-success.png');
  
  // 7. Check for console errors
  const messages = await chrome_list_console_messages('types', ['error']);
  if (messages.length > 0) {
    console.error('Console errors found:', messages);
  }
};
```

### Паттерн 2: Performance Testing

```javascript
const testPerformance = async () => {
  // 1. Navigate to page
  await chrome_navigate_page('type', 'url', 'url', 'https://app.example.com');
  
  // 2. Start performance trace
  await chrome_performance_start_trace('reload', false, 'autoStop', true);
  
  // 3. Navigate through app
  await chrome_click('uid', 'dashboard-link');
  await chrome_wait_for('text', 'Dashboard');
  
  await chrome_click('uid', 'profile-link');
  await chrome_wait_for('text', 'Profile');
  
  // 4. Get trace results
  const results = await chrome_performance_stop_trace();
  console.log('Performance results:', results);
  
  // 5. Analyze specific insight
  await chrome_performance_analyze_insight(
    'insightSetId', results.id,
    'insightName', 'DocumentLatency'
  );
};
```

### Паттерн 3: Network Testing

```javascript
const testNetwork = async () => {
  // 1. Navigate to page
  await chrome_navigate_page('type', 'url', 'url', 'https://app.example.com');
  
  // 2. Emulate slow network
  await chrome_emulate('networkConditions', 'Slow 3G');
  
  // 3. Perform action
  await chrome_click('uid', 'load-data-button');
  
  // 4. Wait for data to load
  await chrome_wait_for('text', 'Data loaded');
  
  // 5. Analyze network requests
  const requests = await chrome_list_network_requests();
  const apiCalls = requests.filter(req => req.url.includes('/api/'));
  
  console.log('API calls on slow 3G:', apiCalls);
  
  // 6. Reset network
  await chrome_emulate('networkConditions', 'No emulation');
};
```

### Паттерн 4: Mobile Testing

```javascript
const testMobile = async () => {
  // 1. Resize to mobile
  await chrome_resize_page('width', 390, 'height', 844);
  
  // 2. Navigate to page
  await chrome_navigate_page('type', 'url', 'url', 'https://app.example.com');
  
  // 3. Test mobile navigation
  await chrome_click('uid', 'mobile-menu-button');
  await chrome_wait_for('text', 'Menu');
  
  // 4. Take screenshot
  await chrome_take_screenshot('filePath', './mobile-view.png');
  
  // 5. Reset to desktop
  await chrome_resize_page('width', 1920, 'height', 1080);
};
```

### Паттерн 5: Error Detection

```javascript
const detectErrors = async () => {
  // 1. Navigate to page
  await chrome_navigate_page('type', 'url', 'url', 'https://app.example.com');
  
  // 2. Perform actions
  await chrome_click('uid', 'submit-button');
  
  // 3. Check console errors
  const errors = await chrome_list_console_messages('types', ['error']);
  if (errors.length > 0) {
    for (const error of errors) {
      console.error('Error found:', error);
      // Get detailed error message
      const details = await chrome_get_console_message('msgid', error.msgid);
      console.error('Error details:', details);
    }
  }
  
  // 4. Check network errors
  const requests = await chrome_list_network_requests();
  const failedRequests = requests.filter(req => 
    req.status >= 400 || req.status === 0
  );
  if (failedRequests.length > 0) {
    console.error('Failed network requests:', failedRequests);
  }
};
```

## ✨ Лучшие практики

### 1. Всегда начинать со snapshot

```javascript
// ❌ Плохо — клик без понимания страницы
await chrome_click('uid', 'submit-button');

// ✅ Хорошо — сначала понять страницу
const snapshot = await chrome_take_snapshot();
console.log('Page content:', snapshot);
await chrome_click('uid', 'submit-button');
```

### 2. Использовать wait вместо sleep

```javascript
// ❌ Плохо — статическая задержка
await new Promise(resolve => setTimeout(resolve, 2000));
await chrome_click('uid', 'element');

// ✅ Хорошо — ждать конкретного события
await chrome_wait_for('text', 'Loading complete');
await chrome_click('uid', 'element');
```

### 3. Проверять наличие ошибок

```javascript
const checkErrors = async () => {
  // Console errors
  const consoleErrors = await chrome_list_console_messages('types', ['error']);
  if (consoleErrors.length > 0) {
    throw new Error('Console errors found');
  }
  
  // Network errors
  const requests = await chrome_list_network_requests();
  const failedRequests = requests.filter(req => req.status >= 400);
  if (failedRequests.length > 0) {
    throw new Error('Network errors found');
  }
};
```

### 4. Использовать descriptive screenshot names

```javascript
// ❌ Плохо
await chrome_take_screenshot('filePath', './screenshot1.png');

// ✅ Хорошо
await chrome_take_screenshot('filePath', './login-page-initial-state.png');
await chrome_take_screenshot('filePath', './after-login-success.png');
```

### 5. Очищать состояние между тестами

```javascript
const beforeEach = async () => {
  // Clear cookies (через evaluate_script)
  await chrome_evaluate_script('function', () => {
    document.cookie.split(';').forEach(c => {
      document.cookie = c.replace(/^ +/, '').replace(/=.*/, '=;expires=' + new Date().toUTCString() + ';path=/');
    });
  });
  
  // Reload page
  await chrome_navigate_page('type', 'reload');
};
```

## 🤝 Интеграция с ролями

### QA Tester Role + Chrome MCP

```markdown
# QA Tester Role с Chrome MCP

## Твоя задача
Выполнять E2E тестирование используя Chrome MCP.

## Твой workflow

1. **Подготовка**
   ```javascript
   await chrome_navigate_page('type', 'url', 'url', 'http://localhost:3000');
   ```

2. **Тестирование**
   - Взять snapshot страницы
   - Найти элементы по uid
   - Выполнить действия
   - Проверить результат

3. **Валидация**
   - Проверить console errors
   - Проверить network requests
   - Сделать скриншот

4. **Отчет**
   - Списать все найденные ошибки
   - Приложить скриншоты
   - Предложить исправления

## Пример теста

```javascript
const testQuizFlow = async () => {
  // 1. Navigate
  await chrome_navigate_page('type', 'url', 'url', 'http://localhost:3000/quiz');
  
  // 2. Snapshot
  const snapshot = await chrome_take_snapshot();
  
  // 3. Click on option
  await chrome_click('uid', 'quiz-option-0');
  
  // 4. Submit
  await chrome_click('uid', 'submit-button');
  
  // 5. Wait for result
  await chrome_wait_for('text', 'Correct! 🎉');
  
  // 6. Check errors
  const errors = await chrome_list_console_messages('types', ['error']);
  if (errors.length > 0) {
    console.error('Errors:', errors);
  }
  
  // 7. Screenshot
  await chrome_take_screenshot('filePath', './quiz-result.png');
};
```

## Ограничения (STRICT)
- ✅ Использовать только Chrome MCP команды
- ✅ Всегда начинать со snapshot
- ✅ Использовать wait_for вместо sleep
- ❌ Не использовать Playwright/Selenium параллельно
- ❌ Не полагаться на хардкодные delays
```

### Validator Role + Chrome MCP

```markdown
# Validator Role с Chrome MCP

## Твоя задача
Проверять валидацию изменений через браузер.

## Твой workflow

1. **Проверка изменений**
   - Открыть страницу в браузере
   - Проверить что изменения работают
   - Проверить нет ли сломано

2. **Accessibility**
   - Проверить keyboard navigation
   - Проверить screen reader compatibility
   - Проверить color contrast

3. **Performance**
   - Запустить performance trace
   - Проверить Web Vitals
   - Сравнить с baseline

## Пример проверки

```javascript
const validateChanges = async () => {
  // 1. Navigate to changed page
  await chrome_navigate_page('type', 'url', 'url', 'http://localhost:3000/dashboard');
  
  // 2. Start performance trace
  await chrome_performance_start_trace('reload', false, 'autoStop', true);
  
  // 3. Navigate through features
  await chrome_click('uid', 'quiz-link');
  await chrome_wait_for('text', 'Quiz');
  
  // 4. Stop trace
  const results = await chrome_performance_stop_trace();
  console.log('Performance:', results);
  
  // 5. Check for errors
  const errors = await chrome_list_console_messages('types', ['error']);
  if (errors.length > 0) {
    throw new Error('Validation failed: Console errors found');
  }
  
  // 6. Screenshot
  await chrome_take_screenshot('filePath', './validation-result.png');
};
```
```

## 📊 Сравнение с традиционными инструментами

### Chrome MCP vs Playwright

| Feature | Playwright | Chrome MCP |
|----------|------------|-------------|
| **Setup** | npm install, config | npm install, config |
| **Code writing** | Писать тесты вручную | AI генерирует команды |
| **Debugging** | Проверять в IDE | AI объясняет ошибки |
| **Maintenance** | Обновлять тесты вручную | AI сам исправляет |
| **Context awareness** | Нет | ✅ Полная |
| **Dynamic adaptation** | Нет | ✅ Да |
| **Learning curve** | Высокая | ✅ Низкая |

### Когда использовать Chrome MCP

```
✅ Использовать Chrome MCP:
- Быстрое прототипирование E2E тестов
- Комплексная отладка через AI
- Динамические тесты (адаптивные)
- Нестандартные сценарии
- Одноразовые проверки

❌ Использовать Playwright:
- Регрессивное тестирование в CI/CD
- Стабильные тесты для production
- Множество параллельных тестов
- Требуется 100% надежность
```

## 🚀 Полный пример: Quiz Application Testing

```javascript
// Полный E2E тест для DevOps Train Quiz App
const testQuizApp = async () => {
  try {
    // ====== SETUP ======
    console.log('🚀 Starting test...');
    
    // Navigate to app
    await chrome_navigate_page('type', 'url', 'url', 'http://localhost:3000');
    
    // ====== TEST 1: Landing Page ======
    console.log('📋 Test 1: Landing page');
    const snapshot = await chrome_take_snapshot();
    if (!snapshot.includes('Start Quiz')) {
      throw new Error('Landing page missing "Start Quiz" button');
    }
    await chrome_take_screenshot('filePath', './01-landing-page.png');
    
    // ====== TEST 2: Start Quiz ======
    console.log('📋 Test 2: Start quiz');
    await chrome_click('uid', 'start-quiz-button');
    await chrome_wait_for('text', 'Question 1');
    await chrome_take_screenshot('filePath', './02-quiz-started.png');
    
    // ====== TEST 3: Answer Question ======
    console.log('📋 Test 3: Answer question');
    await chrome_click('uid', 'quiz-option-0');
    await chrome_click('uid', 'submit-button');
    await chrome_wait_for('text', 'Correct! 🎉');
    await chrome_take_screenshot('filePath', './03-correct-answer.png');
    
    // ====== TEST 4: Check XP ======
    console.log('📋 Test 4: Check XP');
    await chrome_navigate_page('type', 'url', 'url', 'http://localhost:3000/dashboard');
    await chrome_wait_for('text', 'XP:');
    const dashboardSnapshot = await chrome_take_snapshot();
    if (!dashboardSnapshot.includes('XP: 10')) {
      throw new Error('XP not updated correctly');
    }
    await chrome_take_screenshot('filePath', './04-dashboard-xp.png');
    
    // ====== TEST 5: Check Errors ======
    console.log('📋 Test 5: Check for errors');
    const errors = await chrome_list_console_messages('types', ['error']);
    if (errors.length > 0) {
      console.error('❌ Console errors found:', errors);
      for (const error of errors) {
        const details = await chrome_get_console_message('msgid', error.msgid);
        console.error('Error details:', details);
      }
    }
    
    const requests = await chrome_list_network_requests();
    const failedRequests = requests.filter(req => req.status >= 400);
    if (failedRequests.length > 0) {
      console.error('❌ Failed network requests:', failedRequests);
    }
    
    // ====== TEST 6: Performance ======
    console.log('📋 Test 6: Performance');
    await chrome_navigate_page('type', 'url', 'url', 'http://localhost:3000/quiz');
    await chrome_performance_start_trace('reload', false, 'autoStop', true);
    
    await chrome_click('uid', 'quiz-option-0');
    await chrome_click('uid', 'submit-button');
    await chrome_wait_for('text', 'Correct! 🎉');
    
    const perfResults = await chrome_performance_stop_trace();
    console.log('📊 Performance results:', perfResults);
    
    // ====== SUMMARY ======
    console.log('✅ All tests passed!');
    console.log('📸 Screenshots saved');
    console.log('📊 Performance metrics collected');
    
  } catch (error) {
    console.error('❌ Test failed:', error);
    await chrome_take_screenshot('filePath', './error-state.png');
    throw error;
  }
};

// Run test
testQuizApp();
```

## 📚 Дополнительные ресурсы

- [Chrome MCP GitHub](https://github.com/modelcontextprotocol/servers/tree/main/src/chrome-devtools)
- [DevTools Protocol](https://chromedevtools.github.io/devtools-protocol/)
- [Model Context Protocol](https://modelcontextprotocol.io)

---

**Следующая тема:** [Библиотека паттернов](./pattern-library.md)
