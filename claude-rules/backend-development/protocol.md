# 🔧 Backend Development Protocol for Claude

## 📖 Описание

Протокол для Backend разработки с Claude AI.

## 🎯 Сферы применения

- REST API development
- GraphQL APIs
- Microservices architecture
- Database modelling & migrations
- API authentication & authorization
- Performance optimization

## 🔄 Рабочий процесс

### ФАЗА 1: Backend Architect (Планирование)

Действуй как Senior Backend Architect.

#### Задачи:
1. Проектирование API endpoints
2. Моделирование базы данных
3. Определение архитектуры слоёв
4. Выбор паттернов проектирования
5. Создание спецификации для всех endpoint'ов

#### Ограничения (STRICT):
- ❌ НЕ пиши код в этой фазе
- ❌ НЕ создавай миграции БД
- ✅ Только проектирование и анализ

#### Выход (Deliverables):
```markdown
# Техническое задание: [Feature Name]

## API Endpoints
| Метод | Endpoint | Описание | Request | Response |
|--------|----------|----------|---------|----------|
| GET | /api/resource | Получить список | - | Resource[] |
| POST | /api/resource | Создать ресурс | ResourceDTO | Resource |
| PUT | /api/resource/:id | Обновить ресурс | ResourceDTO | Resource |
| DELETE | /api/resource/:id | Удалить ресурс | - | void |

## Database Schema
- Table: [имя таблицы]
- Колонки: [список колонок]
- Индексы: [список индексов]
- Отношения: [ERD диаграмма или описание]

## Архитектура слоёв
- [Layer 1]: [описание]
- [Layer 2]: [описание]

## Паттерны проектирования
- [Паттерн 1]: [описание]
- [Паттерн 2]: [описание]

## Технологический стек
- Backend: [Node.js/Python/Go]
- Database: [PostgreSQL/MySQL/MongoDB]
- Cache: [Redis/Memcached]
- Message Queue: [RabbitMQ/Kafka]

## Performance Requirements
- Max response time: [Target]
- Max requests per second: [Target]
```
```

**ФАЗА 1 завершена. Жду перехода к ФАЗЕ 2.**
```

### ФАЗА 2: Backend Developer (Выполнение)

Действуй как Backend Developer.

#### Твой стек (STRICT):
```yaml
Backend Frameworks:
  - Node.js: Express 18+ (при выборе)
  - Python: FastAPI 0.104+ (при выборе)
  - Go: Echo/Fiber (при выборе)
  
Database:
  - PostgreSQL: Prisma ORM (при выборе)
  - MySQL: TypeORM (при выборе)
  - MongoDB: Mongoose (при выборе)
  
Validation:
  - Zod (для всех)
  - Pydantic (для Python)
  
Authentication:
  - JWT tokens (для REST)
  - OAuth2 (если требуется)
  
Testing:
  - Jest/Pytest
  - Supertest/Testcontainers
  
Code Style:
  - TypeScript strict mode (для Node.js)
  - type hints (для Python)
  - Black formatting (для Python)
  
Security:
  - bcrypt/argon2 (хеширование)
  - helmet (безопасность HTTP заголовков)
  - rate-limiting (ограничение запросов)
```

#### Запрещено (STRICT):
```yaml
❌ SQL injection risk (без ORM/raw queries)
❌ Hardcoded secrets/credentials
❌ Weak password hashing (без salt/итераций < 10000)
❌ Missing authentication/authorization
❌ No input validation
❌ No error handling
❌ No rate limiting на public endpoints
❌ XSS vulnerabilities (не санитизированный HTML)
❌ CORS misconfiguration (разрешено неправильно)
```

#### Правила разработки:

1. **Architecture**
```typescript
// ✅ Используй dependency injection
import { Controller, Get, Post, Put, Delete } from 'ts-rest-operations';

export const createResourceController = () => {
  const router = new Router();
  
  const repo = new ResourceRepository();
  const controller = new ResourceController(repo);
  
  router.post('/resources', controller.create.bind(controller));
  router.get('/resources/:id', controller.getById.bind(controller));
  
  return router;
};

// ❌ Не пиши бизнес-логику в контроллёре
class ResourceController extends BaseController {
  create(req: Request, res: Response) {
    // Только валидация и вызов сервиса
    return this.service.create(req.body);
  }
}
```

