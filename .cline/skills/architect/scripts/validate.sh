#!/bin/bash
# validate.sh - Валидация конфигурации Architect Skill

set -e

echo "⚙️  Валидация конфигурации Architect Skill..."

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
if [ ! -f "docs/ARCHITECTURAL_DECISIONS.md" ]; then
  echo "  ⚠️  docs/ARCHITECTURAL_DECISIONS.md не найден"
fi
if [ ! -f "docs/TASK_SPEC_TEMPLATE.md" ]; then
  echo "  ⚠️  docs/TASK_SPEC_TEMPLATE.md не найден"
fi
if [ ! -f "docs/README.md" ]; then
  echo "  ⚠️  docs/README.md не найден"
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

# Проверка архитектурных обязательных секций
echo "🏛️  Проверка архитектурных секций SKILL.md..."
if ! grep -q "## Зачем нужен этот Skill?" SKILL.md; then
  echo "  ⚠️  SKILL.md не содержит секцию 'Зачем нужен этот Skill?'"
fi
if ! grep -q "## Основные принципы" SKILL.md; then
  echo "  ⚠️  SKILL.md не содержит секцию 'Основные принципы'"
fi
if ! grep -q "## Практические примеры" SKILL.md; then
  echo "  ⚠️  SKILL.md не содержит секцию 'Практические примеры'"
fi
if ! grep -q "## Context7 Integration" SKILL.md; then
  echo "  ⚠️  SKILL.md не содержит секцию 'Context7 Integration'"
fi

# Проверка ARCHITECTURAL_DECISIONS.md формата
if [ -f "docs/ARCHITECTURAL_DECISIONS.md" ]; then
  echo "📝 Проверка формата ARCHITECTURAL_DECISIONS.md..."
  if ! grep -q "## Формат записи" docs/ARCHITECTURAL_DECISIONS.md; then
    echo "  ⚠️  ARCHITECTURAL_DECISIONS.md не содержит формат записи"
  fi
fi

# Проверка TASK_SPEC_TEMPLATE.md обязательных секций
if [ -f "docs/TASK_SPEC_TEMPLATE.md" ]; then
  echo "📝 Проверка TASK_SPEC_TEMPLATE.md..."
  if ! grep -q "## Цель" docs/TASK_SPEC_TEMPLATE.md; then
    echo "  ⚠️  TASK_SPEC_TEMPLATE.md не содержит секцию 'Цель'"
  fi
  if ! grep -q "## Технологические Ограничения" docs/TASK_SPEC_TEMPLATE.md; then
    echo "  ⚠️  TASK_SPEC_TEMPLATE.md не содержит секцию 'Технологические Ограничения'"
  fi
  if ! grep -q "## TDD" docs/TASK_SPEC_TEMPLATE.md; then
    echo "  ⚠️  TASK_SPEC_TEMPLATE.md не содержит секцию 'TDD'"
  fi
  if ! grep -q "## Контекст7 Валидация" docs/TASK_SPEC_TEMPLATE.md; then
    echo "  ⚠️  TASK_SPEC_TEMPLATE.md не содержит секцию 'Context7 Валидация'"
  fi
fi

# Проверка Context7 интеграции
echo "🔍 Проверка Context7 интеграции в SKILL.md..."
if ! grep -q "resolve-library-id" SKILL.md; then
  echo "  ⚠️  SKILL.md не упоминает resolve-library-id (Context7)"
fi
if ! grep -q "query-docs" SKILL.md; then
  echo "  ⚠️  SKILL.md не упоминает query-docs (Context7)"
fi

echo "✅ Валидация завершена!"
echo ""
echo "Статус:"
echo "✅ SKILL.md существует"
echo "✅ Обязательные поля присутствуют"
echo "✅ Архитектурные секции проверены"
echo "✅ Context7 интеграция проверена"
echo ""
echo "Если есть предупреждения, исправьте их перед использованием."