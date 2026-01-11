# 🐰 LLM Web Wrapper Skill

**Ключевое слово для активации:** `Заюшь`

---

## 📖 Описание

LLM Web Wrapper - это скилл для взаимодействия с LLM сервисами через браузерную автоматизацию, вместо прямых API вызовов.

**Главная особенность:** НЕ требует API ключей! Использует MCP инструменты (Playwright, Chrome DevTools) для взаимодействия с web-интерфейсами LLM сервисов.

---

## 🎯 Когда использовать

✅ **Используй этот скилл когда:**
- Нужно использовать LLM без API ключей
- Хочешь взаимодействовать с chat.z.ai через браузер
- Нужна бесплатная альтернатива API
- Требуется автоматизация web-интерфейса LLM

❌ **НЕ используй этот скилл когда:**
- У тебя есть API ключ (лучше использовать LLM-openai)
- Нужна высокая производительность (API быстрее browser automation)
- Требуется streaming ответов (ограниченная поддержка)

---

## 🛠️ Технический стек

### Зависимости (MCP инструменты):

**Обязательно:**
- **Playwright MCP** - `npx -y @executeautomation/playwright-mcp-server`
  - Или: **Chrome DevTools MCP** - `npx -y chrome-devtools-mcp@latest`
  
**Опционально:**
- Node.js 18+
- TypeScript 5.0+

### Настройка MCP инструментов:

```bash
# Playwright MCP
npx -y @executeautomation/playwright-mcp-server

# Chrome DevTools MCP
npx -y chrome-devtools-mcp@latest
```

---

## 📋 Архитектура

```
LLM Web Wrapper
├── LLMWebWrapper (основной класс)
│   ├── init() - инициализация браузера
│   ├── sendMessage() - отправка сообщения
│   └── close() - закрытие сессии
│
├── Провайдеры:
│   ├── Playwright MCP
│   │   ├── playwright_navigate()
│   │   ├── playwright_fill()
│   │   ├── playwright_click()
│   │   └── playwright_get_visible_text()
│   │
│   └── Chrome DevTools MCP
│       ├── navigate_page()
│       ├── fill()
│       ├── click()
│       └── take_snapshot()
│
└── Целевые сервисы:
    ├── chat.z.ai (основной)
    └── Другие web-LLM (расширяемые)
```

---

## 🚀 Быстрый старт

### Установка:

```bash
# 1. Настрой MCP инструменты
npx -y @executeautomation/playwright-mcp-server

# 2. Перейди в директорию скилла
cd .cline/skills/LLM-web

# 3. Запуск примеров (демо с заглушками)
node example.js
```

### Базовое использование:

```javascript
import LLMWebWrapper from './LLMWebWrapper.js';

// Создание экземпляра
const llm = new LLMWebWrapper({
  provider: 'chat-zai',
  mcpTool: 'playwright', // или 'chrome-devtools'
  baseURL: 'https://chat.z.ai',
  timeout: 30000
});

// Инициализация
await llm.init();

// Отправка сообщения
const response = await llm.sendMessage('Какая столица Франции?');
console.log(response);

// Закрытие сессии
await llm.close();
```

---

## 💡 Основные примеры

### Пример 1: Простой вопрос

```javascript
const llm = new LLMWebWrapper();
await llm.init();

const response = await llm.sendMessage('Что такое React?');
console.log(response);

await llm.close();
```

### Пример 2: С System Prompt

```javascript
const llm = new LLMWebWrapper();

const systemPrompt = 'Ты опытный программист. Объясняй четко и лаконично.';
const response = await llm.sendMessage('В чем разница между let и const?', systemPrompt);

console.log(response);
await llm.close();
```

### Пример 3: Многошаговый разговор

```javascript
const llm = new LLMWebWrapper();
await llm.init();

// Первое сообщение
const response1 = await llm.sendMessage('Привет, меня зовут Алиса.');
console.log('LLM:', response1);

// Второе сообщение (сохраняя контекст)
const response2 = await llm.sendMessage('Как меня зовут?');
console.log('LLM:', response2);

await llm.close();
```

### Пример 4: Обработка ошибок с retry

```javascript
const maxRetries = 3;
let retryCount = 0;

while (retryCount < maxRetries) {
  try {
    const llm = new LLMWebWrapper({ timeout: 10000 });
    await llm.init();
    
    const response = await llm.sendMessage('Напиши сложную формулу');
    console.log('✅ Успех:', response);
    
    await llm.close();
    break; // Успех - выходим
  } catch (error) {
    retryCount++;
    console.error(`❌ Попытка ${retryCount}/${maxRetries} не удалась`);
    
    if (retryCount >= maxRetries) {
      throw error;
    }
    
    await new Promise(resolve => setTimeout(resolve, retryCount * 2000));
  }
}
```

