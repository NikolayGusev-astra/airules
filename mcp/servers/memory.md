# 🧠 Memory MCP Server

**Тип:** Knowledge Graph Memory  
**Источник:** Model Context Protocol Reference Implementation  
**Статус:** ✅ Стабильный

## 📖 Описание

Memory - это MCP сервер для создания персистентной памяти в виде графа знаний. Позволяет AI ассистентам запоминать информацию о пользователях, отношениях и событиях между чат-сессиями, создавая структурированную базу знаний.

## 🛠️ Возможности

### Ядро концепций

#### Entities (Сущности)
Каждая сущность имеет:
- **name**: Уникальный идентификатор
- **entityType**: Тип (person, organization, event)
- **observations**: Массив фактов о сущности

Пример:
```json
{
  "name": "John_Smith",
  "entityType": "person",
  "observations": ["Speaks fluent Spanish", "Graduated in 2019"]
}
```

#### Relations (Отношения)
Активные связи между сущностями:
```json
{
  "from": "John_Smith",
  "to": "Anthropic",
  "relationType": "works_at"
}
```

#### Observations (Наблюдения)
Атомарные факты, связанные с сущностями

### Инструменты (Tools)

#### `create_entities` - Создание сущностей
**Параметры:**
- `entities` (array): Массив новых сущностей
**Игнорирует:** Сущности с существующими именами

#### `create_relations` - Создание отношений
**Параметры:**
- `relations` (array): Массив новых отношений
**Пропускает:** Дублирующиеся отношения

#### `add_observations` - Добавление наблюдений
**Параметры:**
- `observations` (array): Массив новых фактов
**Возвращает:** Добавленные наблюдения по сущностям

#### `delete_entities` - Удаление сущностей
**Параметры:**
- `entityNames` (string[]): Имена сущностей для удаления
**Особенности:** Каскадное удаление связанных отношений

#### `delete_observations` - Удаление наблюдений
**Параметры:**
- `deletions` (array): Наблюдения для удаления

#### `delete_relations` - Удаление отношений
**Параметры:**
- `relations` (array): Отношения для удаления

#### `read_graph` - Чтение всего графа
**Возвращает:** Полную структуру графа знаний

#### `search_nodes` - Поиск узлов
**Параметры:**
- `query` (string): Поисковый запрос
**Ищет в:** Имена сущностей, типы, наблюдения

#### `open_nodes` - Получение конкретных узлов
**Параметры:**
- `names` (string[]): Имена сущностей
**Возвращает:** Запрошенные сущности и их отношения

## 🚀 Установка

### NPX
```json
{
  "mcpServers": {
    "memory": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-memory"]
    }
  }
}
```

### Docker
```json
{
  "mcpServers": {
    "memory": {
      "command": "docker",
      "args": [
        "run",
        "-i",
        "-v", "claude-memory:/app/dist",
        "--rm",
        "mcp/memory"
      ]
    }
  }
}
```

### С кастомным путем к файлу
```json
{
  "mcpServers": {
    "memory": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-memory"],
      "env": {
        "MEMORY_FILE_PATH": "/path/to/custom/memory.jsonl"
      }
    }
  }
}
```

## 📋 Использование

### Создание сущностей
```javascript
await callTool("memory", "create_entities", {
  entities: [{
    name: "Alice_Johnson",
    entityType: "person",
    observations: ["Software Engineer", "Loves Python"]
  }, {
    name: "TechCorp",
    entityType: "organization",
    observations: ["AI Startup", "Founded in 2020"]
  }]
});
```

### Добавление отношений
```javascript
await callTool("memory", "create_relations", {
  relations: [{
    from: "Alice_Johnson",
    to: "TechCorp",
    relationType: "works_at"
  }]
});
```

### Добавление фактов
```javascript
await callTool("memory", "add_observations", {
  observations: [{
    entityName: "Alice_Johnson",
    contents: ["Specializes in ML", "Remote work preference"]
  }]
});
```

### Поиск информации
```javascript
// Поиск по имени или фактам
await callTool("memory", "search_nodes", {
  query: "Python"
});

// Получение конкретных сущностей
await callTool("memory", "open_nodes", {
  names: ["Alice_Johnson"]
});
```

### Чтение всего графа
```javascript
await callTool("memory", "read_graph", {});
```

## 💡 Примеры использования

### Персонализация чата
```javascript
// Системный промпт для Claude
"Follow these steps for each interaction:
1. User Identification: Assume default_user unless specified
2. Memory Retrieval: Always retrieve relevant information first
3. Memory Update: Add new information learned during conversation
4. Memory Query: Use stored knowledge to personalize responses"
```

### Рабочий процесс
```javascript
// 1. Получить текущую память
const memory = await callTool("memory", "read_graph", {});

// 2. Добавить новую информацию
await callTool("memory", "create_entities", {
  entities: [{
    name: "current_user",
    entityType: "person",
    observations: ["New conversation started"]
  }]
});

// 3. Создать отношения
await callTool("memory", "create_relations", {
  relations: [{
    from: "current_user",
    to: "AI_Assistant",
    relationType: "interacts_with"
  }]
});
```

## ⚙️ Конфигурация

### Переменные окружения
- `MEMORY_FILE_PATH`: Путь к файлу хранения памяти (default: `memory.jsonl`)

### Формат хранения
Память хранится в JSONL формате для эффективного чтения/записи

## 🔧 Разработка

### Сборка Docker
```bash
docker build -t mcp/memory -f src/memory/Dockerfile .
```

## 📚 Ссылки

- [Исходный код](https://github.com/modelcontextprotocol/servers/tree/main/src/memory)
- [Документация Python пакета](https://pypi.org/project/mcp-server-memory/)

---

**Назначение:** Персистентная память для AI ассистентов в виде графа знаний
