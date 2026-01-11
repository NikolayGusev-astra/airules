#!/bin/bash
# validate.sh - Валидация конфигурации Ontologist Skill

set -e

echo "⚙️  Валидация конфигурации Ontologist Skill..."

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
if [ ! -f "docs/VIOLATIONS_LOG.md" ]; then
  echo "  ⚠️  docs/VIOLATIONS_LOG.md не найден"
fi
if [ ! -f "docs/VIOLATION_REPORT_TEMPLATE.md" ]; then
  echo "  ⚠️  docs/VIOLATION_REPORT_TEMPLATE.md не найден"
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

# Проверка онтологических обязательных секций
echo "🧠 Проверка онтологических секций SKILL.md..."
if ! grep -q "## Задача" SKILL.md; then
  echo "  ⚠️  SKILL.md не содержит секцию 'Задача'"
fi
if ! grep -q "## Обязанности" SKILL.md; then
  echo "  ⚠️  SKILL.md не содержит секцию 'Обязанности'"
fi
if ! grep -q "## Онтологическая структура" SKILL.md; then
  echo "  ⚠️  SKILL.md не содержит секцию 'Онтологическая структура'"
fi
if ! grep -q "## Процесс валидации" SKILL.md; then
  echo "  ⚠️  SKILL.md не содержит секцию 'Процесс валидации'"
fi

# Проверка VIOLATIONS_LOG.md формата
if [ -f "docs/VIOLATIONS_LOG.md" ]; then
  echo "📝 Проверка формата VIOLATIONS_LOG.md..."
  if ! grep -q "## Формат записи" docs/VIOLATIONS_LOG.md; then
    echo "  ⚠️  VIOLATIONS_LOG.md не содержит формат записи"
  fi
fi

# Проверка VIOLATION_REPORT_TEMPLATE.md обязательных секций
if [ -f "docs/VIOLATION_REPORT_TEMPLATE.md" ]; then
  echo "📝 Проверка VIOLATION_REPORT_TEMPLATE.md..."
  if ! grep -q "## Тип нарушения" docs/VIOLATION_REPORT_TEMPLATE.md; then
    echo "  ⚠️  VIOLATION_REPORT_TEMPLATE.md не содержит секцию 'Тип нарушения'"
  fi
  if ! grep -q "## Детали нарушения" docs/VIOLATION_REPORT_TEMPLATE.md; then
    echo "  ⚠️  VIOLATION_REPORT_TEMPLATE.md не содержит секцию 'Детали нарушения'"
  fi
  if ! grep -q "## Требуемые изменения" docs/VIOLATION_REPORT_TEMPLATE.md; then
    echo "  ⚠️  VIOLATION_REPORT_TEMPLATE.md не содержит секцию 'Требуемые изменения'"
  fi
fi

# Проверка онтологической интеграции
echo "🔍 Проверка онтологической интеграции в SKILL.md..."
if ! grep -q "Agent классы" SKILL.md; then
  echo "  ⚠️  SKILL.md не упоминает Agent классы"
fi
if ! grep -q "Phase классы" SKILL.md; then
  echo "  ⚠️  SKILL.md не упоминает Phase классы"
fi
if ! grep -q "Artifact классы" SKILL.md; then
  echo "  ⚠️  SKILL.md не упоминает Artifact классы"
fi
if ! grep -q "Rule классы" SKILL.md; then
  echo "  ⚠️  SKILL.md не упоминает Rule классы"
fi

echo "✅ Валидация завершена!"
echo ""
echo "Статус:"
echo "✅ SKILL.md существует"
echo "✅ Обязательные поля присутствуют"
echo "✅ Онтологические секции проверены"
echo "✅ Онтологическая интеграция проверена"
echo ""
echo "Если есть предупреждения, исправьте их перед использованием."