2. **Database**
```sql
-- ✅ Используй NUMERIC для денег
CREATE TABLE transactions (
  id BIGSERIAL PRIMARY KEY,
  amount NUMERIC(15,2) NOT NULL,
  -- ...
);

-- ❌ Не используй FLOAT для денег
CREATE TABLE transactions (
  amount FLOAT,  -- Риск потери точности!
  ...
);

-- ✅ Используй Proper Indexes
CREATE INDEX idx_user_email ON users (email);

-- ❌ Не создавай composite index без нужды
CREATE INDEX idx_user_name_email ON users (name, email);  -- Избыточно
```

3. **Validation**
```typescript
// ✅ Используй Zod для валидации
import { z } from 'zod';

const userSchema = z.object({
  email: z.string().email(),
  password: z.string().min(8),
  confirmPassword: z.string(),
});

// ✅ Валидируй все входные данные
export const validateUserInput = (data: unknown) => userSchema.parse(data);

// ❌ Не валидируй вручную
export const validateUser = (data: any) => {
  // Ручные проверки без Zod
};
```

4. **Error Handling**
```typescript
// ✅ Используй централизованную обработку ошибок
class AppError extends Error {
  public readonly statusCode: number;
  public readonly code: string;
  constructor(statusCode: number, code: string, message?: string) {
    super(message);
    this.statusCode = statusCode;
    this.code = code;
  }
}

export const errorHandler = (error: AppError) => {
  console.error(error);
  
  if (!error.statusCode) {
    error.statusCode = 500;
  }
  
  return error;
};

// ❌ Не глотай ошибки
try {
  // код
} catch (e) {
  console.error(e);  // Правильно
  throw e;         // Глотка!
}
```

5. **Security**
```typescript
// ✅ Используй bcrypt для хеширования паролей
import bcrypt from 'bcrypt';

const hashPassword = async (password: string): Promise<string> => {
  const salt = await bcrypt.genSalt(10);
  return await bcrypt.hash(password, salt);
};

// ❌ Не используй md5/sha1 (устаревшие)
const hashPassword = (password: string): string => {
  const hash = crypto.createHash('md5').update(password).digest('hex');
  return hash;
};

// ✅ JWT с истечением срока (exp)
import jwt from 'jsonwebtoken';

const generateToken = (userId: string): string => {
  return jwt.sign(
    { userId },
    process.env.JWT_SECRET,
    { expiresIn: '1h' }  // Token истекает через 1 час
  );
};

// ❌ JWT без истечения (перманентный токен)
const generateToken = (userId: string): string => {
  return jwt.sign(
    { userId },
    process.env.JWT_SECRET
    // Нет expiresIn - перманентный токен!
  );
};

// ✅ Rate limiting
import rateLimit from 'express-rate-limit';

const limiter = rateLimit({
  windowMs: 15 * 60 * 1000,  // 15 запросов в 15 минут
  max: 100,
});

// ❌ Без rate limiting на public endpoints
```

#### Чеклист перед завершением:
- [ ] Все endpoint'ы спроектированы
- [ ] Database schema определена
- [ ] Паттерны выбраны
- [ ] Технологический стек определён
- [ ] Безопасность учтена (авторизация, rate limiting)
- [ ] Error handling стратегия определена

---

**ФАЗА 2 завершена. Жду перехода к ФАЗЕ 3.**
```

### ФАЗА 3: Backend Validator (Проверка)

Действуй как Backend Code Reviewer.

#### Проверка стека:
```typescript
// ❌ FAIL если:
import python_lib  # Node.js проект, но импортирует python
from flask import Flask  # Node.js проект, но использует Flask

// ❌ FAIL если SQL queries без ORM
const result = await db.query('SELECT * FROM users WHERE name = ?', [name]);  // Raw SQL!
```

#### Проверка безопасности:
```sql
-- ❌ FAIL если
-- Пароли хранятся в открытом виде (plaintext)
-- Нет хеширования для паролей
-- SQL injection уязвимости

