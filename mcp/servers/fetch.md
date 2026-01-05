# 🌐 Fetch MCP Server

**Тип:** Web Content Fetching  
**Источник:** Model Context Protocol Reference Implementation  
**Статус:** ✅ Стабильный

## 📖 Описание

Fetch - это MCP сервер для получения и обработки веб-контента. Позволяет AI ассистентам скачивать веб-страницы, конвертировать их в markdown и извлекать содержимое по частям для эффективного использования в LLM контексте.

## 🛠️ Возможности

### Инструменты (Tools)

#### `fetch` - Получение веб-контента
**Параметры:**
- `url` (string, required): URL для скачивания
- `max_length` (integer, optional): Максимальное количество символов (default: 5000)
- `start_index` (integer, optional): Начало извлечения контента (default: 0)
- `raw` (boolean, optional): Получить сырой контент без конвертации в markdown (default: false)

**Особенности:**
- Конвертация HTML в чистый markdown
- Поддержка chunks для больших страниц
- Соблюдение robots.txt
- Настраиваемый User-Agent

### Промпты (Prompts)

#### `fetch` - Быстрое получение URL
**Аргументы:**
- `url` (string, required): URL для скачивания

## 🚀 Установка

### UVX (рекомендуемый)
```json
{
  "mcpServers": {
    "fetch": {
      "command": "uvx",
      "args": ["mcp-server-fetch"]
    }
  }
}
```

### PIP
```json
{
  "mcpServers": {
    "fetch": {
      "command": "python",
      "args": ["-m", "mcp_server_fetch"]
    }
  }
}
```

### Docker
```json
{
  "mcpServers": {
    "fetch": {
      "command": "docker",
      "args": ["run", "-i", "--rm", "mcp/fetch"]
    }
  }
}
```

## 📋 Использование

### Получение веб-страницы
```javascript
// Скачать и конвертировать в markdown
await callTool("fetch", "fetch", {
  url: "https://example.com",
  max_length: 10000
});
```

### Чанки для больших страниц
```javascript
// Прочитать первые 5000 символов
await callTool("fetch", "fetch", {
  url: "https://long-article.com",
  max_length: 5000,
  start_index: 0
});

// Прочитать следующие 5000 символов
await callTool("fetch", "fetch", {
  url: "https://long-article.com",
  max_length: 5000,
  start_index: 5000
});
```

### Получение сырых данных
```javascript
await callTool("fetch", "fetch", {
  url: "https://api.example.com/data",
  raw: true
});
```

## ⚙️ Конфигурация

### Robots.txt
По умолчанию сервер соблюдает robots.txt файлы. Отключение:
```json
{
  "args": ["mcp-server-fetch", "--ignore-robots-txt"]
}
```

### User-Agent
Настройка User-Agent:
```json
{
  "args": ["mcp-server-fetch", "--user-agent", "Custom Bot 1.0"]
}
```

### Прокси
Использование прокси:
```json
{
  "args": ["mcp-server-fetch", "--proxy-url", "http://proxy.example.com:8080"]
}
```

### Windows конфигурация
```json
{
  "mcpServers": {
    "fetch": {
      "command": "uvx",
      "args": ["mcp-server-fetch"],
      "env": {
        "PYTHONIOENCODING": "utf-8"
      }
    }
  }
}
```

## 🔧 Разработка

### Установка зависимостей
```bash
pip install mcp-server-fetch
```

### Запуск
```bash
python -m mcp_server_fetch
```

### Дебаггинг
```bash
npx @modelcontextprotocol/inspector uvx mcp-server-fetch
```

## 📚 Ссылки

- [Исходный код](https://github.com/modelcontextprotocol/servers/tree/main/src/fetch)
- [Документация Python пакета](https://pypi.org/project/mcp-server-fetch/)

---

**Назначение:** Получение и обработка веб-контента для AI ассистентов
