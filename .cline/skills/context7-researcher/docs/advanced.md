# 🚀 Продвинутые паттерны для Context7 Researcher Skill

---

## ⚡ Версионная спецификация

```javascript
// Поиск конкретной версии
{
  "query": "React 18 hooks with TypeScript",
  "libraryId": "/facebook/react/v18"
}

// Результат: документация именно для React 18
```

## 🎯 Оптимизация запросов

```javascript
// ✅ Хороший запрос - конкретный
{
  "query": "How to use useTransition in React 18 for optimistic updates",
  "libraryId": "/facebook/react/v18"
}

// ❌ Плохой запрос - слишком общий
{
  "query": "React hooks",
  "libraryId": "/facebook/react"
}
```

## 🔄 Интеграция с Multi-Agent Workflow

```markdown
## Пример: Интеграция Context7 в ARCHITECT фазу

### Шаг 1: CONTEXT7 RESEARCHER
```
Запрос к Context7:
"Search for best authentication libraries for Next.js 14 with Supabase"
```

### Шаг 2: ARCHITECT
```
Получена документация от Context7 Researcher:
- NextAuth.js v5: полная аутентификация
- Supabase Auth: нативная интеграция
- Clerk: готовое решение

Выбор: Supabase Auth (так как используется Supabase)
```

### Шаг 3: EXECUTOR
```
Использую Supabase Auth на основе документации из Context7
```