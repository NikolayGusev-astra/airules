#!/bin/bash
# init.sh - Инициализация окружения для Ontology Syncer Skill

set -e

echo "🔄 Инициализация Ontology Syncer Skill окружения..."

# Проверка зависимостей
if [ -f "package.json" ]; then
  echo "📦 Установка зависимостей..."
  npm install
else
  echo "⚠️  package.json не найден. Пропуск установки зависимостей."
fi

# Создание необходимых директорий для онтологической синхронизации
echo "📁 Создание структуры директорий..."
mkdir -p docs
mkdir -p docs/reports
mkdir -p docs/graphs
mkdir -p scripts/ontology
mkdir -p tests
mkdir -p e2e
mkdir -p reports
mkdir -p coverage

# Создание файла для DEPENDENCIES.json
echo "📝 Создание DEPENDENCIES.json..."
cat > DEPENDENCIES.json << 'EOF'
{
  "timestamp": "",
  "project": "",
  "stats": {
    "totalFiles": 0,
    "totalNodes": 0,
    "totalEdges": 0,
    "cyclicDependencies": 0,
    "unusedExports": 0
  },
  "nodes": [],
  "edges": [],
  "cycles": [],
  "unusedExports": []
}
EOF

# Создание файла для VALIDATION_REPORT.md
echo "📝 Создание VALIDATION_REPORT.md..."
cat > VALIDATION_REPORT.md << 'EOF'
# 📊 Отчёт о валидации онтологического графа

Этот отчёт содержит результаты проверки онтологического графа.

## Последняя валидация

**Дата:** -
**Статус:** Не выполнена

## Статистика

- **Всего файлов:** -
- **Всего узлов (nodes):** -
- **Всего связей (edges):** -
- **Циклические зависимости:** -
- **Неиспользуемые экспорты:** -

## Обнаруженные нарушения

(Здесь будут записаны нарушения при обнаружении)

## Синхронизация с Memory Graph

**Статус:** -
**Сущностей создано:** -
**Отношений создано:** -
**Наблюдений добавлено:** -

---
**Автоматически создано Ontology Syncer**
EOF

# Создание шаблона для Git hooks
echo "📝 Создание шаблона Git hooks..."
mkdir -p .git/hooks

# Pre-commit hook
cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash
# Pre-commit hook для Ontology Syncer

set -e

echo "🔄 Running Ontology Syncer pre-commit validation..."

# Анализ изменений
echo "📊 Analyzing dependencies..."
if [ -f "scripts/ontology/analyze-dependencies.js" ]; then
  node scripts/ontology/analyze-dependencies.js
else
  echo "⚠️  analyze-dependencies.js not found, skipping..."
fi

# Проверка циклов
if [ -f "DEPENDENCIES.json" ]; then
  cycles=$(node -e "try { const d = JSON.parse(require('fs').readFileSync('DEPENDENCIES.json')); console.log(d.stats.cyclicDependencies || 0); } catch(e) { console.log(0); }")
  if [ "$cycles" -gt 0 ]; then
    echo "❌ Cyclic dependencies detected: $cycles"
    echo "❌ Commit aborted."
    exit 1
  fi
fi

# Синхронизация с Memory Graph (если доступно)
echo "🧠 Syncing with Memory Graph (if available)..."
if command -v npx &> /dev/null; then
  npx -y @modelcontextprotocol/server-memory read_graph > /dev/null 2>&1 || echo "⚠️  Memory Graph unavailable"
fi

echo "✅ Pre-commit validation passed."
EOF

chmod +x .git/hooks/pre-commit

# Pre-push hook
cat > .git/hooks/pre-push << 'EOF'
#!/bin/bash
# Pre-push hook для Ontology Syncer

set -e

echo "🚀 Running Ontology Syncer pre-push validation..."

# Полная валидация графа
echo "📊 Validating dependency graph..."
if [ -f "scripts/ontology/validate-graph.js" ]; then
  node scripts/ontology/validate-graph.js
else
  echo "⚠️  validate-graph.js not found, skipping..."
fi

# Проверка неиспользуемых экспортов
if [ -f "DEPENDENCIES.json" ]; then
  unused=$(node -e "try { const d = JSON.parse(require('fs').readFileSync('DEPENDENCIES.json')); console.log(d.stats.unusedExports || 0); } catch(e) { console.log(0); }")
  if [ "$unused" -gt 20 ]; then
    echo "⚠️  Warning: Too many unused exports ($unused)"
    echo "Continue anyway? (y/N)"
    read -r response
    if [ "$response" != "y" ]; then
      echo "❌ Push aborted."
      exit 1
    fi
  fi
fi

# Проверка актуальности анализа
if [ -f "DEPENDENCIES.json" ]; then
  timestamp=$(node -e "try { const d = JSON.parse(require('fs').readFileSync('DEPENDENCIES.json')); console.log(d.timestamp || ''); } catch(e) { console.log(''); }")
  if [ -n "$timestamp" ]; then
    echo "✅ Analysis timestamp: $timestamp"
  else
    echo "⚠️  Analysis not performed yet. Run: npm run analyze-dependencies"
  fi
fi

echo "✅ Pre-push validation passed."
EOF

chmod +x .git/hooks/pre-push

# Создание README для документации
echo "📝 Создание README для документации..."
cat > docs/README.md << 'EOF'
# 🔄 Документация Ontology Syncer

Эта директория содержит артефакты онтологической синхронизации.

## Структура

- `reports/` — Отчёты о валидации
- `graphs/` — Визуализации графов (DOT, PNG)
- `VALIDATION_REPORT.md` — Главный отчёт о валидации
- `DEPENDENCIES.json` — Граф зависимостей проекта

## Использование

### Анализ зависимостей
```bash
npm run analyze-dependencies
```

### Валидация графа
```bash
npm run validate-graph
```

### Синхронизация с Memory Graph
```bash
npm run sync-memory-graph
```

## Git Hooks

Проект автоматически использует Git hooks:
- **pre-commit** — Анализ изменений перед коммитом
- **pre-push** — Полная валидация перед пушем

## Метрики успеха

- ✅ Zero cyclic dependencies
- ✅ Clean export usage (<10 unused)
- ✅ Fresh analysis (<48 hours)
- ✅ Memory Graph updated
- ✅ Accounting domain valid
- ✅ Git hooks active
EOF

# Проверка конфигурации
echo "⚙️  Проверка конфигурации..."
if [ -f "config.json" ] || [ -f ".skill.json" ]; then
  echo "✅ Конфигурация найдена"
else
  echo "⚠️  Конфигурация не найдена. Создайте config.json или .skill.json"
fi

echo "✅ Инициализация завершена!"
echo ""
echo "Следующие шаги:"
echo "1. Проверьте SKILL.md для инструкций"
echo "2. Запустите ./scripts/validate.sh для проверки конфигурации"
echo "3. Начните анализ зависимостей: npm run analyze-dependencies"
echo ""
echo "📝 Созданы файлы:"
echo "- DEPENDENCIES.json"
echo "- VALIDATION_REPORT.md"
echo "- docs/README.md"
echo "- .git/hooks/pre-commit"
echo "- .git/hooks/pre-push"