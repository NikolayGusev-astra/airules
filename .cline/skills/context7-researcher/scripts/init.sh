#!/bin/bash

# Context7 Researcher Skill - Init Script
# Инициализация окружения для Context7 Researcher

echo "🔍 Инициализация Context7 Researcher Skill..."

# Проверка наличия директории docs
if [ ! -d "docs" ]; then
  mkdir -p docs
  echo "✅ Создана директория docs/"
fi

# Проверка наличия файлов документации
docs=("known-issues.md" "solutions.md" "advanced.md")

for doc in "${docs[@]}"; do
  if [ ! -f "docs/$doc" ]; then
    echo "⚠️  Предупреждение: Файл docs/$doc отсутствует"
  else
    echo "✅ docs/$doc существует"
  fi
done

# Проверка Context7 MCP
echo "📋 Проверка Context7 MCP..."
if command -v npx &> /dev/null; then
  echo "✅ Node.js установлен"
else
  echo "⚠️  Node.js не установлен. Требуется для Context7 MCP"
fi

echo ""
echo "🎉 Context7 Researcher Skill готов к использованию!"
echo ""
echo "📚 Доступные файлы документации:"
ls -la docs/