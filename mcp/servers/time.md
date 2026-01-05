# 🕒 Time MCP Server

**Тип:** Time & Timezone Management  
**Источник:** Model Context Protocol Reference Implementation  
**Статус:** ✅ Стабильный

## 📖 Описание

Time - это MCP сервер для работы со временем и часовыми поясами. Позволяет AI ассистентам получать текущее время в различных timezone, конвертировать время между часовыми поясами с использованием стандарта IANA.

## 🛠️ Возможности

### Инструменты (Tools)

#### `get_current_time` - Получение текущего времени
**Параметры:**
- `timezone` (string, required): IANA timezone имя (например, 'America/New_York', 'Europe/London')

**Возвращает:**
```json
{
  "timezone": "America/New_York",
  "datetime": "2024-01-01T13:00:00+01:00",
  "is_dst": false
}
```

#### `convert_time` - Конвертация времени
**Параметры:**
- `source_timezone` (string, required): Исходный IANA timezone
- `time` (string, required): Время в 24-часовом формате (HH:MM)
- `target_timezone` (string, required): Целевой IANA timezone

**Возвращает:**
```json
{
  "source": {
    "timezone": "America/New_York",
    "datetime": "2024-01-01T12:30:00-05:00",
    "is_dst": false
  },
  "target": {
    "timezone": "Asia/Tokyo",
    "datetime": "2024-01-01T12:30:00+09:00",
    "is_dst": false
  },
  "time_difference": "+13.0h"
}
```

## 🚀 Установка

### UVX (рекомендуемый)
```json
{
  "mcpServers": {
    "time": {
      "command": "uvx",
      "args": ["mcp-server-time"]
    }
  }
}
```

### PIP
```json
{
  "mcpServers": {
    "time": {
      "command": "python",
      "args": ["-m", "mcp_server_time"]
    }
  }
}
```

### Docker
```json
{
  "mcpServers": {
    "time": {
      "command": "docker",
      "args": ["run", "-i", "--rm", "mcp/time"]
    }
  }
}
```

## 📋 Использование

### Получение времени в разных timezone
```javascript
// Текущее время в Нью-Йорке
await callTool("time", "get_current_time", {
  timezone: "America/New_York"
});

// Текущее время в Лондоне
await callTool("time", "get_current_time", {
  timezone: "Europe/London"
});

// Текущее время в Токио
await callTool("time", "get_current_time", {
  timezone: "Asia/Tokyo"
});
```

### Конвертация времени между timezone
```javascript
// 4:30 PM в Нью-Йорке - сколько в Токио?
await callTool("time", "convert_time", {
  source_timezone: "America/New_York",
  time: "16:30",
  target_timezone: "Asia/Tokyo"
});

// 9:00 утра в Лондоне - сколько в Сан-Франциско?
await callTool("time", "convert_time", {
  source_timezone: "Europe/London",
  time: "09:00",
  target_timezone: "America/Los_Angeles"
});
```

### Примеры вопросов для Claude
```
"Какое сейчас время?"
"Сколько сейчас времени в Токио?"
"Когда 4 PM в Нью-Йорке, сколько времени в Лондоне?"
"Конвертируй 9:30 утра Токио во время Нью-Йорка"
```

## ⚙️ Конфигурация

### Кастомный системный timezone
```json
{
  "mcpServers": {
    "time": {
      "command": "uvx",
      "args": ["mcp-server-time", "--local-timezone=America/New_York"]
    }
  }
}
```

### VS Code
```json
{
  "mcp": {
    "servers": {
      "time": {
        "command": "uvx",
        "args": ["mcp-server-time"]
      }
    }
  }
}
```

### Zed
```json
"context_servers": {
  "time": {
    "command": "uvx",
    "args": ["mcp-server-time"]
  }
}
```

### Zencoder
```json
{
  "command": "uvx",
  "args": ["mcp-server-time"]
}
```

## 💡 Примеры сценариев

### Международные встречи
```javascript
// Планирование встречи между командами в разных timezone
const nyTime = await callTool("time", "get_current_time", {
  timezone: "America/New_York"
});

const londonTime = await callTool("time", "get_current_time", {
  timezone: "Europe/London"
});

const tokyoTime = await callTool("time", "get_current_time", {
  timezone: "Asia/Tokyo"
});

// Предложение времени встречи удобного для всех
```

### Релизы и дедлайны
```javascript
// Проверка времени релиза в разных регионах
const releaseTime = await callTool("time", "convert_time", {
  source_timezone: "America/Los_Angeles",
  time: "15:00",
  target_timezone: "Europe/Berlin"
});

// Релиз в 3 PM PST будет в 12 AM следующего дня в Берлине
```

### Работа с расписаниями
```javascript
// Конвертация бизнес-часов
const businessHours = await callTool("time", "convert_time", {
  source_timezone: "America/New_York",
  time: "09:00",
  target_timezone: "Asia/Singapore"
});

// 9 AM в Нью-Йорке = 9 PM в Сингапуре (следующий день)
```

## 🔧 Разработка

### Установка зависимостей
```bash
pip install mcp-server-time
```

### Запуск
```bash
python -m mcp_server_time
```

### Дебаггинг
```bash
npx @modelcontextprotocol/inspector uvx mcp-server-time
```

## 📚 Ссылки

- [Исходный код](https://github.com/modelcontextprotocol/servers/tree/main/src/time)
- [IANA Timezone Database](https://www.iana.org/time-zones)
- [Документация Python пакета](https://pypi.org/project/mcp-server-time/)

---

**Назначение:** Работа со временем и конвертация между часовыми поясами
