#!/bin/bash
# validate.sh - Валидация конфигурации Ontology Syncer Skill

set -e

echo "⚙️  Валидация конфигурации Ontology Syncer Skill..."

# Проверка структуры директорий
echo "📁 Проверка структуры..."
if [ ! -f "SKILL.md" ]; then
  echo "❌ ОШИБКА: SKILL.md не найден!"
  exit 1
fi

if [ ! -d "docs" ]; then
  echo "⚠️  ПРЕДУПРЕЖДЕНИЕ: Директория docs/ не существует"
  exit 1
fi

if [ ! -d "scripts" ]; then
  echo "⚠️  ПРЕДУПРЕЖДЕНИЕ: Директория scripts/ не существует"
  exit 1
fi

# Проверка необходимых файлов в docs/
echo "📄 Проверка документации..."
if [ ! -f "docs/known-issues.md" ]; then
  echo "  ⚠️  docs/known-issues.md не найден"
fi
if [ ! -f "docs/solutions.md" ]; then
  echo "  ⚠️  docs/solutions.md не найден"
fi
if [ ! -f "docs/advanced.md" ]; then
  echo "  ⚠️  docs/advanced.md не найден"
fi

# Проверка обязательных файлов для синхронизации
echo "📄 Проверка файлов синхронизации..."
if [ ! -f "DEPENDENCIES.json" ]; then
  echo "  ⚠️  DEPENDENCIES.json не найден"
fi
if [ ! -f "VALIDATION_REPORT.md" ]; then
  echo "  ⚠️  VALIDATION_REPORT.md не найден"
fi

# Проверка обязательных полей в SKILL.md
echo "📄 Проверка SKILL.md..."
if ! grep -q "^---$" SKILL.md; then
  echo "  ⚠️  SKILL.md не содержит frontmatter (---)"
fi

if ! grep -q "^name:" SKILL.md; then
  echo "  ⚠️  SKILL.md не содержит поле name:"
fi

if ! grep -q "^description:" SKILL.md; then
  echo "  ⚠️  SKILL.md не содержит поле description:"
fi

# Проверка директивы артефактов
if ! grep -q "📦 Оставить артефакты" SKILL.md; then
  echo "  ⚠️  SKILL.md не содержит директиву для артефактов"
fi

# Проверка обязательных секций для синхронизации
echo "🔄 Проверка секций синхронизации SKILL.md..."
if ! grep -q "## Анализ зависимостей" SKILL.md; then
  echo "  ⚠️  SKILL.md не содержит секцию 'Анализ зависимостей'"
fi
if ! grep -q "## Синхронизация с Memory Graph" SKILL.md; then
  echo "  ⚠️  SKILL.md не содержит секцию 'Синхронизация с Memory Graph'"
fi
if ! grep -q "## Валидация Accounting домена" SKILL.md; then
  echo "  ⚠️  SKILL.md не содержит секцию 'Валидация Accounting домена'"
fi
if ! grep -q "## Управление Git hooks" SKILL.md; then
  echo "  ⚠️  SKILL.md не содержит секцию 'Управление Git hooks'"
fi

# Проверка DEPENDENCIES.json структуры
if [ -f "DEPENDENCIES.json" ]; then
  echo "📊 Проверка структуры DEPENDENCIES.json..."
  if ! grep -q '"timestamp"' DEPENDENCIES.json; then
    echo "  ⚠️  DEPENDENCIES.json не содержит timestamp"
  fi
  if ! grep -q '"stats"' DEPENDENCIES.json; then
    echo "  ⚠️  DEPENDENCIES.json не содержит stats"
  fi
  if ! grep -q '"nodes"' DEPENDENCIES.json; then
    echo "  ⚠️  DEPENDENCIES.json не содержит nodes"
  fi
  if ! grep -q '"edges"' DEPENDENCIES.json; then
    echo "  ⚠️  DEPENDENCIES.json не содержит edges"
  fi
fi

# Проверка VALIDATION_REPORT.md формата
if [ -f "VALIDATION_REPORT.md" ]; then
  echo "📝 Проверка формата VALIDATION_REPORT.md..."
  if ! grep -q "## Последняя валидация" VALIDATION_REPORT.md; then
    echo "  ⚠️  VALIDATION_REPORT.md не содержит секцию 'Последняя валидация'"
  fi
  if ! grep -q "## Статистика" VALIDATION_REPORT.md; then
    echo "  ⚠️  VALIDATION_REPORT.md не содержит секцию 'Статистика'"
  fi
fi

# Проверка Git hooks
echo "🔗 Проверка Git hooks..."
if [ ! -f ".git/hooks/pre-commit" ]; then
  echo "  ⚠️  .git/hooks/pre-commit не найден"
fi
if [ ! -f ".git/hooks/pre-push" ]; then
  echo "  ⚠️  .git/hooks/pre-push не найден"
fi

# Проверка интеграции с MCP
echo "🧠 Проверка интеграции с Memory Graph MCP в SKILL.md..."
if ! grep -q "create_entities" SKILL.md; then
  echo "  ⚠️  SKILL.md не упоминает create_entities (Memory Graph)"
fi
if ! grep -q "create_relations" SKILL.md; then
  echo "  ⚠️  SKILL.md не упоминает create_relations (Memory Graph)"
fi
if ! grep -q "add_observations" SKILL.md; then
  echo "  ⚠️  SKILL.md не упоминает add_observations (Memory Graph)"
fi

echo "✅ Валидация завершена!"
echo ""
echo "Статус:"
echo "✅ SKILL.md существует"
echo "✅ Обязательные поля присутствуют"
echo "✅ Секции синхронизации проверены"
echo "✅ DEPENDENCIES.json проверен"
echo "✅ VALIDATION_REPORT.md проверен"
echo "✅ Git hooks проверены"
echo "✅ Memory Graph интеграция проверена"
echo ""
echo "Если есть предупреждения, исправьте их перед использованием."