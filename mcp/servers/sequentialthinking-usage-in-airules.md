# 🧠 Sequential Thinking - Использование в AIRules

**Тип:** Документация интеграции  
**Цель:** Гид по использованию Sequential Thinking MCP в AIRules  
**Статус:** ✅ Синергия с Memory Graph и Context7

---

## 📖 Описание

Sequential Thinking — это MCP сервер для структурированного пошагового мышления. Он позволяет AI ассистентам:
- Разбивать сложные задачи на управляемые этапы
- Корректировать подходы и ревизировать предыдущие решения
- Ветвиться в альтернативные пути рассуждений
- Генерировать и верифицировать гипотезы решений

## 🎯 Синергия с другими MCP серверами

### 1. Memory Graph + Sequential Thinking

**Использование:** Проверка зависимостей перед планированием

```javascript
// ПЕРЕД планированием архитектуры:
// Проверить, какие типы используются в проекте
await use_mcp_tool("search_nodes", {
  query: "User, Auth, Transaction"
});
// → Получаем: User.ts используется в AuthService.ts, UserProfile.tsx, TransactionList.tsx

// ЗАТЕМ использовать Sequential Thinking для планирования
await use_mcp_tool("sequentialthinking", {
  thought: "User интерфейс используется в 3 файлах. Если изменить User.email → User.emailAddress, нужно будет обновить: AuthService.ts, UserProfile.tsx, TransactionList.tsx",
  nextThoughtNeeded: true,
  thoughtNumber: 1,
  totalThoughts: 5
});
```

### 2. Context7 + Sequential Thinking

**Использование:** Проверка библиотек перед включением в план

```javascript
// Шаг 1: Sequential Thinking для анализа
await use_mcp_tool("sequentialthinking", {
  thought: "Требуется библиотека для JWT аутентификации в Next.js 14. Нужно проверить какие варианты доступны и актуальны ли они.",
  nextThoughtNeeded: true,
  thoughtNumber: 1,
  totalThoughts: 6
});

// Шаг 2: Context7 для поиска и проверки
await use_mcp_tool("resolve-library-id", {
  query: "JWT authentication library for Next.js 14",
  libraryName: "next-auth"
});
// → Получаем: /nextauth/next-auth с High reputation

await use_mcp_tool("query-docs", {
  libraryId: "/nextauth/next-auth",
  query: "How to implement JWT authentication with middleware in Next.js 14"
});

// Шаг 3: Sequential Thinking для интеграции
await use_mcp_tool("sequentialthinking", {
  thought: "NextAuth v5 с middleware поддерживает JWT токены в cookies. Это соответствует требованиям безопасности и совместимо с Next.js 14. Буду использовать этот подход.",
  nextThoughtNeeded: true,
  thoughtNumber: 2,
  totalThoughts: 6
});
```

### 3. Все три вместе (Memory Graph + Context7 + Sequential Thinking)

**Пример:** Планирование сложного рефакторинга

```javascript
// ========== ФАЗА 1: ARCHITECT ===========

// 1. Проверить текущее состояние через Memory Graph
await use_mcp_tool("search_nodes", {
  query: "AuthService, User, Transaction"
});
// → Получаем граф зависимостей

// 2. Проанализировать через Sequential Thinking
await use_mcp_tool("sequentialthinking", {
  thought: "Анализирую зависимости: AuthService зависит от User, Transaction зависит от User. Если переименовать User.email → User.emailAddress, затронутся 3 файла.",
  nextThoughtNeeded: true,
  thoughtNumber: 1,
  totalThoughts: 10
});

await use_mcp_tool("sequentialthinking", {
  thought: "Создаю план: 1) Обновить User.ts, 2) Обновить AuthService.ts, 3) Обновить TransactionList.tsx. Проверяю каждый файл на зависимости.",
  nextThoughtNeeded: true,
  thoughtNumber: 2,
  totalThoughts: 10
});

// 3. Проверить через Context7 лучшую практику для миграций типов
await use_mcp_tool("query-docs", {
  libraryId: "/microsoft/TypeScript",
  query: "Best practices for renaming interfaces while maintaining compatibility"
});

await use_mcp_tool("sequentialthinking", {
  thought: "TypeScript рекомендует: 1) Создать новый интерфейс с новым именем, 2) Использовать @deprecated на старом интерфейсе, 3) Обновить все использования постепенно. Буду следовать этому подходу.",
  nextThoughtNeeded: true,
  thoughtNumber: 3,
  totalThoughts: 10
});

await use_mcp_tool("sequentialthinking", {
  thought: "План утвержден: использую @deprecated для обратной совместимости и пошаговую миграцию.",
  nextThoughtNeeded: false,
  thoughtNumber: 4,
  totalThoughts: 10
});
```