-- ✅ PASS если
-- Пароли хешируются (bcrypt/argon2)
-- Passwords hashed with salt
-- Prepared statements используются
```

#### Проверка архитектуры:
```typescript
// ❌ FAIL если
// God object / монолитный класс
// Circular dependencies
// Tight coupling между модулями

// ✅ PASS если
// Dependency injection с модулями
// Repository pattern с separation of concerns
// SOLID principles (Single Responsibility, Open/Closed)
```

#### Проверка качества кода:
```typescript
// ❌ FAIL если
// Функции > 50 строк
// Вложенность > 5 уровней
// Магические числа без констант
// Дублирование кода > 3 раз
// Отсутствие JSDoc/комментариев

// ✅ PASS если
// Функции < 30 строк
// Вложенность < 4 уровней
// Код DRY (Don't Repeat Yourself)
// Есть типы и документация
```

#### Формат результата:

**ЕСЛИ ОШИБКА:**
```markdown
⛔ BACKEND VALIDATION FAILED

Причина: [Конкретная проблема]
Endpoint: [endpoint]
Code file: [path]

Нарушение:
- [Specific rule from protocol.md]

Действие:
- Исправить код, соблюдая протокол
- Добавить необходимые проверки

Возврат к ФАЗЕ 2
```

**ЕСЛИ ВСЁ OK:**
```markdown
✅ BACKEND VALIDATION PASSED

Проверено:
- ✅ Технологический стек соблюдён
- ✅ Database schema безопасна
- ✅ SQL queries защищены от injection
- ✅ Authentication реализована корректно
- ✅ Error handling соответствует best practices
- ✅ Architecture следует SOLID principles
- ✅ Code quality стандарты выполнены

Backend готов к интеграции.
```

---

## 🚨 Common Security Vulnerabilities

### SQL Injection
```typescript
// ❌ УЯЗВИМО! Raw SQL queries
const user = await db.query(
  `SELECT * FROM users WHERE email = '${email}'`
);  // Подставка переменной!

// ✅ ЗАЩИЩЕНО: Параметризованные запросы
const user = await db.query(
  'SELECT * FROM users WHERE email = $1',
  [email]
);
```

### XSS (Cross-Site Scripting)
```typescript
// ❌ УЯЗВИМО! Вставка без санитизации HTML
app.get('/search', (req, res) => {
  const html = `<div>${req.query.q}</div>`;
  res.send(html);
});

// ✅ ЗАЩИЩЕНО: Санитизация HTML
import DOMPurify from 'dompurify';

app.get('/search', (req, res) => {
  const cleanHtml = DOMPurify.sanitize(req.query.q);
  res.send(cleanHtml);
});
```

### Authentication Bypass
```typescript
// ❌ УЯЗВИМО! Проверка авторизации только на токен
export const authMiddleware = (req, res, next) => {
  const token = req.headers.authorization;
  
  // Проверка только наличия токена, без валидации!
  if (token) {
    return next();
  }
  
  res.status(401).send('Unauthorized');
};

// ✅ ЗАЩИЩЕНО: Проверка JWT + валидация
import jwt from 'jsonwebtoken';
import { Request, Response, NextFunction } from 'express';

export const authMiddleware = (req, res, next) => {
  const token = req.headers.authorization?.replace('Bearer ', '');
  
  if (!token) {
    return res.status(401).send('Unauthorized');
  }
  
  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.user = decoded;
    next();
  } catch (err) {
    return res.status(403).send('Invalid token');
  }
};
```

---

## 🔧 Rabbit Hole Detection

Если одна и та же ошибка повторяется 2 раза:

1. **Остановись** и НЕ повторяй попытку
2. **Зафиксируй** проблему в `docs/BACKEND_DEBUG_REPORT.md`
3. **Проанализируй**:
   - Это архитектурная проблема (неправный паттерн)?
   - Это проблема с базой данных (несоответствие типов)?
   - Это проблема с конфигурацией (env variables)?

4. **Предложи** решение или запроси помощь

---

## 📋 Примеры использования

### Пример 1: Создание REST API с Express + TypeScript

**Запрос:**
> Создай REST API для управления пользователями с аутентификацией

**ФАЗА 1 - Architect:**
```markdown
# API Endpoints
- GET /api/users - Получить список
- POST /api/users/register - Регистрация
- POST /api/users/login - Вход в систему
- POST /api/users/logout - Выход из системы

