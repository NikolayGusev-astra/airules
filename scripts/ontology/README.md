# AIRules Ontology Tools

Онтологические инструменты для анализа зависимостей, типов и валидации графа проекта.

## 📊 Инструменты

### 1. analyze-dependencies.js
**Назначение:** Комплексный анализ зависимостей проекта

**Что делает:**
- Строит граф импортов/экспортов между файлами
- Находит циклические зависимости
- Детектирует неиспользуемые экспорты
- Интегрируется с Memory Graph MCP
- Создаёт отчёт `docs/DEPENDENCIES.json`

**Использование:**
```bash
# Базовый анализ
node scripts/ontology/analyze-dependencies.js

# С интеграцией Memory Graph (если MCP доступен)
MCP_MEMORY_AVAILABLE=true node scripts/ontology/analyze-dependencies.js
```

**Вывод:**
```
🔍 AIRules Ontology - Dependency Analysis
=========================================

📂 Analyzing project dependencies...

📊 Files found:
   📄 Types: 5
   🧩 Components: 12
   🪝 Hooks: 3
   🏪 Stores: 2
   🔧 Utilities: 8
   🌐 API: 4
   📊 Total: 34

📊 Summary:
   🔗 Nodes (files): 34
   ➡️ Edges (imports): 89
   🔄 Cyclic dependencies: 0
   🗑️ Unused exports: 3

✅ Dependency analysis completed successfully!
```

### 2. sync-types.js
**Назначение:** Анализ использования TypeScript типов

**Что делает:**
- Парсит все `export type` и `export interface`
- Ищет использования типов по всему проекту
- Создаёт отчёт `docs/TYPES_REPORT.json`
- Анализирует сложность и паттерны использования

**Использование:**
```bash
node scripts/ontology/sync-types.js
```

**Вывод:**
```
🔍 AIRules Ontology - Type Usage Analysis
=========================================

📂 Analyzing TypeScript types...

📄 Found 5 type files:
   └─ src/types/accounting.ts
   └─ src/types/common.ts

📊 Total types analyzed: 15

📈 Usage Statistics:
   ✅ Used types: 12
   ⚠️ Unused types: 3
   📊 Usage rate: 80.0%

🏆 Most Used Types:
   1. Transaction (interface): 8 usages
   2. Account (type): 6 usages
```

### 3. validate-graph.js
**Назначение:** Валидация онтологического графа

**Что делает:**
- Проверяет наличие циклических зависимостей (CRITICAL)
- Контролирует порог неиспользуемых экспортов (WARNING)
- Проверяет актуальность анализа
- Возвращает exit codes для git hooks

**Использование:**
```bash
# Базовая валидация
node scripts/ontology/validate-graph.js

# Тихий режим для git hooks
node scripts/ontology/validate-graph.js --quiet

# Строгая валидация
node scripts/ontology/validate-graph.js --unused-threshold 5 --cycles-threshold 0

# Пользовательская конфигурация
node scripts/ontology/validate-graph.js \
  --report-path ./custom-report.json \
  --unused-threshold 20 \
  --max-imports 15 \
  --stale-hours 48
```

**Вывод:**
```
🔍 AIRules Ontology - Graph Validation
=======================================

🔄 Checking cyclic dependencies...
   ✅ No cyclic dependencies found

🗑️ Checking unused exports...
   ✅ Unused exports within threshold (3/10)

📊 Checking graph structure...
   ✅ Graph structure valid
      Nodes (files): 34
      Edges (imports): 89
      Average imports per file: 2.62

✅ ONTOLOGY VALIDATION: PASSED
   Graph is healthy and ready for commit
```

## 🔧 Git Hooks Integration

### Pre-commit Hook
Создайте `.git/hooks/pre-commit`:
```bash
#!/bin/sh

# Run ontology validation
node scripts/ontology/validate-graph.js --quiet

# If validation fails (exit code 1), commit is blocked
if [ $? -ne 0 ]; then
    echo "❌ Ontology validation failed. Fix issues before committing."
    exit 1
fi

echo "✅ Ontology validation passed"
```

### Pre-push Hook
Создайте `.git/hooks/pre-push`:
```bash
#!/bin/sh

# Stricter validation for pushes
node scripts/ontology/validate-graph.js \
  --quiet \
  --unused-threshold 5 \
  --cycles-threshold 0

if [ $? -ne 0 ]; then
    echo "❌ Strict ontology validation failed. Fix critical issues before pushing."
    exit 1
fi

echo "✅ Strict ontology validation passed"
```

## 📋 Конфигурация

### Переменные окружения
```bash
# Memory Graph MCP
MCP_MEMORY_AVAILABLE=true    # Включить интеграцию с MCP

# Пути к отчетам
DEPENDENCIES_REPORT_PATH=docs/DEPENDENCIES.json
TYPES_REPORT_PATH=docs/TYPES_REPORT.json
```

