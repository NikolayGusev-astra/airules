# 💡 Решения для Context7 Researcher Skill

## 🔍 Поиск библиотек

```javascript
// Запрос к resolve-library-id
{
  "query": "authentication library for Next.js",
  "libraryName": "auth"
}

// Результат
{
  "libraryId": "/next-auth/next-auth",
  "description": "Complete authentication solution for Next.js",
  "reputation": "High"
}
```

## 📚 Получение документации

```javascript
// Запрос к query-docs
{
  "libraryId": "/next-auth/next-auth",
  "query": "How to implement authentication in Next.js 14 with NextAuth v5?"
}

// Результат - актуальная документация с примерами кода
```

## 🎯 Примеры использования

```typescript
// Пример: JWT middleware с Context7
import { NextRequest } from 'next/server'

export async function middleware(req: NextRequest) {
  const token = req.cookies.get('token')?.value
  
  if (!token) {
    return new Response('Unauthorized', { status: 401 })
  }
  
  // Проверка токена
  // (реализация после получения документации из Context7)
}