---

## 🎛️ Параметры инструмента

```javascript
{
  // Обязательные параметры
  thought: "Текст текущего шага рассуждения",
  nextThoughtNeeded: boolean,  // Нужно ли продолжать
  thoughtNumber: integer,    // Номер текущего шага (начиная с 1)
  totalThoughts: integer,     // Предполагаемое общее количество
  
  // Опциональные параметры для расширенного использования
  isRevision: boolean,       // Является ли этот шаг ревизией предыдущего решения
  revisesThought: integer,    // Какой шаг пересматривается
  branchFromThought: integer, // От какого шага создается альтернативная ветка
  branchId: string,          // Идентификатор ветки (для отслеживания путей)
  needsMoreThoughts: boolean   // Нужно ли расширить план
}
```

---

## 📋 Паттерны использования по фазам

### ФАЗА 1: ARCHITECT (Планирование)

**Когда использовать:**
- Сложные архитектурные задачи
- Неясный scope задачи
- Планирование интеграций новых систем

**Базовый паттерн:**
```javascript
// 1. Инициализация
await use_mcp_tool("sequentialthinking", {
  thought: "Анализирую задачу: реализовать систему авторизации с поддержкой Google, GitHub и Email провайдеров.",
  nextThoughtNeeded: true,
  thoughtNumber: 1,
  totalThoughts: 8
});

// 2. Контекст через Memory Graph
await use_mcp_tool("search_nodes", {
  query: "Auth, User, Session"
});

// 3. Планирование компонентов
await use_mcp_tool("sequentialthinking", {
  thought: "Определил компоненты: OAuth2 интеграции для социальных провайдеров, Email OTP для одноразового доступа, Session management для токенов.",
  nextThoughtNeeded: true,
  thoughtNumber: 2,
  totalThoughts: 8
});

// 4. Проверка через Context7
await use_mcp_tool("resolve-library-id", {
  query: "OAuth2 library for Node.js with Google and GitHub",
  libraryName: "passport"
});

// 5. Интеграция
await use_mcp_tool("sequentialthinking", {
  thought: "Passport.js поддерживает OAuth2 для Google и GitHub. Для Email OTP создам кастомный провайдер. Архитектура: NextAuth.js + Passport.js + Custom Email Provider.",
  nextThoughtNeeded: false,
  thoughtNumber: 3,
  totalThoughts: 8
});
```

**Продвинутый паттерн с ветвлением:**
```javascript
// Шаги 1-3: Анализ и планирование (как выше)

// 4. Ветка 1: Оптимистичный сценарий
await use_mcp_tool("sequentialthinking", {
  thought: "ОПТИМИСТИЧНЫЙ: Все провайдеры интегрируются гладко, тесты проходят. Timeline: 2 недели.",
  nextThoughtNeeded: true,
  thoughtNumber: 4,
  totalThoughts: 8,
  branchFromThought: 3,
  branchId: "optimistic-path"
});

// 5. Ветка 2: Пессимистичный сценарий
await use_mcp_tool("sequentialthinking", {
  thought: "ПЕССИМИСТИЧНЫЙ: Google API может изменить, Email провайдер требует SMTP настройку. Timeline: 3 недели с планом отката.",
  nextThoughtNeeded: true,
  thoughtNumber: 5,
  totalThoughts: 8,
  branchFromThought: 3,
  branchId: "pessimistic-path"
});

// 6. Выбор оптимального сценария
await use_mcp_tool("sequentialthinking", {
  thought: "Выбираю оптимистичный сценарий: 2 недели, но с планом отката. Пессимистичный нужен только если Google API изменится.",
  nextThoughtNeeded: false,
  thoughtNumber: 6,
  totalThoughts: 8
});
```

### ФАЗА 2: EXECUTOR (Решение проблем)

**Когда использовать:**
- Ошибки которые трудно диагностировать
- Неясные причины падения тестов
- Несколько возможных решений