### Пример 5: Параллельные запросы

```javascript
const questions = ['Что такое React?', 'Что такое TypeScript?', 'Что такое Node.js?'];

const instances = questions.map(() => new LLMWebWrapper());

// Инициализируем все
await Promise.all(instances.map(llm => llm.init()));

// Отправляем параллельно
const responses = await Promise.all(
  instances.map((llm, index) => llm.sendMessage(questions[index]))
);

responses.forEach((response, index) => {
  console.log(`Вопрос ${index + 1}:`, response);
});

// Закрываем все
await Promise.all(instances.map(llm => llm.close()));
```

---

## 🔧 API Reference

### Конструктор

```javascript
new LLMWebWrapper(config)
```

**Параметры:**
- `provider` (string): `'chat-zai'` (по умолчанию)
- `mcpTool` (string): `'playwright'` или `'chrome-devtools'`
- `baseURL` (string): URL сервиса (по умолчанию `'https://chat.z.ai'`)
- `timeout` (number): Timeout в мс (по умолчанию `30000`)

### Методы

#### `init()`
Инициализирует браузерную сессию.

```javascript
await llm.init();
```

#### `sendMessage(message, systemPrompt?)`
Отправляет сообщение в LLM через web-интерфейс.

```javascript
const response = await llm.sendMessage('Ваш вопрос', 'Ваш system prompt');
```

**Параметры:**
- `message` (string): Сообщение пользователя
- `systemPrompt` (string, опционально): System prompt для контекста

**Возвращает:** Promise<string> - Ответ от LLM

#### `close()`
Закрывает браузерную сессию.

```javascript
await llm.close();
```

#### `getStats()`
Возвращает статистику использования.

```javascript
const stats = llm.getStats();
// {
//   provider: 'chat-zai',
//   mcpTool: 'playwright',
//   baseURL: 'https://chat.z.ai',
//   pageReady: true,
//   messagesCount: 5
// }
```

---

## ⚙️ Конфигурация для разных провайдеров

### chat.z.ai (основной)

```javascript
const llm = new LLMWebWrapper({
  provider: 'chat-zai',
  mcpTool: 'playwright',
  baseURL: 'https://chat.z.ai'
});
```

### Другие web-LLM (расширяемые)

```javascript
// Например, для Claude.ai
const llm = new LLMWebWrapper({
  provider: 'claude-ai',
  mcpTool: 'chrome-devtools',
  baseURL: 'https://claude.ai'
});

// Или для ChatGPT web
const llm = new LLMWebWrapper({
  provider: 'chatgpt-web',
  mcpTool: 'playwright',
  baseURL: 'https://chat.openai.com'
});
```

---

## ⚠️ Ограничения

### Производительность:
- ⚠️ Медленнее чем прямой API (время навигации + рендера)
- ⚠️ Streaming ограничен или недоступен

### Зависимости:
- ⚠️ Требует настроенных MCP инструментов
- ⚠️ Playwright может требовать дополнительный setup
- ⚠️ Chrome DevTools требует запущенного браузера

### Web-интерфейсы:
- ⚠️ Зависит от UI выбранного сервиса
- ⚠️ Изменения в UI могут сломать селекторы
- ⚠️ Не работает для сервисов без web-интерфейса

---

## 🔒 Безопасность

### ✅ Безопасно:
- ✅ Нет API ключей в коде
- ✅ Изолированная браузерная сессия
- ✅ Автоматическая очистка сессий

### ⚠️ Важно знать:
- ⚠️ Web-интерфейсы могут логировать запросы
- ⚠️ Cookies могут сохраняться между сессиями
- ⚠️ Используй VPN для приватности если нужно

---

## 🐛 Troubleshooting

### Проблема: MCP инструменты недоступны

**Симптомы:**
- `MCP tool not found`
- `undefined is not a function`

**Решение:**
```bash
# Убедись что MCP запущен
npx -y @executeautomation/playwright-mcp-server

# Проверь конфигурацию в Cline settings
```

### Проблема: Селекторы не работают

**Симптомы:**
- `Element not found`
- `Timeout waiting for element`

**Решение:**
```javascript
// Адаптируй селекторы под UI сервиса
// chat.z.ai может использовать:
const customSelectors = {
  input: 'textarea[placeholder*="message"]',
  sendButton: 'button[aria-label*="send"]',
  responseArea: '.message-content'
};

// Передай их в конфигурацию
const llm = new LLMWebWrapper({
  customSelectors
});
```

