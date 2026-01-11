# 💡 Решения для Architect Skill

Этот файл содержит конкретные решения для типичных задач архитектора.

---

## 🎯 Создание архитектуры API

### Решение: REST API с TypeScript

**Проблема:** Нужно создать архитектуру REST API для CRUD операций

```typescript
// src/api/router.ts
import { Router, Request, Response } from 'express';
import { z } from 'zod';

export const createRouter = (prefix: string = '/api') => {
  const router = Router();
  
  // Generic CRUD routes
  router.get('/:id', async (req: Request, res: Response) => {
    const { id } = req.params;
    const data = await getById(id);
    res.json(data);
  });
  
  router.post('/', async (req: Request, res: Response) => {
    const schema = z.object({
      name: z.string().min(1),
      value: z.number()
    });
    const data = schema.parse(req.body);
    const created = await create(data);
    res.status(201).json(created);
  });
  
  return router;
};
```

**Полезные ссылки:**
- [Context7: Express TypeScript](https://www.context7.ai)
- [REST API Best Practices](https://restfulapi.net/)

---

## 🏗️ Архитектура проекта

### Решение: Feature-based структура

**Проблема:** Как организовать файлы в большом проекте

```
src/
├── features/
│   ├── auth/
│   │   ├── api/
│   │   ├── services/
│   │   ├── types/
│   │   └── tests/
│   └── users/
│       ├── api/
│       ├── services/
│       ├── types/
│       └── tests/
├── shared/
│   ├── types/
│   ├── utils/
│   └── constants/
└── index.ts
```

**Преимущества:**
- Когерентное объединение связанного кода
- Легко удалять или добавлять фичи
- Изоляция изменений

**Полезные ссылки:**
- [Feature-based Architecture](https://kentcdodds.com/blog/application-state-management-patterns)

---

## 📊 Архитектура базы данных

### Решение: Отдельные схемы для разных доменов

**Проблема:** Как организовать схемы для Accounting домена

```sql
-- Accounting schema
CREATE SCHEMA accounting;

-- Таблицы в Accounting
CREATE TABLE accounting.transactions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  amount NUMERIC(15,2) NOT NULL,  -- Обязательно NUMERIC!
  type VARCHAR(50) NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Indeks для оптимизации
CREATE INDEX idx_transactions_amount ON accounting.transactions(amount);
CREATE INDEX idx_transactions_created ON accounting.transactions(created_at);
```

**Полезные ссылки:**
- [PostgreSQL Schemas](https://www.postgresql.org/docs/current/ddl-schemas.html)
- [Context7: Database Design](https://www.context7.ai)

---

## 🔐 Архитектура аутентификации

### Решение: JWT + Refresh Tokens

**Проблема:** Как реализовать безопасную аутентификацию

```typescript
// src/auth/jwt.ts
import jwt from 'jsonwebtoken';

export const createAccessToken = (userId: string) => {
  return jwt.sign({ userId }, process.env.JWT_SECRET, {
    expiresIn: '15m'
  });
};

export const createRefreshToken = (userId: string) => {
  return jwt.sign({ userId }, process.env.REFRESH_SECRET, {
    expiresIn: '7d'
  });
};

// Middleware для проверки
export const authMiddleware = (req: Request, res: Response, next: NextFunction) => {
  const token = req.headers.authorization?.split(' ')[1];
  
  if (!token) {
    return res.status(401).json({ error: 'No token' });
  }
  
  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.userId = decoded.userId;
    next();
  } catch (error) {
    return res.status(401).json({ error: 'Invalid token' });
  }
};
```

**Полезные ссылки:**
- [JWT Best Practices](https://tools.ietf.org/html/rfc8725)
- [Context7: Auth Patterns](https://www.context7.ai)

---

## 🧪 Архитектура тестирования

### Решение: Three-layer тестирование

**Проблема:** Как организовать тесты

```
tests/
├── unit/           // Unit tests (функции, утилиты)
│   ├── utils/
│   └── services/
├── integration/    // Integration tests (API + Database)
│   └── api/
└── e2e/           // E2E tests (веб-интерфейс)
    └── flows/
```

**Unit Tests:**
```typescript
describe('formatCurrency', () => {
  test('formats correctly', () => {
    expect(formatCurrency(1234.56)).toBe('1,234.56');
  });
});
```

**Integration Tests:**
```typescript
describe('POST /api/users', () => {
  test('creates user', async () => {
    const response = await request(app)
      .post('/api/users')
      .send({ name: 'John', email: 'john@example.com' });
    
    expect(response.status).toBe(201);
    expect(response.body.email).toBe('john@example.com');
  });
});
```

**Полезные ссылки:**
- [Testing Best Practices](https://kentcdodds.com/blog/common-testing-mistakes)
- [Context7: Test Architecture](https://www.context7.ai)