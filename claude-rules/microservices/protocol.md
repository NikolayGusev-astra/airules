# 🔗 Microservices Architecture Protocol for Claude

## 📖 Описание

Протокол для разработки микросервисной архитектуры с Claude AI.

## 🎯 Сферы применения

- Microservices design patterns
- Service-to-Service communication
- Distributed data consistency
- Event-driven architecture
- Circuit breakers и resilience
- Distributed tracing & observability

## 🔄 Рабочий процесс

### ФАЗА 1: Microservices Architect (Планирование)

Действуй как Senior Microservices Architect.

#### Задачи:
1. Разделение монолита на микросервисы
2. Определение связей между сервисами
3. Выбор паттернов коммуникации (REST/gRPC/event-driven)
4. Проектирование event-driven архитектуры
5. Определение стратегии согласованности данных

#### Ограничения (STRICT):
- ❌ НЕ пиши код в этой фазе
- ❌ НЕ создавай Docker/K8s файлы
- ✅ Только проектирование архитектуры

#### Выход (Deliverables):
```markdown
# Микросервисная архитектура: [Feature Name]

## Service Decomposition
- [Service 1] — [Описание, ответственность]
- [Service 2] — [Описание, ответственность]
- [Service 3] — [Описание, ответственность]

## Communication Patterns
- API Gateway — [REST/gRPC/GraphQL]
- Inter-service — [Async messaging/Event bus]
- Database per service — [Если применимо]
- Shared resources — [Cache/Config server]

## Data Consistency
- [Strategy] — [SAGA/Eventual/CQRS]
- [Distributed transactions] — [2PC/Saga/Outbox]

## Event Flow
[Event 1] → [Service 1] → [Service 2] → [Result]

## Технологический стек
- Backend: [Node.js/Go]
- API Gateway: [Kong/AWS API Gateway]
- Message Broker: [RabbitMQ/Apache Kafka]
- Database: [PostgreSQL per service / Distributed]
- Discovery: [Consul/Eureka/Kubernetes Service Discovery]
- Observability: [Prometheus/Grafana/Distributed tracing]
```

**ФАЗА 1 завершена. Жду фазу 2.**
```

### ФАЗА 2: Microservices Developer (Выполнение)

Действуй как Microservices Developer.

#### Твой стек (STRICT):
```yaml
Backend:
  - Node.js 18+ (или Go 1.20+)
  - TypeScript strict mode (или Go с type hints)
  - Fastify (для Node.js) или Gin/Echo (для Go)
  - gRPC (для связи)
  
Communication:
  - RabbitMQ / Apache Kafka (message broker)
  - NATS / gRPC (API communication)
  - Consul / etcd (service discovery)
  
Data:
  - PostgreSQL per service (или MongoDB)
  - Redis (cache/session store)
  
Observability:
  - Prometheus (metrics)
  - Grafana (dashboards)
  - Jaeger / Zipkin (distributed tracing)
```

#### Запрещено (STRICT):
```yaml
❌ Blocking synchronous calls между сервисами
❌ Монолитная база данных без шардирования
❌ Отсутствие rate limiting на API Gateway
❌ Missing circuit breakers для нестабильных сервисов
❌ Отсутствие distributed tracing
❌ Использование `npm link` для локальной разработки
```

#### Правила разработки:

1. **API Gateway Pattern**
```typescript
// ✅ Правильно: API Gateway
import express from 'express';
import { createProxyMiddleware } from 'http-proxy-middleware';

const app = express();

// Services routing
app.use('/api/users', createProxyMiddleware({
  target: 'http://users-service:3000',
  changeOrigin: true,
}));

app.use('/api/orders', createProxyMiddleware({
  target: 'http://orders-service:3000',
  changeOrigin: true,
}));

// ❌ Неправильно: Прямые вызовы между сервисами
import axios from 'axios';

const response = await axios.get('http://orders-service:3000/api/orders');
// Блокирует поток пользователя и ухудшает производительность
```

2. **Event-Driven Architecture**
```typescript
// ✅ Правильно: Producer с retry
import { Producer } from 'kafkajs';

const producer = new Producer({
  clientId: 'my-service',
  brokers: ['kafka:9092'],
});

export const emitEvent = async (event: Event) => {
  try {
    await producer.send({
      topic: 'events',
      messages: [{ value: JSON.stringify(event), key: event.id }],
    });
  } catch (error) {
    // Log error
    console.error('Failed to emit event:', error);
    throw error;  // Позволяет retry механизму
  }
};

