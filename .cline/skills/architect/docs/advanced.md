# 🚀 Продвинутые паттерны для Architect Skill

Этот файл содержит продвинутые архитектурные паттерны и практики.

---

## 🎨 Event-Driven Architecture

### Паттерн: Event Sourcing

**Когда использовать:**
- Требуется полная история изменений
- Нужны бизнес-аналитика
- Распределенные системы

```typescript
// src/events/EventBus.ts
type Event = {
  type: string;
  payload: unknown;
  timestamp: Date;
  aggregateId: string;
};

class EventBus {
  private handlers: Map<string, Function[]> = new Map();
  
  subscribe(eventType: string, handler: Function) {
    if (!this.handlers.has(eventType)) {
      this.handlers.set(eventType, []);
    }
    this.handlers.get(eventType)!.push(handler);
  }
  
  publish(event: Event) {
    const handlers = this.handlers.get(event.type) || [];
    handlers.forEach(handler => handler(event));
  }
}

// Использование
const eventBus = new EventBus();

eventBus.subscribe('TransactionCreated', async (event) => {
  await updateBalance(event.aggregateId, event.payload.amount);
});

eventBus.publish({
  type: 'TransactionCreated',
  payload: { amount: 100 },
  timestamp: new Date(),
  aggregateId: 'tx-123'
});
```

