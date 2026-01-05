# 📚 MCP Servers Index

Обзор всех доступных MCP серверов из Model Context Protocol Reference Implementation.

## 🎯 Reference Servers

Эти серверы поддерживаются командой Anthropic и демонстрируют основные возможности MCP протокола.

### ✅ Стабильные серверы

| Сервер | Назначение | Установка | Статус |
|--------|------------|-----------|--------|
| [**Context7**](context7.md) | Документация и примеры кода | `npx @upstash/context7-mcp` | ✅ Готов |
| [**Everything**](everything.md) | Тестирование всех MCP функций | `npx @modelcontextprotocol/server-everything` | ✅ Готов |
| [**Fetch**](fetch.md) | Получение веб-контента | `uvx mcp-server-fetch` | ✅ Готов |
| [**Filesystem**](filesystem.md) | Работа с файлами | `npx @modelcontextprotocol/server-filesystem` | ✅ Готов |
| [**Git**](git.md) | Git операции | `uvx mcp-server-git` | ✅ Готов |
| [**Memory**](memory.md) | Граф знаний | `npx @modelcontextprotocol/server-memory` | ✅ Готов |
| [**Sequential Thinking**](sequentialthinking.md) | Структурированное мышление | `npx @modelcontextprotocol/server-sequential-thinking` | ✅ Готов |
| [**Time**](time.md) | Работа со временем | `uvx mcp-server-time` | ✅ Готов |

## 🏷️ По категориям

### 🌐 Веб-разработка
- [**Fetch**](fetch.md) - Получение и обработка веб-контента
- [**Everything**](everything.md) - Тестирование веб-интеграций

### 📁 Работа с файлами
- [**Filesystem**](filesystem.md) - Полный набор операций с файлами и директориями

### 🐙 Версионный контроль
- [**Git**](git.md) - Полнофункциональное управление Git репозиториями

### 🤖 AI и мышление
- [**Memory**](memory.md) - Персистентная память в виде графа знаний
- [**Sequential Thinking**](sequentialthinking.md) - Структурированное пошаговое решение проблем

### 🕒 Утилиты
- [**Time**](time.md) - Конвертация времени между timezone

## 🚀 Быстрый старт

### 1. Выберите сервер по задаче
```bash
# Для работы с файлами
npx @modelcontextprotocol/server-filesystem /path/to/allowed/dir

# Для Git операций
uvx mcp-server-git --repository /path/to/repo

# Для веб-контента
uvx mcp-server-fetch

# Для памяти AI
npx @modelcontextprotocol/server-memory

# Для структурированного мышления
npx @modelcontextprotocol/server-sequential-thinking

# Для работы со временем
uvx mcp-server-time
```

### 2. Настройте в IDE
Пример для VS Code + Cline:
```json
{
  "cline.mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "${workspaceFolder}"]
    },
    "git": {
      "command": "uvx",
      "args": ["mcp-server-git"]
    }
  }
}
```

### 3. Используйте в работе
```javascript
// Примеры использования
await callTool("filesystem", "read_text_file", { path: "/file.txt" });
await callTool("git", "git_status", { repo_path: "/repo" });
await callTool("time", "get_current_time", { timezone: "Europe/Moscow" });
```

## 📋 Таблица совместимости

| Сервер | Windows | macOS | Linux | Docker | UVX | NPX | PIP |
|--------|---------|-------|-------|--------|-----|-----|-----|
| Everything | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ | ❌ |
| Fetch | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ |
| Filesystem | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ | ❌ |
| Git | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ |
| Memory | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ | ❌ |
| Sequential Thinking | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ | ❌ |
| Time | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ |

## 🔧 Разработка

Все серверы поддерживают:
- **stdio транспорт** (рекомендуемый)
- **HTTP+SSE транспорт** (deprecated)
- **Streamable HTTP транспорт** (новый)

Для разработки:
```bash
# Клонировать репозиторий
git clone https://github.com/modelcontextprotocol/servers.git

# Перейти в папку сервера
cd servers/src/filesystem

# Установить зависимости
npm install

# Запустить
npm run start
```

## 🧪 Тестирование

Используйте MCP Inspector для тестирования:
```bash
npx @modelcontextprotocol/inspector uvx mcp-server-fetch
```

## 📚 Документация

- [MCP Protocol Specification](https://modelcontextprotocol.io/specification/2025-03-26)
- [MCP SDK Documentation](https://modelcontextprotocol.io/docs)
- [Community Servers](https://registry.modelcontextprotocol.io/)

---

**Все серверы находятся в активной разработке. Следите за обновлениями в [репозитории MCP](https://github.com/modelcontextprotocol/servers).**