**Паттерн решения проблем:**
```javascript
// 1. Формулировка проблемы
await use_mcp_tool("sequentialthinking", {
  thought: "ПРОБЛЕМА: Тесты на аутентификацию падают с ошибкой 'Token expired'. Но токен был создан всего 1 минуту назад.",
  nextThoughtNeeded: true,
  thoughtNumber: 1,
  totalThoughts: 5
});

// 2. Проверка зависимостей
await use_mcp_tool("search_nodes", {
  query: "AuthService, JWT, Token"
});

// 3. Генерация гипотез
await use_mcp_tool("sequentialthinking", {
  thought: "ГИПОТЕЗА 1: Часы на сервере не синхронизированы, токен создан в будущем по времени сервера.",
  nextThoughtNeeded: true,
  thoughtNumber: 2,
  totalThoughts: 5
});

await use_mcp_tool("sequentialthinking", {
  thought: "ГИПОТЕЗА 2: Expiration time в конфигурации неправильно, 1 минута вместо 1 часа.",
  nextThoughtNeeded: true,
  thoughtNumber: 3,
  totalThoughts: 5
});

await use_mcp_tool("sequentialthinking", {
  thought: "ГИПОТЕЗА 3: Clock skew between server and client, клиент в другом часовом поясе.",
  nextThoughtNeeded: true,
  thoughtNumber: 4,
  totalThoughts: 5
});

// 4. Проверка через Context7
await use_mcp_tool("query-docs", {
  libraryId: "/auth0/node-jsonwebtoken",
  query: "JWT expiration time configuration best practices"
});

// 5. Выбор решения
await use_mcp_tool("sequentialthinking", {
  thought: "ВЕРИФИКАЦИЯ: Проверка Context7 показывает, что 1 минута - это дефолт для тестов. В реальной среде должно быть 1 час. Проблема в конфигурации окружения.",
  nextThoughtNeeded: false,
  thoughtNumber: 5,
  totalThoughts: 5
});
```

### ФАЗА 3: VALIDATOR (Проверка и верификация)

**Когда использовать:**
- Проверка гипотез из ФАЗЫ 2
- Верификация соответствия плану
- Проверка качества решения

**Паттерн верификации:**
```javascript
// 1. Проверка гипотезы
await use_mcp_tool("sequentialthinking", {
  thought: "ВЕРИФИКАЦИЯ: Проблема была в конфигурации окружения (.env.development использовал production настройки). Исправлено: разделил конфигурации.",
  nextThoughtNeeded: true,
  thoughtNumber: 1,
  totalThoughts: 3
});

// 2. Проверка покрытия
await use_mcp_tool("sequentialthinking", {
  thought: "ПРОВЕРКА: Тесты на аутентификацию теперь проходят. Но нужно проверить что другие API не сломались.",
  nextThoughtNeeded: true,
  thoughtNumber: 2,
  totalThoughts: 3
});

// 3. Валидация
await use_mcp_tool("sequentialthinking", {
  thought: "ВАЛИДАЦИЯ: Все тесты проходят,覆盖率 85%, соответствует плану. Решение верифицировано.",
  nextThoughtNeeded: false,
  thoughtNumber: 3,
  totalThoughts: 3
});
```

---

## 💡 Продвинутые паттерны

### Динамическое расширение плана

```javascript
// Шаг 1: Инициализация
await use_mcp_tool("sequentialthinking", {
  thought: "Анализирую требования к платежной системе.",
  nextThoughtNeeded: true,
  thoughtNumber: 1,
  totalThoughts: 7
});

// Шаг 2: Обнаружение дополнительных требований
await use_mcp_tool("sequentialthinking", {
  thought: "Обнаружил дополнительные требования: поддержка Stripe, PayPal и крипто платежей. Расширяю план до 12 шагов.",
  nextThoughtNeeded: true,
  thoughtNumber: 7,
  totalThoughts: 12,
  needsMoreThoughts: true
});

// Шаг 8-12: Продолжение планирования
await use_mcp_tool("sequentialthinking", {
  thought: "Добавляю интеграцию Stripe SDK и обработку webhooks.",
  nextThoughtNeeded: true,
  thoughtNumber: 8,
  totalThoughts: 12
});
```

### Ревизия предыдущих решений

```javascript
// Шаги 1-5: Первоначальное планирование
await use_mcp_tool("sequentialthinking", {
  thought: "Планирую монолитную архитектуру с единым сервисом.",
  nextThoughtNeeded: true,
  thoughtNumber: 5,
  totalThoughts: 8
});

// Шаг 6: Ревизия
await use_mcp_tool("sequentialthinking", {
  thought: "ПЕРЕСМАТРИВАЮ: Монолитная архитектура не масштабируется. Требуется микросервисная архитектура для независимого деплоя.",
  nextThoughtNeeded: true,
  thoughtNumber: 6,
  totalThoughts: 8,
  isRevision: true,
  revisesThought: 2
});

// Шаг 7-10: Новое планирование
await use_mcp_tool("sequentialthinking", {
  thought: "Перепланирую микросервисы: Auth Service, Payment Service, User Service, Transaction Service.",
  nextThoughtNeeded: false,
  thoughtNumber: 10,
  totalThoughts: 10
});
```

