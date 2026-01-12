# 🧠 Ontology Protocol for Cursor

## 📖 Описание

Протокол для онтологической работы в Cursor AI. Специализирован на анализе зависимостей, валидации графов и Memory Graph интеграции.

## 🎯 Сферы применения

- Анализ зависимостей проекта
- Валидация структуры TypeScript
- Синхронизация с Memory Graph
- Проверка циклических зависимостей
- Онтологическая валидация ролей и артефактов

## 🔄 Рабочий процесс

### ФАЗА: Ontology Analyst

Действуй как Ontology Engineer и Dependency Analyst.

#### Задачи:
1. Анализ зависимостей между модулями
2. Валидация онтологической схемы
3. Синхронизация с Memory Graph
4. Проверка соответствия ролей и фаз
5. Автоматизация через Git hooks

#### Ограничения (STRICT):
- ✅ Работай только с зависимостями и структурой
- ✅ Следуй онтологической схеме
- ✅ Интегрируйся с Memory Graph

## 🔧 Инструменты анализа

### Ontology Scripts:

```bash
# Анализ зависимостей
node scripts/ontology/analyze-dependencies.js

# Валидация графа
node scripts/ontology/validate-graph.js

# Синхронизация типов
node scripts/ontology/sync-types.js
```

### Git Hooks:

```bash
# Pre-commit: анализ зависимостей
#!/bin/sh
node scripts/ontology/analyze-dependencies.js
git add docs/DEPENDENCIES.json

# Pre-push: валидация графа
#!/bin/sh
node scripts/ontology/validate-graph.js
```

## 📊 Онтологическая схема

### Основные классы:

```
Agent (Роль)
├── Architect (Планирование)
├── Executor (Выполнение)
└── Validator (Проверка)

Phase (Фаза)
├── Phase 1: Planning
├── Phase 2: Execution
└── Phase 3: Validation

Artifact (Артефакт)
├── TASK_SPEC.md
├── Source Code
├── Tests
└── Documentation
```

### Аксиомы валидации:

1. **Agent executes Phase:** Каждая роль выполняет определенную фазу
2. **Phase produces Artifact:** Каждая фаза создает артефакт
3. **Artifact belongs to Phase:** Артефакты принадлежат фазам
4. **No circular dependencies:** Нет циклических зависимостей

## 🔍 Анализ зависимостей

### Уровни анализа:

#### 1. File Dependencies (Файловые зависимости)
```json
{
  "src/api/users.ts": {
    "imports": ["src/types/User.ts", "src/lib/db.ts"],
    "exports": ["getUsers", "createUser"],
    "belongsTo": "API Layer"
  }
}
```

#### 2. Module Dependencies (Модульные зависимости)
```json
{
  "API Layer": {
    "dependsOn": ["Types Layer", "Database Layer"],
    "usedBy": ["Frontend Layer"],
    "circularDeps": false
  }
}
```

#### 3. Domain Dependencies (Доменовые зависимости)
```json
{
  "Accounting Domain": {
    "entities": ["Transaction", "Account", "Category"],
    "rules": ["NUMERIC_15_2", "NO_FLOAT", "TRANSFER_VS_EXPENSE"],
    "phases": ["Phase 1", "Phase 2", "Phase 3"]
  }
}
```

## 🧪 Валидация графа

### Проверки качества:

#### Структурная валидация:
- [ ] Нет циклических зависимостей
- [ ] Архитектурные слои соблюдены
- [ ] Domain boundaries не нарушены

#### Онтологическая валидация:
- [ ] Роли соответствуют классам Agent
- [ ] Фазы соответствуют классам Phase
- [ ] Артефакты соответствуют классам Artifact

#### Качественная валидация:
- [ ] Типы данных корректны (NUMERIC vs Float)
- [ ] Бизнес-правила соблюдены
- [ ] Тестовое покрытие достаточное

## 🔄 Memory Graph Integration

### Синхронизация знаний:

```typescript
// Автоматическая синхронизация
interface MemoryGraphSync {
  entities: Entity[];
  relationships: Relationship[];
  domains: Domain[];
  rules: Rule[];
}

// Entity types
interface Entity {
  id: string;
  type: 'class' | 'function' | 'interface' | 'module';
  name: string;
  file: string;
  domain: string;
}

// Relationship types
interface Relationship {
  from: string;
  to: string;
  type: 'imports' | 'extends' | 'implements' | 'uses';
  strength: number;
}
```

### MCP Memory Graph:

```javascript
// Использование через MCP
await use_mcp_tool("memory-graph", {
  action: "store",
  entity: {
    id: "UserService",
    type: "class",
    domain: "Authentication"
  }
});

await use_mcp_tool("memory-graph", {
  action: "query",
  pattern: "classes in Authentication domain"
});
```

## 📋 Формат отчетов

### DEPENDENCIES.json:

```json
{
  "timestamp": "2024-01-11T10:00:00Z",
  "project": "my-accounting-app",
  "domains": {
    "Accounting": {
      "entities": 15,
      "relationships": 23,
      "circularDeps": 0,
      "violations": []
    }
  },
  "files": {
    "src/services/TransactionService.ts": {
      "imports": 3,
      "exports": 5,
      "complexity": 12,
      "testCoverage": 85
    }
  },
  "recommendations": [
    "Consider splitting TransactionService into smaller modules",
    "Add more tests for edge cases in Account validation"
  ]
}
```

### Валидационный отчет:

```markdown
## Онтологическая валидация: ✅ PASSED

### Проверено:
- ✅ Domain boundaries соблюдены
- ✅ Agent-Phase-Artifact соответствие
- ✅ Нет циклических зависимостей
- ✅ Типы данных корректны
- ✅ Тестовое покрытие > 80%

### Рекомендации:
- ⚠️ Рассмотреть рефакторинг больших модулей
- 📈 Добавить больше интеграционных тестов
```

## 🎯 Специализированные домены

### Accounting Domain:
```json
{
  "rules": {
    "NUMERIC_15_2": "Все финансовые операции используют NUMERIC(15,2)",
    "NO_FLOAT": "Запрещено использование Float/Double",
    "TRANSFER_VS_EXPENSE": "Четкое разделение Transfer и Expense"
  },
  "entities": ["Transaction", "Account", "Category"],
  "phases": ["Planning", "Implementation", "Validation"]
}
```

### Web Development Domain:
```json
{
  "rules": {
    "TYPESCRIPT_STRICT": "TypeScript strict mode обязателен",
    "COMPONENT_STRUCTURE": "Единообразная структура компонентов",
    "ACCESSIBILITY": "WCAG 2.1 AA compliance"
  },
  "entities": ["Component", "Page", "Hook", "Service"],
  "phases": ["Design", "Implementation", "Testing"]
}
```

## 📚 Связанные материалы

- [Architect Protocol](./architect/protocol.md) — Планирование с учетом зависимостей
- [Backend Executor Protocol](./backend-executor/protocol.md) — Реализация с учетом графа
- [Validator Protocol](./validator/protocol.md) — Валидация структуры
- [Research Protocol](./research/protocol.md) — Исследование зависимостей