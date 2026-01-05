# 🤔 Sequential Thinking MCP Server

**Тип:** Structured Problem Solving  
**Источник:** Model Context Protocol Reference Implementation  
**Статус:** ✅ Стабильный

## 📖 Описание

Sequential Thinking - это MCP сервер для структурированного пошагового мышления и решения проблем. Позволяет AI ассистентам разбивать сложные задачи на этапы, корректировать подходы, ветвиться в альтернативные пути рассуждений и динамически корректировать общий план решения.

## 🛠️ Возможности

### Инструмент (Tool)

#### `sequentialthinking` - Структурированное мышление
**Параметры:**
- `thought` (string): Текущий шаг рассуждения
- `nextThoughtNeeded` (boolean): Нужен ли следующий шаг
- `thoughtNumber` (integer): Номер текущего шага
- `totalThoughts` (integer): Предполагаемое общее количество шагов
- `isRevision` (boolean, optional): Является ли это ревизией предыдущих мыслей
- `revisesThought` (integer, optional): Какой шаг пересматривается
- `branchFromThought` (integer, optional): От какого шага ветвится
- `branchId` (string, optional): Идентификатор ветки
- `needsMoreThoughts` (boolean, optional): Нужны ли дополнительные шаги

## 🎯 Применение

### Когда использовать
- **Разбиение сложных проблем** на управляемые этапы
- **Планирование с возможностью коррекции** подхода
- **Анализ требующий итеративных улучшений**
- **Проблемы с неясным полным scope** изначально
- **Задачи требующие сохранения контекста** между шагами
- **Ситуации с необходимостью фильтрации** нерелевантной информации

### Особенности
- **Динамическое планирование**: Корректировка общего количества шагов
- **Ветвление**: Создание альтернативных путей рассуждения
- **Ревизии**: Возможность пересмотра предыдущих решений
- **Генерация гипотез**: Создание и верификация решений

## 🚀 Установка

### NPX
```json
{
  "mcpServers": {
    "sequential-thinking": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-sequential-thinking"]
    }
  }
}
```

### Docker
```json
{
  "mcpServers": {
    "sequentialthinking": {
      "command": "docker",
      "args": ["run", "--rm", "-i", "mcp/sequentialthinking"]
    }
  }
}
```

## 📋 Использование

### Базовый рабочий процесс
```javascript
// Шаг 1: Анализ проблемы
await callTool("sequentialthinking", "sequentialthinking", {
  thought: "Анализирую требования к новой функции аутентификации",
  nextThoughtNeeded: true,
  thoughtNumber: 1,
  totalThoughts: 5
});

// Шаг 2: Планирование
await callTool("sequentialthinking", "sequentialthinking", {
  thought: "Определил основные компоненты: JWT токены, middleware, database schema",
  nextThoughtNeeded: true,
  thoughtNumber: 2,
  totalThoughts: 5
});

// Шаг 3: Корректировка плана (ревизия)
await callTool("sequentialthinking", "sequentialthinking", {
  thought: "Добавляю OAuth2 поддержку - план расширен до 7 шагов",
  nextThoughtNeeded: true,
  thoughtNumber: 3,
  totalThoughts: 7,
  isRevision: true,
  revisesThought: 2
});

// Шаг 4: Ветвление для альтернатив
await callTool("sequentialthinking", "sequentialthinking", {
  thought: "Рассматриваю два подхода к хранению токенов: Redis vs Database",
  nextThoughtNeeded: true,
  thoughtNumber: 4,
  totalThoughts: 7,
  branchFromThought: 3,
  branchId: "token-storage-options"
});

// Шаг 5: Выбор решения
await callTool("sequentialthinking", "sequentialthinking", {
  thought: "Выбираю Redis для лучшей производительности",
  nextThoughtNeeded: true,
  thoughtNumber: 5,
  totalThoughts: 7
});

// Шаг 6: Генерация гипотезы решения
await callTool("sequentialthinking", "sequentialthinking", {
  thought: "Гипотеза: JWT + Redis + middleware обеспечат безопасную аутентификацию",
  nextThoughtNeeded: true,
  thoughtNumber: 6,
  totalThoughts: 7
});

// Шаг 7: Верификация (финальный шаг)
await callTool("sequentialthinking", "sequentialthinking", {
  thought: "Верификация: решение покрывает все требования безопасности и производительности",
  nextThoughtNeeded: false,
  thoughtNumber: 7,
  totalThoughts: 7
});
```

