#!/bin/bash
# 🚀 AIRules MCP Setup Script
# Простая установка MCP серверов для AIRules

set -e

echo "🔧 Установка AIRules MCP серверов..."
echo ""

# Проверяем, установлены ли MCP серверы
if command -v mcp > /dev/null 2>&1; then
    echo "✅ MCP серверы уже установлены"
    echo ""
    echo "📋 Доступные серверы:"
    npx @modelcontextprotocol/client@latest list
    exit 0
fi

# Устанавливаем AIRules MCP серверы
echo "📦 Устанавливаем AIRules MCP серверы..."
echo ""

# Memory Graph
echo "  🧠 Memory Graph"
npx -y @modelcontextprotocol/server-memory@latest install
echo "✅ Memory Graph установлен"

# Sequential Thinking
echo "  🤔 Sequential Thinking"
npx -y @modelcontextprotocol/server-sequentialthinking@latest install
echo "✅ Sequential Thinking установлен"

# Context7
echo "  📚 Context7"
npx -y @upstash/context7-mcp@latest install
echo "✅ Context7 установлен"

# Chrome DevTools
echo "  🌐 Chrome DevTools"
npx -y chrome-devtools-mcp install
echo "✅ Chrome DevTools установлен"

# 21st Magic
echo "  🎨 21st Magic"
npx -y @21st-dev/magic@latest install
echo "✅ 21st Magic установлен"

# Playwright
echo "  🎭 Playwright"
npx -y @executeautomation/playwright-mcp@latest install
echo "✅ Playwright установлен"

echo ""
echo "✅ Все MCP серверы установлены!"
echo ""
echo "📝 Следующие шаги:"
echo "1. Создайте файл .env в корне проекта"
echo "2. Добавьте необходимые переменные окружения"
echo ""
echo "📖 Смотри .env.example для примера:"
cat << 'EOF'
# GitHub Personal Access Token (для работы с GitHub MCP)
GITHUB_TOKEN=your_github_personal_access_token_here

# 21st Magic API Key (для генерации UI компонентов)
MAGIC_API_KEY=your_21st_magic_key_here
EOF

echo ""
echo "🚀 Готово к работе с MCP!"