#!/bin/bash

# Context7 Researcher Skill - Validate Script
# Валидация окружения для Context7 Researcher

echo "🔍 Валидация Context7 Researcher Skill..."

# Проверка необходимых файлов
required_files=(
  "SKILL.md"
  "docs/known-issues.md"
  "docs/solutions.md"
  "docs/advanced.md"
)

errors=0

for file in "${required_files[@]}"; do
  if [ ! -f "$file" ]; then
    echo "❌ ОШИБКА: Файл $file отсутствует"
    errors=$((errors + 1))
  else
    echo "✅ $file найден"
  fi
done

# Проверка структуры SKILL.md
if [ -f "SKILL.md" ]; then
  if ! grep -q "Context7" SKILL.md; then
    echo "⚠️  Предупреждение: SKILL.md не содержит упоминания Context7"
    errors=$((errors + 1))
  fi
  
  if ! grep -q "query-docs" SKILL.md; then
    echo "⚠️  Предупреждение: SKILL.md не упоминает query-docs"
    errors=$((errors + 1))
  fi
  
  if ! grep -q "resolve-library-id" SKILL.md; then
    echo "⚠️  Предупреждение: SKILL.md не упоминает resolve-library-id"
    errors=$((errors + 1))
  fi
fi

# Итог
echo ""
if [ $errors -eq 0 ]; then
  echo "✅ Валидация пройдена успешно!"
  exit 0
else
  echo "❌ Валидация не пройдена. Найдено $errors ошибок"
  exit 1
fi