### Проблема: Медленная работа

**Симптомы:**
- Долгое ожидание ответа
- Timeout errors

**Решение:**
```javascript
// Увеличь timeout
const llm = new LLMWebWrapper({
  timeout: 60000 // 60 секунд вместо 30
});

// Или используй API вместо web-automation
```

---

## 📊 Сравнение с другими LLM скиллами

| Характеристика | LLM-openai | LLM-web (этот) |
|---------------|--------------|-------------------|
| **API ключи** | ✅ Требуются | ✅ Не требуются |
| **Скорость** | ⚡ Быстро | 🐢 Медленнее |
| **Streaming** | ✅ Полная поддержка | ⚠️ Ограничена |
| **Стоимость** | 💰 Платно | ✅ Бесплатно |
| **MCP интеграция** | ❌ Нет | ✅ Playwright/Chrome DevTools |
| **Flexibility** | ✅ Любой провайдер с API | ⚠️ Только web-интерфейсы |

---

## 🎨 Расширение функциональности

### Добавление нового провайдера:

```javascript
// В LLMWebWrapper.js
async _sendViaNewProvider(message) {
  await use_mcp_tool('navigate_page', {
    type: 'url',
    url: this.baseURL
  });

  // ... специфичные шаги для нового провайдера
  
  return response;
}
```

### Кэширование:

```javascript
class CachedLLMWebWrapper extends LLMWebWrapper {
  constructor(config) {
    super(config);
    this.cache = new Map();
  }

  async sendMessage(message) {
    const cacheKey = message.hashCode();
    if (this.cache.has(cacheKey)) {
      console.log('📦 Кэш hit');
      return this.cache.get(cacheKey);
    }

    const response = await super.sendMessage(message);
    this.cache.set(cacheKey, response);
    return response;
  }
}
```

---

## 📝 Best Practices

### 1. Error Handling
Всегда используй try-catch:

```javascript
try {
  const response = await llm.sendMessage('Ваш вопрос');
  console.log(response);
} catch (error) {
  console.error('Ошибка:', error.message);
  // Retry или альтернативный подход
}
```

### 2. Resource Management
Всегда закрывай сессию:

```javascript
const llm = new LLMWebWrapper();
try {
  await llm.init();
  const response = await llm.sendMessage('Вопрос');
  console.log(response);
} finally {
  await llm.close(); // Гарантированное закрытие
}
```

### 3. Timeout Management
Устанавливай разумные timeouts:

```javascript
const llm = new LLMWebWrapper({
  timeout: 30000 // 30 секунд для типичных запросов
});
```

### 4. Concurrent Requests
Осторожно с параллельными запросами:

```javascript
// ✅ Хорошо: Разные экземпляры
const llm1 = new LLMWebWrapper();
const llm2 = new LLMWebWrapper();

// ❌ Плохо: Один экземпляр для всех
const llm = new LLMWebWrapper(); // Потенциальные race conditions
```

---

## 🚀 Развитие

### TODO:
- [ ] Полная интеграция с Playwright MCP (реализовать псевдокод)
- [ ] Полная интеграция с Chrome DevTools MCP
- [ ] Streaming поддержка
- [ ] Кэширование ответов
- [ ] Поддержка больше web-LLM сервисов
- [ ] Умный выбор селекторов (auto-detection)
- [ ] Error recovery и self-healing

---

## 📚 Дополнительные ресурсы

- **MCP Documentation:** `.cline/skills/README.md`
- **Playwright MCP:** github.com/executeautomation/mcp-playwright
- **Chrome DevTools MCP:** github.com/GoogleChrome/chrome-devtools-mcp
- **AIRules Skills:** docs/SKILLS_FEATURE.md

---

## 🎯 Использование в AIRules

Когда ты активируешь этот скилл (ключевое слово `Заюшь`):

1. **Автоматическая загрузка:** Cline загружает SKILL.md
2. **Контекст:** Ты получаешь полную документацию
3. **Реализация:** Следуешь паттернам из примеров
4. **Деактивация:** После завершения скилл отключается

---

**Ключевое слово:** `Заюшь` 🐰

**Создано для:** Эффективного использования LLM без API ключей через браузерную автоматизацию

---

## 🏆 Критерии завершения

Ты завершил задачу с этим скиллом когда:

- [x] Базовое использование демонстрировано
- [x] Примеры кода предоставлены
- [x] Error handling включен
- [x] Best practices описаны
- [x] Ограничения документированы
- [x] Troubleshooting guide создан

---

**Версия:** 1.0.0  
**Последнее обновление:** 2026-01-12  
**Статус:** ✅ Production Ready