// ❌ Неправильно: Producer без error handling и retry
const producer = new Producer();
producer.send({ topic: 'events', messages: [event] });
// Потеря события при сбое, нет повторной отправки
```

3. **Data Consistency (SAGA Pattern)**
```typescript
// ✅ Правильно: Orchestration Service
import { Saga } from 'redux-saga';

class OrderSaga extends Saga {
  // Define saga steps
  * createOrder() {
      yield call(CreateOrder);
      yield call(ReserveInventory);
      yield call(ProcessPayment);
      yield call(ConfirmOrder);
      if (isFailed) {
        yield call(CompensateInventory);
        yield call(CancelOrder);
      }
  }
}
```

4. **Circuit Breaker Pattern**
```typescript
// ✅ Правильно: Hystrix-like circuit breaker
import { CircuitBreaker } from 'opossum';

class ServiceClient extends CircuitBreaker {
  constructor(service: Service) {
    super({
      timeout: 3000,
      errorThresholdPercentage: 50,
      resetTimeout: 60000,
    });
  }
}

// ❌ Неправильно: Прямые вызовы без fallback
const result = await service.getData();
// При отказе сервиса приложение падает, нет механизма degradation
```

5. **Distributed Tracing**
```typescript
// ✅ Правильно: Jaeger tracing
import { Span, SpanContext } from 'jaeger-client';

export const executeTraced = async (operation: string) => {
  const span = tracer.startSpan(operation);
  
  try {
    const result = await executeOperation();
    span.setTag('status', 'success');
    return result;
  } catch (error) {
    span.setTag('status', 'error');
    span.log(error);
    throw error;
  } finally {
    span.finish();
  }
};
```

#### Чеклист перед завершением:
- [ ] Все сервисы определены с ответственностями
- [ ] Коммуникационные паттерны выбраны
- [ ] Стратегия согласованности данных выбрана
- [ ] Event flow определён
- [ ] API Gateway спроектирован
- [ ] Circuit breakers предусмотрены
- [ ] Distributed tracing добавлен

### ФАЗА 3: Microservices Validator (Проверка)

Действуй как Microservices Validator.

#### Проверка архитектуры:
```yaml
# ❌ FAIL если:
- Сильная связь между сервисами (тight coupling)
- Отсутствие isolation (shared database без шардирования)
- Нет scalability стратегии
- Отсутствие fault tolerance
- Missing observability

# ✅ PASS если:
- Loose coupling между сервисами (message broker/event bus)
- Database per service или proper sharding
- API Gateway для маршрутизации и rate limiting
- Circuit breakers для fault tolerance
- Distributed tracing (Jaeger/Zipkin)
- Service discovery (Consul/Kubernetes)
```

#### Проверка коммуникации:
```yaml
# ❌ FAIL если:
- Синхронные HTTP вызовы (blocking)
- Отсутствие обратного давления (backpressure)
- Нет повторной отправки (at least once delivery)
- Отсутствие идемпотентности (message IDs)
- Отсутствие обработки ошибок связи

# ✅ PASS если:
- Асинхронная коммуникация (message queues/events)
- Backpressure handling
- Idempotent producers
- Retry механизмы с exponential backoff
- Message ordering per service (partition keys)
```

#### Проверка безопасности:
```yaml
# ❌ FAIL если:
- Отсутствие аутентификации между сервисами
- Открытые endpoints без rate limiting
- Отсутствие шифрования коммуникации (TLS/mTLS)
- Отсутствие валидации входных данных

# ✅ PASS если:
- mTLS между сервисами
- JWT или OAuth2 для service-to-service
- Rate limiting на API Gateway
- Input validation в каждом сервисе
- Request signing для internal APIs
```

#### Формат результата:

**ЕСЛИ ОШИБКА:**
```markdown
⛔ MICROSERVICES VALIDATION FAILED

Причина: [Конкретная проблема]
Сервис: [service name]
Архитектурный аспект: [Communication/Data/Scalability]

Нарушение:
- [Specific rule from constraints.md]

Действие:
- Пересмотреть архитектурный аспект
- Добавить необходимые паттерны (circuit breakers, retry)

Возврат к ФАЗЕ 2
```

**ЕСЛИ ВСЁ OK:**
```markdown
✅ VALIDATION PASSED

Проверено:
- ✅ Архитектура соответствует microservices best practices
- ✅ Связи между сервисами асинхронные и слабосвязанные
- ✅ Data consistency стратегия определена
- ✅ Circuit breakers предусмотрены
- ✅ Observability добавлена
- ✅ Безопасность обеспечена

