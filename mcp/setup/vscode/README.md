# 🔧 VS Code + Cline MCP Setup
# Настройка Model Context Protocol для Cline

**Cline** - это AI-ассистент для VS Code, который поддерживает MCP серверы для расширения своих возможностей.

---

## 📋 Требования

- **VS Code** 1.80+
- **Cline extension** установлена
- **Node.js** 16+
- **npm** или **yarn**

---

## 🚀 Быстрая настройка

### Шаг 1: Скопируйте конфигурацию
```bash
# Из корня проекта AIRules
cp mcp/setup/vscode/settings.json ~/.vscode/settings.json

# Или добавьте в ваш .vscode/settings.json
cat mcp/setup/vscode/settings.json >> .vscode/settings.json
```

### Шаг 2: Установите переменные окружения
Создайте `.env` файл в корне проекта:
```env
# GitHub токен для доступа к репозиториям
GITHUB_TOKEN=your_github_personal_access_token

# Путь к браузеру Chrome (для разных ОС)
CHROME_PATH=/Applications/Google Chrome.app/Contents/MacOS/Google Chrome  # macOS
CHROME_PATH=/usr/bin/google-chrome                                        # Linux
CHROME_PATH=C:\Program Files\Google\Chrome\Application\chrome.exe        # Windows
```

### Шаг 3: Перезапустите VS Code
```bash
# Перезапустите VS Code для применения настроек
# Проверьте в Cline: MCP серверы должны появиться в списке
```

---

## ⚙️ Детальная конфигурация

### Основные MCP серверы

#### Chrome DevTools
```json
{
  "cline.mcpServers": {
    "chrome-devtools": {
      "command": "npx",
      "args": ["-y", "chrome-devtools-mcp@latest"],
      "env": {
        "CHROME_PATH": "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
      }
    }
  }
}
```

**Возможности:**
- `take_screenshot` - скриншоты страниц
- `take_snapshot` - HTML структура и accessibility tree
- `click` - клики по элементам
- `fill` - заполнение форм
- `evaluate_script` - выполнение JavaScript
- `performance_analyze` - анализ производительности

#### File System
```json
{
  "cline.mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem@latest"],
      "env": {
        "ALLOWED_PATHS": "${workspaceFolder}"
      }
    }
  }
}
```

**Возможности:**
- `read_file` - чтение файлов
- `list_dir` - список файлов в директории
- `search_files` - поиск по файлам
- `create_file` - создание файлов

#### Git
```json
{
  "cline.mcpServers": {
    "git": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-git@latest"],
      "env": {
        "GIT_REPO_PATH": "${workspaceFolder}"
      }
    }
  }
}
```

**Возможности:**
- `git_status` - статус репозитория
- `git_diff` - различия между коммитами
- `git_log` - история коммитов
- `git_commit` - создание коммитов

#### GitHub
```json
{
  "cline.mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github@latest"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "${env:GITHUB_TOKEN}"
      }
    }
  }
}
```

**Возможности:**
- `list_repositories` - список репозиториев
- `get_pull_request` - информация о PR
- `create_issue` - создание issues
- `search_code` - поиск по коду

---

## 🎨 Дополнительные MCP серверы

### Для Web-разработки
```json
{
  "cline.mcpServers": {
    "html-css-generator": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/html-css-generator@latest"]
    },
    "api-tester": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/api-tester@latest"]
    }
  }
}
```

### Для дизайна
```json
{
  "cline.mcpServers": {
    "figma": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/figma@latest"],
      "env": {
        "FIGMA_ACCESS_TOKEN": "${env:FIGMA_TOKEN}"
      }
    }
  }
}
```

### Для DevOps
```json
{
  "cline.mcpServers": {
    "docker": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/docker@latest"]
    },
    "kubernetes": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/kubernetes@latest"]
    }
  }
}
```

---

## 🔧 Расширенная настройка

### Кастомные переменные окружения
```json
{
  "cline.mcpServers": {
    "database": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/database@latest"],
      "env": {
        "DB_HOST": "${env:DB_HOST}",
        "DB_PORT": "${env:DB_PORT}",
        "DB_NAME": "${env:DB_NAME}",
        "DB_USER": "${env:DB_USER}",
        "DB_PASSWORD": "${env:DB_PASSWORD}"
      }
    }
  }
}
```

### Условная активация
```json
{
  "cline.mcpServers": {
    "production-only": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/production-tools@latest"],
      "disabled": "${env:NODE_ENV}" !== "production"
    }
  }
}
```

### Отладка MCP серверов
```json
{
  "cline.mcpServers": {
    "debug-server": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/debug-server@latest"],
      "env": {
        "DEBUG": "true",
        "LOG_LEVEL": "debug"
      }
    }
  }
}
```

---

## 🧪 Тестирование настройки

### Проверьте подключение
```bash
# В терминале VS Code
npx @modelcontextprotocol/client@latest ping chrome-devtools
npx @modelcontextprotocol/client@latest ping filesystem
```

### Тестовые команды в Cline
```
@chrome-devtools.take_screenshot
@filesystem.list_dir path="."
@git.git_status
@github.list_repositories
```

### Логи отладки
Если что-то не работает:
```bash
# В VS Code: View → Output → Cline
# Или в Developer Console: F12 → Console
```

---

## 🚨 Troubleshooting

### "MCP server not found"
```json
// Проверьте правильность пути
{
  "cline.mcpServers": {
    "chrome-devtools": {
      "command": "npx",
      "args": ["chrome-devtools-mcp@latest"]  // без -y
    }
  }
}
```

### "Permission denied"
```bash
# Установите правильные права
chmod +x $(which npx)
npm config set fund false
npm config set audit false
```

### "Environment variable not set"
```bash
# Создайте .env файл
echo "GITHUB_TOKEN=your_token_here" > .env
echo "CHROME_PATH=/usr/bin/google-chrome" >> .env
```

### "Timeout error"
```json
// Увеличьте timeout
{
  "cline.mcpServers": {
    "slow-server": {
      "command": "npx",
      "args": ["-y", "slow-mcp-server@latest"],
      "timeout": 30000
    }
  }
}
```

---

## 📚 Полезные ресурсы

- [Cline Documentation](https://docs.cline.bot) - официальная документация
- [MCP Specification](https://modelcontextprotocol.io/specification) - спецификация протокола
- [MCP Servers Registry](https://github.com/modelcontextprotocol/registry) - реестр серверов

---

## 🎯 Следующие шаги

После настройки базовых серверов:

1. **Изучите examples/** - посмотрите примеры использования
2. **Добавьте domain-specific серверы** из categories/
3. **Создайте кастомные workflow** для ваших задач
4. **Поделитесь конфигурацией** с командой

---

**Cline + MCP = AI с суперспособностями!** 🚀
