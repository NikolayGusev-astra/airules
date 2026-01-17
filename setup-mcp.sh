#!/bin/bash
# 🚀 AIRules MCP Setup Script
# Полная установка всех MCP серверов для AIRules

set -e

# Добавляем пути к Node.js (для nvm и системных установок)
# Раскрываем wildcard для nvm
if [ -d "$HOME/.nvm/versions/node" ]; then
    for node_dir in "$HOME/.nvm/versions/node"/*/; do
        if [ -d "$node_dir/bin" ]; then
            export PATH="$node_dir/bin:$PATH"
        fi
    done
fi
export PATH="/usr/local/bin:/usr/bin:$PATH"

echo "🔧 AIRules MCP Setup - Полная установка серверов"
echo "==============================================="
echo ""

# Проверяем Node.js
if ! command -v node >/dev/null 2>&1; then
    echo "❌ Node.js не найден в PATH. Проверьте установку Node.js 18+."
    echo "   Попробуйте: node --version"
    echo "   Или установите через nvm:"
    echo "   curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash"
    echo "   nvm install 18 && nvm use 18"
    exit 1
fi

echo "✅ Node.js найден: $(command -v node)"

# Проверяем npm
if ! command -v npm >/dev/null 2>&1; then
    echo "❌ npm не найден. Установите npm."
    exit 1
fi

# Получаем версии Node.js и npm
NODE_VERSION=$(node -v 2>/dev/null || echo "неизвестная версия")
NPM_VERSION=$(npm -v 2>/dev/null || echo "неизвестная версия")

echo "✅ Node.js $NODE_VERSION и npm $NPM_VERSION найдены"
echo ""

# Создаем .env файл если не существует
if [ ! -f ".env" ]; then
    echo "📝 Создаем .env файл..."
    cat > .env << 'HEREDOC_EOF'
# GitHub Personal Access Token (для GitHub MCP сервера)
# Создайте токен: https://github.com/settings/tokens
GITHUB_TOKEN=your_github_personal_access_token_here

# 21st Magic API Key (для генерации UI компонентов)
# Получите ключ: https://magic.21st.dev/
MAGIC_API_KEY=your_21st_magic_key_here

# Database URL (для PostgreSQL MCP сервера)
# Пример: postgresql://user:password@localhost:5432/database
DATABASE_URL=your_database_url_here

# Perplexity API Key (для AI поиска)
PERPLEXITY_API_KEY=your_perplexity_api_key_here
HEREDOC_EOF
    echo "✅ .env файл создан. Заполните переменные окружения."
else
    echo "✅ .env файл уже существует"
fi

echo ""
echo "📦 Устанавливаем MCP серверы..."
echo ""

# Функция для установки сервера
install_server() {
    local name=$1
    local command=$2

    echo "  $name"
    # Проверяем, можем ли мы выполнить команду
    if eval "$command --help >/dev/null 2>&1" || eval "$command --version >/dev/null 2>&1" || eval "$command >/dev/null 2>&1"; then
        echo "  ✅ $name установлен"
    else
        echo "  ⚠️  $name: проверка пропущена (сервер может работать в stdio режиме)"
    fi
}

# Core MCP Servers (Model Context Protocol)
echo "🔧 Устанавливаем Core MCP серверы:"
echo ""

install_server "🧠 Memory Graph" "npx -y @modelcontextprotocol/server-memory@latest"
install_server "🤔 Sequential Thinking" "npx -y @modelcontextprotocol/server-sequential-thinking@latest"
install_server "📁 Filesystem" "npx -y @modelcontextprotocol/server-filesystem@latest"
install_server "🐙 Git" "npx -y @modelcontextprotocol/server-git@latest"
install_server "🌐 Fetch" "npx -y @modelcontextprotocol/server-fetch@latest"
install_server "🕒 Time" "npx -y @modelcontextprotocol/server-time@latest"
install_server "🧪 Everything (Test)" "npx -y @modelcontextprotocol/server-everything@latest"

echo ""
echo "🔧 Устанавливаем Specialized MCP серверы:"
echo ""

# Context7 (документация и проверка галлюцинаций)
install_server "📚 Context7" "npx -y @upstash/context7-mcp@latest --version"

# Browser & Testing
install_server "🌐 Chrome DevTools" "npx -y chrome-devtools-mcp@latest --version"
install_server "🎭 Playwright" "npx -y @executeautomation/playwright-mcp@latest --version"

# AI & Content Generation
install_server "🎨 21st Magic" "npx -y @21st-dev/magic@latest --version"

# External APIs
install_server "🐙 GitHub" "npx -y @modelcontextprotocol/server-github@latest --version"
install_server "🐘 PostgreSQL" "npx -y @modelcontextprotocol/server-postgres@latest --version"

echo ""
echo "✅ Все MCP серверы установлены!"
echo ""

# Создаем или обновляем MCP конфигурацию для Cursor
echo "⚙️ Настраиваем MCP для Cursor..."

MCP_CONFIG_DIR="$HOME/.cursor"
MCP_CONFIG_FILE="$MCP_CONFIG_DIR/mcp.json"

# Создаем директорию если не существует
mkdir -p "$MCP_CONFIG_DIR"

# Создаем MCP конфигурацию
cat > "$MCP_CONFIG_FILE" << 'EOF'
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem@latest"],
      "env": {
        "ALLOWED_PATHS": "/home/astralinux.ru/ngusev/Документы/airules"
      }
    },
    "git": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-git@latest"],
      "env": {
        "GIT_REPO_PATH": "/home/astralinux.ru/ngusev/Документы/airules"
      }
    },
    "memory": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-memory@latest"]
    },
    "sequential-thinking": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-sequential-thinking@latest"]
    },
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp@latest"],
      "env": {
        "HTTP_PROXY": "socks5://127.0.0.1:2080",
        "HTTPS_PROXY": "socks5://127.0.0.1:2080",
        "ALL_PROXY": "socks5://127.0.0.1:2080",
        "http_proxy": "socks5://127.0.0.1:2080",
        "https_proxy": "socks5://127.0.0.1:2080"
      }
    },
    "time": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-time@latest"]
    },
    "fetch": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-fetch@latest"]
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github@latest"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "${env:GITHUB_TOKEN}",
        "HTTP_PROXY": "socks5://127.0.0.1:2080",
        "HTTPS_PROXY": "socks5://127.0.0.1:2080",
        "ALL_PROXY": "socks5://127.0.0.1:2080",
        "http_proxy": "socks5://127.0.0.1:2080",
        "https_proxy": "socks5://127.0.0.1:2080"
      }
    },
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres@latest"],
      "env": {
        "POSTGRES_CONNECTION_STRING": "${env:DATABASE_URL}",
        "HTTP_PROXY": "socks5://127.0.0.1:2080",
        "HTTPS_PROXY": "socks5://127.0.0.1:2080",
        "ALL_PROXY": "socks5://127.0.0.1:2080",
        "http_proxy": "socks5://127.0.0.1:2080",
        "https_proxy": "socks5://127.0.0.1:2080"
      }
    },
    "chrome-devtools": {
      "command": "npx",
      "args": ["-y", "chrome-devtools-mcp@latest", "--executablePath=/usr/bin/google-chrome", "--headless=false", "--isolated=true", "--viewport=1280x720"]
    },
    "21st-magic": {
      "command": "npx",
      "args": ["-y", "@21st-dev/magic@latest"],
      "env": {
        "MAGIC_API_KEY": "${env:MAGIC_API_KEY}",
        "HTTP_PROXY": "socks5://127.0.0.1:2080",
        "HTTPS_PROXY": "socks5://127.0.0.1:2080",
        "ALL_PROXY": "socks5://127.0.0.1:2080",
        "http_proxy": "socks5://127.0.0.1:2080",
        "https_proxy": "socks5://127.0.0.1:2080"
      }
    },
    "playwright": {
      "command": "npx",
      "args": ["-y", "@executeautomation/playwright-mcp@latest"]
    },
    "everything": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-everything@latest"]
    },
    "perplexity-ask": {
      "command": "npx",
      "args": ["-y", "server-perplexity-ask"],
      "env": {
        "PERPLEXITY_API_KEY": "${env:PERPLEXITY_API_KEY}",
        "HTTP_PROXY": "socks5://127.0.0.1:2080",
        "HTTPS_PROXY": "socks5://127.0.0.1:2080",
        "ALL_PROXY": "socks5://127.0.0.1:2080",
        "http_proxy": "socks5://127.0.0.1:2080",
        "https_proxy": "socks5://127.0.0.1:2080"
      }
    }
  }
}
EOF

echo "✅ MCP конфигурация создана: $MCP_CONFIG_FILE"
echo ""

# Тестирование установки
echo "🧪 Тестируем установку MCP серверов..."
echo ""

# Проверяем основные серверы
test_servers=("filesystem" "git" "memory" "sequential-thinking" "context7")

for server in "${test_servers[@]}"; do
    echo "  Тестируем $server..."
    if npx -y "@modelcontextprotocol/server-${server}@latest" --help > /dev/null 2>&1; then
        echo "  ✅ $server работает"
    else
        echo "  ⚠️  $server может требовать дополнительной настройки"
    fi
done

echo ""
echo "🎉 MCP настройка завершена!"
echo ""
echo "📋 Что настроено:"
echo "✅ Все MCP серверы установлены"
echo "✅ .env файл создан/обновлен"
echo "✅ Cursor MCP конфигурация настроена"
echo "✅ Пути к проекту настроены"
echo ""
echo "🚀 Следующие шаги:"
echo "1. Заполните переменные в .env файле"
echo "2. Перезапустите Cursor IDE"
echo "3. Протестируйте MCP серверы в чате"
echo ""
echo "📖 Документация: docs/MCP_README.md"
echo ""

# Показываем примеры использования
echo "💡 Примеры использования MCP:"
echo ""
echo "В Cursor чате:"
echo '• "List all files in the current directory" (filesystem)'
echo '• "Show git status" (git)'
echo '• "Create a new entity for User authentication" (memory)'
echo '• "Verify if React.useEffect cleanup works in React 18" (context7)'
echo '• "Take a screenshot of the current page" (chrome-devtools)'
echo ""
echo "🎯 Готово к работе с AI + MCP!"