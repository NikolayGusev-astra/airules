#!/bin/bash

# RAG Expert Skill - Validate Script
# Валидация структуры и содержимого RAG Expert

echo "🔍 Валидация RAG Expert Skill..."

errors=0

# Проверка наличия обязательных файлов
echo "📋 Проверка обязательных файлов..."

required_files=(
  "SKILL.md"
  "docs/known-issues.md"
  "docs/solutions.md"
  "docs/advanced.md"
)

for file in "${required_files[@]}"; do
  if [ ! -f "$file" ]; then
    echo "❌ ОШИБКА: Отсутствует обязательный файл $file"
    ((errors++))
  else
    echo "✅ $file существует"
  fi
done

# Проверка содержимого SKILL.md
echo ""
echo "📋 Проверка содержимого SKILL.md..."

if [ -f "SKILL.md" ]; then
  if grep -q "RAG" SKILL.md; then
    echo "✅ SKILL.md содержит RAG"
  else
    echo "❌ ОШИБКА: SKILL.md не содержит RAG"
    ((errors++))
  fi
  
  if grep -q "vector" SKILL.md; then
    echo "✅ SKILL.md содержит vector"
  else
    echo "❌ ОШИБКА: SKILL.md не содержит vector"
    ((errors++))
  fi
  
  if grep -q "embedding" SKILL.md; then
    echo "✅ SKILL.md содержит embedding"
  else
    echo "❌ ОШИБКА: SKILL.md не содержит embedding"
    ((errors++))
  fi
fi

# Результат валидации
echo ""
if [ $errors -eq 0 ]; then
  echo "✅ Валидация пройдена успешно!"
  exit 0
else
  echo "❌ Валидация не пройдена. Найдено $errors ошибок."
  exit 1
fi