---

## ⚙️ Лучшие практики

### 1. Инициализация всегда с thoughtNumber: 1

```javascript
// ✅ ПРАВИЛЬНО
await use_mcp_tool("sequentialthinking", {
  thought: "Начинаю анализ задачи...",
  nextThoughtNeeded: true,
  thoughtNumber: 1,  // Всегда 1 при старте
  totalThoughts: 5
});
```

### 2. Обновляйте totalThoughts при расширении

```javascript
// ✅ ПРАВИЛЬНО: Динамическое расширение
await use_mcp_tool("sequentialthinking", {
  thought: "Обнаружил дополнительные требования, расширяю план.",
  nextThoughtNeeded: true,
  thoughtNumber: 5,
  totalThoughts: 8,  // Увеличено с 5 до 8
  needsMoreThoughts: true
});
```

### 3. Используйте ветвление для альтернатив

```javascript
// ✅ ПРАВИЛЬНО: Явное ветвление
await use_mcp_tool("sequentialthinking", {
  thought: "ОПТИМИСТИЧНЫЙ путь: API стабильный, интеграция гладкая.",
  nextThoughtNeeded: true,
  thoughtNumber: 6,
  totalThoughts: 8,
  branchFromThought: 5,
  branchId: "optimistic"  // Четкий идентификатор
});

await use_mcp_tool("sequentialthinking", {
  thought: "ПЕССИМИСТИЧНЫЙ путь: API может измениться, нужен fallback.",
  nextThoughtNeeded: false,
  thoughtNumber: 7,
  totalThoughts: 8,
  branchFromThought: 5,
  branchId: "pessimistic"
});
```

### 4. Завершайте с nextThoughtNeeded: false

```javascript
// ✅ ПРАВИЛЬНО: Явное завершение
await use_mcp_tool("sequentialthinking", {
  thought: "Решение верифицировано. Готово.",
  nextThoughtNeeded: false,  // Важно!
  thoughtNumber: 8,
  totalThoughts: 8
});
```

### 5. Комбинируйте с другими MCP серверами

```javascript
// ✅ ПРАВИЛЬНО: Полная синергия
// 1. Memory Graph для контекста
await use_mcp_tool("search_nodes", { query: "AuthService" });

// 2. Sequential Thinking для анализа
await use_mcp_tool("sequentialthinking", { ... });

// 3. Context7 для проверки
await use_mcp_tool("query-docs", { libraryId, query });

// 4. Sequential Thinking для принятия решения
await use_mcp_tool("sequentialthinking", { ... });
```

---

## 🚀 Примеры сценариев

### Сценарий 1: Планирование сложной миграции

```javascript
// ========== ARCHITECT ФАЗА ==========

// 1. Проверить текущее состояние
await use_mcp_tool("read_graph", {});

// 2. Анализировать через Sequential Thinking
await use_mcp_tool("sequentialthinking", {
  thought: "Анализирую миграцию: User имеет 15 полей, нужно перенести 12 в Profile, оставить 3, удалить deprecated поля.",
  nextThoughtNeeded: true,
  thoughtNumber: 1,
  totalThoughts: 10
});

await use_mcp_tool("sequentialthinking", {
  thought: "Создаю план миграции: 1) Создать Profile.ts, 2) Перенести поля, 3) Обновить User.ts, 4) Мигрировать данные, 5) Удалить старые поля из User.ts.",
  nextThoughtNeeded: true,
  thoughtNumber: 2,
  totalThoughts: 10
});

// 3. Проверить через Context7
await use_mcp_tool("query-docs", {
  libraryId: "/microsoft/TypeScript",
  query: "Database migration best practices with Prisma and TypeScript"
});

await use_mcp_tool("sequentialthinking", {
  thought: "Prisma рекомендует: 1) Новую модель, 2) Миграционный скрипт, 3) Обратную совместимость через @deprecated. Буду следовать этому.",
  nextThoughtNeeded: false,
  thoughtNumber: 3,
  totalThoughts: 10
});
```

### Сценарий 2: Решение проблемы производительности