### Параметры валидации
```javascript
// В scripts/ontology/validate-graph.js
{
  cyclesThreshold: 0,      // Максимум циклов (0 = запрещены)
  unusedThreshold: 10,     // Порог предупреждения для неиспользуемых экспортов
  maxImportsPerFile: 20,   // Предупреждение при >20 импортов на файл
  staleHours: 24          // Отчет старее этого времени = предупреждение
}
```

## 🎯 Workflow использования

### 1. Анализ зависимостей
```bash
# После изменений в коде
node scripts/ontology/analyze-dependencies.js
```

### 2. Проверка типов (опционально)
```bash
# Для проектов с множеством типов
node scripts/ontology/sync-types.js
```

### 3. Валидация перед коммитом
```bash
# Автоматически через git hooks
# или вручную
node scripts/ontology/validate-graph.js
```

### 4. Просмотр отчетов
```bash
# Откройте в VS Code
code docs/DEPENDENCIES.json
code docs/TYPES_REPORT.json
```

## 📊 Формат отчетов

### DEPENDENCIES.json
```json
{
  "timestamp": "2026-01-08T17:00:00.000Z",
  "project": {
    "name": "airules",
    "root": "/path/to/project",
    "analyzer": "airules-ontology"
  },
  "summary": {
    "totalFiles": 34,
    "analyzedFiles": 32,
    "totalNodes": 32,
    "totalEdges": 89,
    "cyclesCount": 0,
    "unusedExportsCount": 3
  },
  "graph": {
    "nodes": [...],
    "edges": [...]
  },
  "cycles": [],
  "unusedExports": [...],
  "typeNodes": [...]
}
```

### TYPES_REPORT.json
```json
{
  "timestamp": "2026-01-08T17:00:00.000Z",
  "project": {
    "name": "airules",
    "analyzer": "airules-ontology-types"
  },
  "summary": {
    "totalFiles": 5,
    "totalTypes": 15,
    "usedTypes": 12,
    "unusedTypes": 3,
    "usageRate": 80.0
  },
  "types": [...],
  "unusedTypes": [...]
}
```

## 🚨 Exit Codes

| Код | Статус | Описание |
|-----|--------|----------|
| 0 | ✅ PASSED | Валидация успешна |
| 0 | ⚠️ WARNINGS | Прошла с предупреждениями |
| 1 | ❌ FAILED | Критические ошибки найдены |

## 🔍 Troubleshooting

### "DEPENDENCIES.json not found"
```bash
# Запустите анализ сначала
node scripts/ontology/analyze-dependencies.js
```

### "No TypeScript files found"
- Проверьте структуру проекта (ожидается `src/types/`)
- Убедитесь что файлы имеют расширение `.ts`
- Проверьте права доступа к файлам

### "Invalid JSON format"
```bash
# Удалите поврежденный файл и перезапустите анализ
rm docs/DEPENDENCIES.json
node scripts/ontology/analyze-dependencies.js
```

### Memory Graph MCP не работает
- Проверьте доступность MCP сервера
- Установите `MCP_MEMORY_AVAILABLE=false` для отключения
- Проверьте логи MCP сервера

## 🎨 Визуализация

### Граф зависимостей
Используйте онлайн-инструменты для визуализации JSON:
- [JSON Crack](https://jsoncrack.com)
- [JSON Visio](https://jsonvisio.com)
- [Code Beautify](https://codebeautify.org/jsonviewer)

### Mermaid диаграммы
Отчеты можно конвертировать в Mermaid для GitHub/GitLab:

```javascript
// Преобразование edges в Mermaid
const mermaid = edges.map(edge =>
  `"${nodes[edge.from].name}" --> "${nodes[edge.to].name}": ${edge.importName}`
).join('\n');
```

## 📈 Метрики качества

### Dependency Health Score
```
Score = (totalNodes - cyclesCount - unusedExportsCount) / totalNodes * 100
```

### Type Coverage
```
Coverage = usedTypes / totalTypes * 100
```

### Import Complexity
```
Complexity = averageImportsPerFile / maxRecommendedImports
```

## 🤝 Интеграция с CI/CD

### GitHub Actions
```yaml
- name: Ontology Validation
  run: node scripts/ontology/validate-graph.js --quiet
  continue-on-error: false

- name: Generate Reports
  run: |
    node scripts/ontology/analyze-dependencies.js
    node scripts/ontology/sync-types.js

- name: Upload Reports
  uses: actions/upload-artifact@v3
  with:
    name: ontology-reports
    path: docs/*.json
```

### Azure DevOps
```yaml
- script: node scripts/ontology/validate-graph.js --quiet
  displayName: 'Ontology Graph Validation'
  failOnStderr: true

- script: |
    node scripts/ontology/analyze-dependencies.js
    node scripts/ontology/sync-types.js
  displayName: 'Generate Ontology Reports'
```

## 📚 Дополнительные ресурсы

- [Ontology Schema](../ontology-schema.md) - Формальная схема онтологии
- [Memory Graph MCP](../../mcp/servers/memory.md) - Документация MCP
- [Role-based Development](../../basics/role-based-development.md) - AIRules основы

---

**AIRules Ontology Tools** обеспечивают качественный контроль зависимостей и архитектуры проекта.