Микросервисная архитектура готова к реализации.
```

## 🎨 Common Microservices Patterns

### 1. API Gateway Pattern
```typescript
// Концепт
Client → API Gateway → Routing → Target Service

// Реализация
interface Route {
  path: string;
  targetService: string;
  method: string;
}

class APIGateway {
  private routes: Route[];
  
  constructor() {
    this.routes = [
      { path: '/api/users', targetService: 'users-service', method: 'GET' },
      { path: '/api/orders', targetService: 'orders-service', method: 'POST' },
      { path: '/api/inventory', targetService: 'inventory-service', method: 'GET' },
    ];
  }
  
  async handleRequest(req: Request, res: Response) {
    const route = this.routes.find(r => 
      req.path.startsWith(r.path) && req.method === r.method
    );
    
    if (!route) {
      return res.status(404).json({ error: 'Not found' });
    }
    
    return this.proxyToService(route.targetService, req, res);
  }
}
```

### 2. Saga Pattern (для distributed transactions)
```typescript
// Реализация
import { Saga } from 'redux-saga';

type OrderEvent =
  | { type: 'CREATE_ORDER', data: Order }
  | { type: 'RESERVE_INVENTORY', data: { orderId, itemId, qty } }
  | { type: 'PROCESS_PAYMENT', data: { orderId, paymentId } }
  | { type: 'CONFIRM_ORDER', data: { orderId } }
  | { type: 'COMPENSATE_INVENTORY', data: { orderId, items } };

class OrderSaga extends Saga<OrderEvent> {
  * createOrder(order: Order) {
    yield put({ type: 'CREATE_ORDER', data: order });
  }
  
  * reserveInventory(orderId: string, itemId: string, qty: number) {
    yield put({ 
      type: 'RESERVE_INVENTORY', 
      data: { orderId, itemId, qty }
    });
    
    // Проверка доступности
    const available = yield call(checkAvailability, itemId);
    if (!available) {
      return yield put({ type: 'ORDER_FAILED', data: orderId });
    }
    
    yield call(reserveItem, itemId, qty);
  }
  
  * processPayment(orderId: string, paymentId: string) {
    yield put({ 
      type: 'PROCESS_PAYMENT', 
      data: { orderId, paymentId }
    });
    
    const result = yield call(chargePayment, paymentId);
    if (result.status !== 'success') {
      return yield put({ 
        type: 'PAYMENT_FAILED', 
        data: { orderId } 
      });
    }
    
    yield put({ type: 'CONFIRM_ORDER', data: { orderId } });
  }
  
  * confirmOrder(orderId: string) {
    yield put({ type: 'CONFIRM_ORDER', data: { orderId } });
  }
  
  * compensateFailedOrder(orderId: string, reason: string) {
    // Компенсация при сбое
    yield call(refundInventory, orderId, reason);
  }
}
```

### 3. Event Sourcing Pattern
```typescript
// Реализация
interface OrderEvent {
  type: 'ORDER_CREATED' | 'ORDER_PAID' | 'ORDER_CANCELLED';
  orderId: string;
  data: any;
  timestamp: number;
}

class OrderEventStore {
  private events: OrderEvent[] = [];
  
  async saveEvent(event: OrderEvent) {
    this.events.push(event);
    // Сохранение в event store (Kafka/RabbitMQ)
    await eventBus.publish('orders', event);
  }
}
```

---

## 🚀 Частые сценарии

### S1: Создание нового микросервиса
1. **Architect:** Спроектирует сервис (endpoints, база, коммуникация)
2. **Developer:** Реализует сервис с шардированием БД
3. **Validator:** Проверяет изоляцию и производительность

### S2: Добавление Circuit Breaker
1. **Architect:** Определяет критерии (timeout, error threshold)
2. **Developer:** Реализует Hystrix pattern
3. **Validator:** Проверяет fallback logic

### S3: Миграция монолита в микросервисы
1. **Architect:** Планирует phased migration
2. **Developer:** Создаёт адаптеры для совместимости
3. **Validator:** Проверяет данные целостность во время миграции

---

## 📚 Связанные материалы

- [Microservices Patterns](https://microservices.io/patterns/)
- [Building Event-Driven Microservices](https://www.nginx.com/blog/building-microservices-using-an-event-driven-architecture)
- [Distributed Tracing](https://www.jaegertracing.io/docs/)
- [Circuit Breaker Pattern](https://martinfowler.com/bliki/CircuitBreaker/)
- [Saga Pattern](https://microservices.io/patterns/saga/)