**Полезные ссылки:**
- [Event Sourcing Pattern](https://martinfowler.com/eaaDev/EventSourcing.html)
- [Context7: Event-Driven Architecture](https://www.context7.ai)

---

## 🔄 CQRS Pattern

### Паттерн: Command Query Responsibility Segregation

**Когда использовать:**
- Разные требования к чтению и записи
- Высокая нагрузка на чтение
- Сложные бизнес-операции

```typescript
// src/cqrs/commands.ts
interface Command {
  execute(): Promise<void>;
}

class CreateTransactionCommand implements Command {
  constructor(
    private amount: number,
    private userId: string
  ) {}
  
  async execute() {
    await db.transactions.create({
      amount: this.amount,
      userId: this.userId
    });
  }
}

// src/cqrs/queries.ts
interface Query<T> {
  execute(): Promise<T>;
}

class GetTransactionsQuery implements Query<Transaction[]> {
  constructor(private userId: string) {}
  
  async execute() {
    return db.transactions.findMany({
      where: { userId: this.userId }
    });
  }
}

// Использование
const createCommand = new CreateTransactionCommand(100, 'user-1');
await createCommand.execute();

const query = new GetTransactionsQuery('user-1');
const transactions = await query.execute();
```

**Полезные ссылки:**
- [CQRS Pattern](https://martinfowler.com/bliki/CQRS.html)
- [Context7: CQRS Implementation](https://www.context7.ai)

---

## 🧱 Domain-Driven Design

### Паттерн: Aggregates & Entities

**Когда использовать:**
- Сложные бизнес-правила
- Требуется консистентность
- Accounting домен

```typescript
// src/domain/TransactionAggregate.ts
interface DomainEvent {
  type: string;
  occurredAt: Date;
}

class TransactionAggregate {
  private events: DomainEvent[] = [];
  private balance: number = 0;
  
  recordTransaction(amount: number, type: 'credit' | 'debit') {
    if (type === 'debit' && this.balance < amount) {
      throw new Error('Insufficient funds');
    }
    
    this.balance += type === 'credit' ? amount : -amount;
    
    this.events.push({
      type: 'TransactionRecorded',
      occurredAt: new Date()
    });
  }
  
  getBalance(): number {
    return this.balance;
  }
  
  getEvents(): DomainEvent[] {
    return [...this.events];
  }
}

// Использование
const aggregate = new TransactionAggregate();
aggregate.recordTransaction(100, 'credit');
aggregate.recordTransaction(50, 'debit');

console.log(aggregate.getBalance()); // 50
```

**Полезные ссылки:**
- [DDD Tactical Patterns](https://martinfowler.com/bliki/DomainDrivenDesign.html)
- [Context7: Domain Modeling](https://www.context7.ai)

---

## 🔒 Security Architecture

### Паттерн: Layered Security

**Когда использовать:**
- Многослойная защита
- Разные уровни доступа
- Accounting с деньгами

```typescript
// src/security/SecurityLayers.ts
interface SecurityLayer {
  check(request: Request): Promise<boolean>;
}

class RateLimitLayer implements SecurityLayer {
  async check(request: Request): Promise<boolean> {
    const ip = request.ip;
    const count = await redis.get(`rate:${ip}`);
    
    if (count > 100) {
      return false;
    }
    
    await redis.incr(`rate:${ip}`);
    await redis.expire(`rate:${ip}`, 60);
    return true;
  }
}

class AuthLayer implements SecurityLayer {
  async check(request: Request): Promise<boolean> {
    const token = request.headers.authorization;
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    return !!decoded;
  }
}

class RBCLayer implements SecurityLayer {
  async check(request: Request): Promise<boolean> {
    const userRole = request.user.role;
    const requiredRole = request.requiredRole;
    return hasPermission(userRole, requiredRole);
  }
}

// Middleware с несколькими слоями
const securityLayers = [
  new RateLimitLayer(),
  new AuthLayer(),
  new RBCLayer()
];

app.use(async (req, res, next) => {
  for (const layer of securityLayers) {
    if (!(await layer.check(req))) {
      return res.status(403).json({ error: 'Access denied' });
    }
  }
  next();
});
```

**Полезные ссылки:**
- [OWASP Security Best Practices](https://owasp.org/www-project-top-ten/)
- [Context7: Security Patterns](https://www.context7.ai)

---

## 📊 Microservices Architecture

### Паттерн: API Gateway

**Когда использовать:**
- Микросервисы
- Единая точка входа
- Auth/Rate limiting централизованно

```typescript
// src/gateway/ApiGateway.ts
import express from 'express';
import { createProxyMiddleware } from 'http-proxy-middleware';

const app = express();

// Auth service
app.use('/api/auth', createProxyMiddleware({
  target: 'http://auth-service:3001',
  changeOrigin: true
}));

// Users service
app.use('/api/users', createProxyMiddleware({
  target: 'http://users-service:3002',
  changeOrigin: true
}));

// Accounting service
app.use('/api/accounting', createProxyMiddleware({
  target: 'http://accounting-service:3003',
  changeOrigin: true
}));

// Global middleware
app.use((req, res, next) => {
  console.log(`${req.method} ${req.path}`);
  next();
});

app.listen(80, () => {
  console.log('API Gateway running on port 80');
});
```

**Полезные ссылки:**
- [API Gateway Pattern](https://microservices.io/patterns/apigateway.html)
- [Context7: Microservices](https://www.context7.ai)

---

## 🧪 Advanced Testing Strategies

### Стратегия: Contract Testing

**Когда использовать:**
- Микросервисы
- API между сервисами
- Проверка совместимости

```typescript
// tests/contract/transactionContract.ts
import { Pact } from '@pact-foundation/pact';
import { TransactionApi } from '../../src/api/TransactionApi';

describe('Transaction API Contract', () => {
  const provider = new Pact({
    provider: 'TransactionService',
    consumer: 'UserService',
    port: 1234,
  });

  beforeAll(() => provider.setup());
  afterAll(() => provider.finalize());

  test('creates transaction', async () => {
    await provider.addInteraction({
      state: 'user exists',
      uponReceiving: 'a request to create transaction',
      withRequest: {
        method: 'POST',
        path: '/api/transactions',
        body: { amount: 100, type: 'credit' }
      },
      willRespondWith: {
        status: 201,
        body: { id: 'tx-123', amount: 100, type: 'credit' }
      }
    });

    const api = new TransactionApi('http://localhost:1234');
    const result = await api.createTransaction({
      amount: 100,
      type: 'credit'
    });

    expect(result.id).toBe('tx-123');
  });
});
```

**Полезные ссылки:**
- [Pact Contract Testing](https://docs.pact.io/)
- [Context7: Contract Testing](https://www.context7.ai)