```javascript
// ========== EXECUTOR ФАЗА ==========

// 1. Формулировка проблемы
await use_mcp_tool("sequentialthinking", {
  thought: "ПРОБЛЕМА: API для получения транзакций отвечает за 2 секунды при 1000 записях. Требуется оптимизация.",
  nextThoughtNeeded: true,
  thoughtNumber: 1,
  totalThoughts: 7
});

// 2. Проверить зависимости
await use_mcp_tool("search_nodes", { query: "Transaction, Database" });

// 3. Генерация гипотез
await use_mcp_tool("sequentialthinking", {
  thought: "ГИПОТЕЗА 1: Нет индекса на user_id в таблице transactions.",
  nextThoughtNeeded: true,
  thoughtNumber: 2,
  totalThoughts: 7
});

await use_mcp_tool("sequentialthinking", {
  thought: "ГИПОТЕЗА 2: N+1 query проблема (запросы без LIMIT).",
  nextThoughtNeeded: true,
  thoughtNumber: 3,
  totalThoughts: 7
});

await use_mcp_tool("sequentialthinking", {
  thought: "ГИПОТЕЗА 3: Возвращаются все поля вместо select() для оптимизации.",
  nextThoughtNeeded: true,
  thoughtNumber: 4,
  totalThoughts: 7
});

// 4. Проверить через Context7
await use_mcp_tool("query-docs", {
  libraryId: "/prisma/prisma",
  query: "Prisma performance optimization best practices for large datasets"
});

// 5. Выбор решения
await use_mcp_tool("sequentialthinking", {
  thought: "ВЕРИФИКАЦИЯ: Context7 показывает что Prisma поддерживает select() для оптимизации. Также нужен compound index на (user_id, date). Решение: добавить индекс и использовать select().",
  nextThoughtNeeded: false,
  thoughtNumber: 5,
  totalThoughts: 7
});
```

### Сценарий 3: Исследование альтернативных подходов

```javascript
// ========== ARCHITECT И EXECUTOR ==========

// 1. Формулировка исследования
await use_mcp_tool("sequentialthinking", {
  thought: "ИССЛЕДОВАНИЕ: Определить лучший подход для state management в Next.js 14 с TypeScript.",
  nextThoughtNeeded: true,
  thoughtNumber: 1,
  totalThoughts: 12
});

// 2. Ветка 1: React Context
await use_mcp_tool("sequentialthinking", {
  thought: "ПОДХОД 1: React Context. Плюсы: встроен в React, прост в начале. Минусы: re-render всех потребителей, сложно с TypeScript.",
  nextThoughtNeeded: true,
  thoughtNumber: 2,
  totalThoughts: 12,
  branchFromThought: 1,
  branchId: "react-context"
});

// 3. Ветка 2: Redux Toolkit
await use_mcp_tool("sequentialthinking", {
  thought: "ПОДХОД 2: Redux Toolkit. Плюсы: типизация, DevTools, ecosystem. Минусы: boilerplate, сложность для простых случаев.",
  nextThoughtNeeded: true,
  thoughtNumber: 3,
  totalThoughts: 12,
  branchFromThought: 1,
  branchId: "redux-toolkit"
});

// 4. Ветка 3: Zustand
await use_mcp_tool("sequentialthinking", {
  thought: "ПОДХОД 3: Zustand. Плюсы: минимум boilerplate, простая типизация, SSR-friendly. Минусы: меньше экосистемы чем Redux.",
  nextThoughtNeeded: true,
  thoughtNumber: 4,
  totalThoughts: 12,
  branchFromThought: 1,
  branchId: "zustand"
});

// 5. Проверить через Context7
await use_mcp_tool("query-docs", {
  libraryId: "/pmndrs/zustand",
  query: "Zustand with Next.js 14 and TypeScript examples"
});

await use_mcp_tool("query-docs", {
  libraryId: "/reduxjs/redux-toolkit",
  query: "Redux Toolkit with Next.js 14 and TypeScript best practices"
});

// 6. Сравнение и выбор
await use_mcp_tool("sequentialthinking", {
  thought: "ВЫБОР: Zustand лучше всего подходит: 1) Минимум boilerplate, 2) TypeScript friendly, 3) SSR совместимый (важно для Next.js), 4) Простота для текущего scope. Redux слишком сложный, React Context не типизирован достаточно хорошо.",
  nextThoughtNeeded: false,
  thoughtNumber: 5,
  totalThoughts: 12
});
```

---

## 📚 Ссылки

- [Sequential Thinking MCP Server](https://github.com/modelcontextprotocol/servers/tree/main/src/sequentialthinking)
- [Memory Graph MCP Server](../memory.md)
- [Context7 MCP Server](../context7.md)
- [AIRules Auto-Protocol](../../.clinerules/auto-protocol.md)

---

**Назначение:** Документация по использованию Sequential Thinking MCP в AIRules  
**Версия:** 1.0.0  
**Дата:** 2026-01-08