### Продвинутые паттерны

#### Ревизия предыдущих решений
```javascript
await callTool("sequentialthinking", "sequentialthinking", {
  thought: "Пересматриваю архитектуру - микросервисы слишком сложны для этого проекта",
  nextThoughtNeeded: true,
  thoughtNumber: 8,
  totalThoughts: 10,
  isRevision: true,
  revisesThought: 5
});
```

#### Множественное ветвление
```javascript
// Ветка 1: Оптимистичный сценарий
await callTool("sequentialthinking", "sequentialthinking", {
  thought: "Оптимистичный сценарий: все интеграции пройдут гладко",
  nextThoughtNeeded: true,
  thoughtNumber: 9,
  totalThoughts: 12,
  branchFromThought: 7,
  branchId: "optimistic-path"
});

// Ветка 2: Пессимистичный сценарий
await callTool("sequentialthinking", "sequentialthinking", {
  thought: "Пессимистичный сценарий: подготовка плана отката",
  nextThoughtNeeded: true,
  thoughtNumber: 10,
  totalThoughts: 12,
  branchFromThought: 7,
  branchId: "pessimistic-path"
});
```

#### Динамическое расширение
```javascript
await callTool("sequentialthinking", "sequentialthinking", {
  thought: "Обнаружил дополнительные требования - расширяю план до 15 шагов",
  nextThoughtNeeded: true,
  thoughtNumber: 11,
  totalThoughts: 15,
  needsMoreThoughts: true
});
```

## 💡 Примеры сценариев

### Разработка ПО
```javascript
// 1. Анализ требований
// 2. Проектирование архитектуры
// 3. Планирование компонентов
// 4. Оценка рисков
// 5. Создание прототипа
// 6. Тестирование
// 7. Верификация решения
```

### Решение бизнес-задач
```javascript
// 1. Определение проблемы
// 2. Сбор данных
// 3. Анализ вариантов
// 4. Оценка воздействия
// 5. Выбор решения
// 6. План реализации
// 7. Мониторинг результатов
```

### Исследовательские задачи
```javascript
// 1. Формулировка гипотезы
// 2. Сбор доказательств
// 3. Анализ данных
// 4. Проверка альтернатив
// 5. Выводы и рекомендации
```

## ⚙️ Конфигурация

### Отключение логирования мыслей
```json
{
  "env": {
    "DISABLE_THOUGHT_LOGGING": "true"
  }
}
```

### VS Code
```json
{
  "servers": {
    "sequential-thinking": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-sequential-thinking"]
    }
  }
}
```

### Zed
```json
"context_servers": {
  "sequential-thinking": {
    "command": {
      "path": "npx",
      "args": ["-y", "@modelcontextprotocol/server-sequential-thinking"]
    }
  }
}
```

### Cursor
```json
{
  "mcpServers": {
    "sequential-thinking": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-sequential-thinking"]
    }
  }
}
```

## 🔧 Разработка

### Сборка Docker
```bash
docker build -t mcp/sequentialthinking -f src/sequentialthinking/Dockerfile .
```

### Дебаггинг
```bash
npx @modelcontextprotocol/inspector npx @modelcontextprotocol/server-sequential-thinking
```

## 📚 Ссылки

- [Исходный код](https://github.com/modelcontextprotocol/servers/tree/main/src/sequentialthinking)
- [Документация TypeScript пакета](https://www.npmjs.com/package/@modelcontextprotocol/server-sequential-thinking)

---

**Назначение:** Структурированное пошаговое мышление и решение комплексных проблем