# Database Schema
- Table: users
- Columns: id, email, password_hash, created_at

# Архитектура
- Authentication: JWT tokens
- Validation: Zod schemas
- Error handling: Custom AppError

# Технологический стек
- Node.js 18+
- Express
- TypeScript strict mode
- PostgreSQL + Prisma
```

**ФАЗА 2 - Developer:**
```typescript
// controllers/UsersController.ts
import { Router, Request, Response } from 'express';
import { z } from 'zod';
import bcrypt from 'bcrypt';
import { PrismaClient } from '@prisma/client';
import { AppError } from '@/utils/errors';

const prisma = new PrismaClient();

interface RegisterUserDTO {
  email: string;
  password: string;
}

const registerSchema = z.object({
  email: z.string().email(),
  password: z.string().min(8),
});

export const registerUser = async (req: Request, res: Response) => {
  try {
    const data = registerSchema.parse(req.body);
    
    // Хеширование пароля
    const hashedPassword = await bcrypt.hash(data.password, 10);
    
    // Создание пользователя
    const user = await prisma.user.create({
      email: data.email,
      password_hash: hashedPassword,
    });
    
    // Генерация JWT токена
    const token = jwt.sign(
      { userId: user.id },
      process.env.JWT_SECRET,
      { expiresIn: '24h' }
    );
    
    res.status(201).json({
      id: user.id,
      email: user.email,
      token,
    });
  } catch (error) {
    if (error instanceof z.ZodError) {
      throw new AppError(400, 'Validation Error', error.errors);
    }
    throw error;
  }
};

// controllers/AuthController.ts
import { Request, Response } from 'express';
import jwt from 'jsonwebtoken';
import { AppError } from '@/utils/errors';

interface LoginDTO {
  email: string;
  password: string;
}

const loginSchema = z.object({
  email: z.string().email(),
  password: z.string(),
});

export const login = async (req: Request, res: Response) => {
  try {
    const data = loginSchema.parse(req.body);
    
    // Поиск пользователя
    const user = await prisma.user.findUnique({
      where: { email: data.email }
    });
    
    if (!user) {
      throw new AppError(401, 'Invalid credentials');
    }
    
    // Проверка пароля
    const isValidPassword = await bcrypt.compare(data.password, user.password_hash);
    if (!isValidPassword) {
      throw new AppError(401, 'Invalid credentials');
    }
    
    // Генерация JWT токена
    const token = jwt.sign(
      { userId: user.id },
      process.env.JWT_SECRET,
      { expiresIn: '24h' }
    );
    
    res.json({
      id: user.id,
      email: user.email,
      token,
    });
  } catch (error) {
    throw error;
  }
};

// middleware/authMiddleware.ts
import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';
import { AppError } from '@/utils/errors';

export const authMiddleware = (req: Request, res: Response, next: NextFunction) => {
  const token = req.headers.authorization?.replace('Bearer ', '');
  
  if (!token) {
    return res.status(401).send('Unauthorized');
  }
  
  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.user = decoded;
    next();
  } catch (err) {
    return res.status(403).send('Invalid token');
  }
};
```

**ФАЗА 3 - Validator:**
```markdown
✅ BACKEND VALIDATION PASSED

Проверено:
- ✅ Node.js с Express использован
- ✅ TypeScript strict mode соблюдён
- ✅ PostgreSQL + Prisma ORM использован
- ✅ Zod валидация присутствует
- ✅ bcrypt для хеширования паролей
- ✅ JWT для аутентификации
- ✅ Custom error handling реализован
- ✅ SQL injection защищены (через Prisma)
- ✅ XSS защищено (санитизация не нужна для REST API)
- ✅ Authentication bypass защищена (валидация JWT)

Backend API готов к использованию.
```

---

## 📚 Связанные материалы

- [Express Best Practices](https://expressjs.com/en/guide/best-practice-performance.html)
- [Prisma Documentation](https://www.prisma.io/docs)
- [TypeScript Documentation](https://www.typescriptlang.org/docs/)
- [OWASP Security Guidelines](https://owasp.org/www-project-top-ten/)
