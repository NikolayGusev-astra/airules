# Ontology Tools Integration Examples

Примеры использования онтологических инструментов AIRules для различных сценариев разработки.

## 🚀 Быстрый старт

### 1. Базовая настройка проекта
```bash
# 1. Создайте структуру проекта
mkdir my-project && cd my-project
npm init -y

# 2. Скопируйте онтологические инструменты
cp -r /path/to/airules/scripts/ontology ./scripts/
cp -r /path/to/airules/examples/ontology-tools-integration.md ./docs/

# 3. Создайте базовую структуру src
mkdir -p src/{types,components,hooks,lib}

# 4. Запустите первый анализ
node scripts/ontology/analyze-dependencies.js
```

### 2. Первый анализ зависимостей
```bash
$ node scripts/ontology/analyze-dependencies.js

🔍 AIRules Ontology - Dependency Analysis
=========================================

📂 Analyzing project dependencies...

📊 Files found:
   📄 Types: 0
   🧩 Components: 0
   🪝 Hooks: 0
   🏪 Stores: 0
   🔧 Utilities: 0
   🌐 API: 0
   📊 Total: 0

❌ ERROR: src directory not found: /path/to/project/src
   This tool is designed for projects with src/ directory structure.
```

### 3. Создание структуры и первого файла
```typescript
// src/types/index.ts
export interface User {
  id: string;
  name: string;
  email: string;
}

export type UserRole = 'admin' | 'user' | 'guest';
```

```bash
# Повторный анализ
node scripts/ontology/analyze-dependencies.js

# Вывод:
📊 Files found:
   📄 Types: 1
   📊 Total: 1

📊 Summary:
   🔗 Nodes (files): 1
   ➡️ Edges (imports): 0
   🔄 Cyclic dependencies: 0
   🗑️ Unused exports: 2

🗑️ Unused exports: 2
  - index.ts: export 'User' (line 1)
  - index.ts: export 'UserRole' (line 8)
```

## 📋 Сценарии использования

### Сценарий 1: React + TypeScript проект

#### Структура проекта
```
my-react-app/
├── src/
│   ├── types/
│   │   ├── user.ts
│   │   ├── api.ts
│   │   └── index.ts
│   ├── components/
│   │   ├── UserProfile.tsx
│   │   ├── LoginForm.tsx
│   │   └── Button.tsx
│   ├── hooks/
│   │   ├── useAuth.ts
│   │   └── useApi.ts
│   └── lib/
│       ├── api.ts
│       └── utils.ts
└── scripts/
    └── ontology/
```

#### Анализ зависимостей
```bash
$ node scripts/ontology/analyze-dependencies.js

📊 Files found:
   📄 Types: 3
   🧩 Components: 3
   🪝 Hooks: 2
   🔧 Utilities: 2
   📊 Total: 10

📊 Summary:
   🔗 Nodes (files): 10
   ➡️ Edges (imports): 15
   🔄 Cyclic dependencies: 0
   🗑️ Unused exports: 1

✅ Dependency analysis completed successfully!
```

#### Анализ типов
```bash
$ node scripts/ontology/sync-types.js

📄 Found 3 type files:
   └─ src/types/user.ts
   └─ src/types/api.ts
   └─ src/types/index.ts

📊 Total types analyzed: 8

📈 Usage Statistics:
   ✅ Used types: 7
   ⚠️ Unused types: 1
   📊 Usage rate: 87.5%

🏆 Most Used Types:
   1. User (interface): 5 usages
   2. ApiResponse (type): 3 usages
```

### Сценарий 2: Next.js API проект

#### Структура проекта
```
nextjs-api/
├── src/
│   ├── types/
│   │   ├── database.ts
│   │   └── api.ts
│   ├── lib/
│   │   ├── db.ts
│   │   ├── auth.ts
│   │   └── validation.ts
│   └── app/
│       └── api/
│           ├── users/
│           │   ├── route.ts
│           │   └── [id]/
│           │       └── route.ts
│           └── auth/
│               ├── login/
│               │   └── route.ts
│               └── logout/
│                   └── route.ts
```

#### Результаты анализа
```bash
📊 Files found:
   📄 Types: 2
   🔧 Utilities: 3
   🌐 API: 4
   📊 Total: 9

📊 Summary:
   🔗 Nodes (files): 9
   ➡️ Edges (imports): 18
   🔄 Cyclic dependencies: 1

🔄 Cyclic dependencies: 1
  Cycle 1: db.ts → validation.ts → db.ts

❌ ONTOLOGY VALIDATION: FAILED
   Critical errors: 1
   ⚠️ Commit blocked - fix critical issues first
```

#### Исправление циклической зависимости
```typescript
// Было: validation.ts импортировал db.ts для проверки уникальности
// Стало: validation.ts принимает dbClient как параметр

// lib/validation.ts
export function validateUser(userData: UserInput, dbClient: DatabaseClient) {
  // Проверка через переданный dbClient
}

// lib/db.ts
export async function createUser(userData: UserInput) {
  const dbClient = getDbClient();
  const validatedData = await validateUser(userData, dbClient);
  // ... создание пользователя
}
```

### Сценарий 3: Монолитное приложение с множеством модулей

#### Проблема: Слишком много импортов в одном файле
```bash
📊 Checking graph structure...
   ✅ Graph structure valid
      Nodes (files): 45
      Edges (imports): 120
      Average imports per file: 2.67

⚠️ WARNING: High average imports per file (2.67)
   Consider breaking down files with many dependencies
```

#### Решение: Рефакторинг крупных файлов
```typescript
// Было: один большой файл с 15+ импортами
// app/dashboard/page.tsx
import { useState, useEffect } from 'react';
import { User } from '@/types/user';
import { ApiService } from '@/lib/api';
import { AuthContext } from '@/contexts/auth';
import { DashboardLayout } from '@/components/layouts';
import { StatsCard, Chart, Table } from '@/components/ui';
// ... ещё 10 импортов

// Стало: разделение на логические модули
// hooks/useDashboard.ts
export function useDashboard() {
  // Логика dashboard
}

// components/Dashboard/Dashboard.tsx
export function Dashboard() {
  // UI компонент
}
```

## 🔧 Git Hooks интеграция

### Pre-commit hook для автоматической валидации
```bash
#!/bin/sh
# .git/hooks/pre-commit

echo "🔍 Running ontology validation..."

# Тихий режим для автоматизации
node scripts/ontology/validate-graph.js --quiet

if [ $? -ne 0 ]; then
    echo "❌ Ontology validation failed!"
    echo "   Fix critical issues before committing."
    echo ""
    echo "   Run: node scripts/ontology/validate-graph.js"
    echo "   to see detailed error report."
    exit 1
fi

echo "✅ Ontology validation passed"
```

### Pre-push hook для строгой проверки
```bash
#!/bin/sh
# .git/hooks/pre-push

echo "🛡️ Running strict ontology validation..."

# Более строгие правила для push
node scripts/ontology/validate-graph.js \
  --quiet \
  --unused-threshold 5 \
  --cycles-threshold 0 \
  --max-imports 15

if [ $? -ne 0 ]; then
    echo "❌ Strict ontology validation failed!"
    echo "   Critical issues must be fixed before pushing."
    exit 1
fi

echo "✅ Strict ontology validation passed"
```

### Автоматическая настройка hooks
```bash
# Скрипт для настройки git hooks
#!/bin/bash
# scripts/setup-git-hooks.sh

HOOKS_DIR=".git/hooks"
ONTOLOGY_DIR="scripts/ontology"

# Создать pre-commit hook
cat > "$HOOKS_DIR/pre-commit" << EOF
#!/bin/sh
node $ONTOLOGY_DIR/validate-graph.js --quiet
EOF

# Создать pre-push hook
cat > "$HOOKS_DIR/pre-push" << EOF
#!/bin/sh
node $ONTOLOGY_DIR/validate-graph.js --quiet --unused-threshold 5
EOF

# Сделать executable
chmod +x "$HOOKS_DIR/pre-commit"
chmod +x "$HOOKS_DIR/pre-push"

echo "✅ Git hooks configured for ontology validation"
```

## 📊 CI/CD интеграция

### GitHub Actions workflow
```yaml
# .github/workflows/ontology.yml
name: Ontology Validation

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  ontology-validation:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v3

    - name: Setup Node.js
      uses: actions/setup-node@v3
      with:
        node-version: '18'
        cache: 'npm'

    - name: Install dependencies
      run: npm ci

    - name: Run ontology analysis
      run: node scripts/ontology/analyze-dependencies.js

    - name: Run type analysis
      run: node scripts/ontology/sync-types.js

    - name: Validate ontology graph
      run: node scripts/ontology/validate-graph.js --unused-threshold 15

    - name: Upload reports
      uses: actions/upload-artifact@v3
      with:
        name: ontology-reports
        path: docs/*.json
      if: always()
```

### Azure DevOps pipeline
```yaml
# azure-pipelines.yml
trigger:
  - main
  - develop

pool:
  vmImage: 'ubuntu-latest'

steps:
- task: NodeTool@0
  inputs:
    versionSpec: '18.x'
  displayName: 'Setup Node.js'

- script: npm ci
  displayName: 'Install dependencies'

- script: node scripts/ontology/validate-graph.js --quiet
  displayName: 'Ontology Validation'
  failOnStderr: true

- script: |
    node scripts/ontology/analyze-dependencies.js
    node scripts/ontology/sync-types.js
  displayName: 'Generate Ontology Reports'

- task: PublishBuildArtifacts@1
  inputs:
    pathtoPublish: 'docs'
    artifactName: 'OntologyReports'
  condition: always()
  displayName: 'Publish Ontology Reports'
```

## 🎨 Визуализация результатов

### Визуализация графа зависимостей
```javascript
// scripts/visualize-dependencies.js
const fs = require('fs');
const report = JSON.parse(fs.readFileSync('docs/DEPENDENCIES.json'));

// Преобразование в Mermaid
function toMermaid(report) {
  const { nodes, edges } = report.graph;
  let mermaid = 'graph TD\n';

  // Добавить узлы
  nodes.forEach(node => {
    const shape = getShapeForCategory(node.category);
    mermaid += `  ${node.id}${shape}"${node.name}<br/>${node.category}"\n`;
  });

  // Добавить связи
  edges.forEach(edge => {
    mermaid += `  ${edge.from} --> ${edge.to}\n`;
  });

  return mermaid;
}

function getShapeForCategory(category) {
  const shapes = {
    'type': '([ ])',
    'component': '[/ ]',
    'hook': '{{ }}',
    'utility': '(())',
    'store': '[[]]',
    'api': '{{{ }}}'
  };
  return shapes[category] || '[ ]';
}

const mermaid = toMermaid(report);
fs.writeFileSync('docs/DEPENDENCIES.md', `# Dependencies Graph\n\n\`\`\`mermaid\n${mermaid}\n\`\`\`\``);

console.log('📊 Mermaid diagram saved to docs/DEPENDENCIES.md');
```

### Создание HTML отчета
```javascript
// scripts/generate-html-report.js
const fs = require('fs');
const report = JSON.parse(fs.readFileSync('docs/DEPENDENCIES.json'));

const html = `
<!DOCTYPE html>
<html>
<head>
    <title>Ontology Report - ${report.project.name}</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .metric { background: #f5f5f5; padding: 10px; margin: 10px 0; border-radius: 5px; }
        .error { color: red; }
        .warning { color: orange; }
        .success { color: green; }
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
    </style>
</head>
<body>
    <h1>🧠 Ontology Analysis Report</h1>
    <p><strong>Project:</strong> ${report.project.name}</p>
    <p><strong>Generated:</strong> ${new Date(report.timestamp).toLocaleString()}</p>

    <h2>📊 Summary</h2>
    <div class="metric">
        <strong>Total Files:</strong> ${report.summary.totalFiles}<br>
        <strong>Dependencies:</strong> ${report.summary.totalEdges}<br>
        <strong>Cycles:</strong> <span class="${report.summary.cyclesCount > 0 ? 'error' : 'success'}">${report.summary.cyclesCount}</span><br>
        <strong>Unused Exports:</strong> <span class="${report.summary.unusedExportsCount > 10 ? 'warning' : 'success'}">${report.summary.unusedExportsCount}</span>
    </div>

    ${report.cycles.length > 0 ? `
    <h2>🔄 Cyclic Dependencies</h2>
    <ul>
        ${report.cycles.map(cycle =>
          `<li>${cycle.map(id => report.graph.nodes.find(n => n.id === id)?.name).join(' → ')}</li>`
        ).join('')}
    </ul>
    ` : ''}

    <h2>📁 Files by Category</h2>
    <table>
        <tr><th>Category</th><th>Count</th></tr>
        ${Object.entries(
          report.graph.nodes.reduce((acc, node) => {
            acc[node.category] = (acc[node.category] || 0) + 1;
            return acc;
          }, {})
        ).map(([cat, count]) => `<tr><td>${cat}</td><td>${count}</td></tr>`).join('')}
    </table>
</body>
</html>`;

fs.writeFileSync('docs/DEPENDENCIES.html', html);
console.log('📄 HTML report saved to docs/DEPENDENCIES.html');
```

## 🔧 Расширенная конфигурация

### Кастомные правила валидации
```javascript
// scripts/ontology/custom-validation.js
const fs = require('fs');
const path = require('path');

class CustomOntologyValidator {
  constructor(config = {}) {
    this.config = {
      // Кастомные правила для конкретного проекта
      forbiddenImports: ['lodash', 'moment'], // Запрещенные библиотеки
      requiredCategories: ['type', 'component'], // Обязательные категории
      maxFileSize: 1000, // Максимальный размер файла в строках
      ...config
    };
  }

  validateProject() {
    const report = JSON.parse(fs.readFileSync('docs/DEPENDENCIES.json'));
    const issues = [];

    // Проверка запрещенных импортов
    report.graph.edges.forEach(edge => {
      if (this.config.forbiddenImports.some(lib => edge.importPath.includes(lib))) {
        issues.push({
          type: 'error',
          message: `Forbidden import: ${edge.importPath} in ${report.graph.nodes[edge.from].name}`,
          file: report.graph.nodes[edge.from].path
        });
      }
    });

    // Проверка обязательных категорий
    const categories = [...new Set(report.graph.nodes.map(n => n.category))];
    this.config.requiredCategories.forEach(required => {
      if (!categories.includes(required)) {
        issues.push({
          type: 'warning',
          message: `Missing required category: ${required}`,
          file: null
        });
      }
    });

    return issues;
  }
}

module.exports = CustomOntologyValidator;
```

### Интеграция с ESLint
```javascript
// .eslintrc.js
module.exports = {
  // ... другие правила

  rules: {
    // Кастомное правило для проверки онтологии
    'ontology/no-circular-deps': 'error',
    'ontology/max-imports': ['warn', { max: 10 }],
    'ontology/require-types': 'error'
  },

  plugins: [
    // Плагин для онтологических правил
    'eslint-plugin-ontology'
  ]
};
```

## 📈 Мониторинг и метрики

### Периодический анализ проекта
```bash
# Добавьте в package.json
{
  "scripts": {
    "ontology:analyze": "node scripts/ontology/analyze-dependencies.js",
    "ontology:types": "node scripts/ontology/sync-types.js",
    "ontology:validate": "node scripts/ontology/validate-graph.js",
    "ontology:all": "npm run ontology:analyze && npm run ontology:types && npm run ontology:validate",
    "ontology:watch": "nodemon --exec 'npm run ontology:all' --ext ts,tsx,js,jsx"
  }
}

# Еженедельный анализ
# crontab -e
# 0 9 * * 1 cd /path/to/project && npm run ontology:all
```

### Отслеживание трендов
```javascript
// scripts/track-metrics.js
const fs = require('fs');

function trackMetrics() {
  const report = JSON.parse(fs.readFileSync('docs/DEPENDENCIES.json'));
  const metricsFile = 'docs/metrics-history.json';

  let history = [];
  if (fs.existsSync(metricsFile)) {
    history = JSON.parse(fs.readFileSync(metricsFile));
  }

  const metrics = {
    timestamp: report.timestamp,
    nodes: report.summary.totalNodes,
    edges: report.summary.totalEdges,
    cycles: report.summary.cyclesCount,
    unused: report.summary.unusedExportsCount,
    complexity: report.summary.totalEdges / report.summary.totalNodes
  };

  history.push(metrics);

  // Ограничить историю последними 30 запусками
  if (history.length > 30) {
    history = history.slice(-30);
  }

  fs.writeFileSync(metricsFile, JSON.stringify(history, null, 2));

  // Показать тренды
  if (history.length >= 2) {
    const latest = history[history.length - 1];
    const previous = history[history.length - 2];

    console.log('📈 Metrics Trends:');
    console.log(`   Nodes: ${previous.nodes} → ${latest.nodes} (${latest.nodes - previous.nodes >= 0 ? '+' : ''}${latest.nodes - previous.nodes})`);
    console.log(`   Edges: ${previous.edges} → ${latest.edges} (${latest.edges - previous.edges >= 0 ? '+' : ''}${latest.edges - previous.edges})`);
    console.log(`   Cycles: ${previous.cycles} → ${latest.cycles} (${latest.cycles - previous.cycles >= 0 ? '+' : ''}${latest.cycles - previous.cycles})`);
  }
}

trackMetrics();
```

## 🐛 Отладка и troubleshooting

### Отладка циклических зависимостей
```bash
# Детальный анализ конкретного файла
node -e "
const report = require('./docs/DEPENDENCIES.json');
const fileName = process.argv[2];
const file = report.graph.nodes.find(n => n.name === fileName);
if (file) {
  console.log('File:', file.name);
  console.log('Imports:');
  report.graph.edges.filter(e => e.from === file.id).forEach(e => {
    const target = report.graph.nodes[e.to];
    console.log('  →', target.name, '(${e.importName})');
  });
} else {
  console.log('File not found:', fileName);
}
" filename.ts
```

### Поиск проблемных файлов
```bash
# Файлы с наибольшим количеством импортов
node -e "
const report = require('./docs/DEPENDENCIES.json');
const sorted = report.graph.nodes.sort((a, b) => b.imports - a.imports);
console.log('Top files by imports:');
sorted.slice(0, 5).forEach(f => console.log(\`  \${f.name}: \${f.imports} imports\`));
"
```

### Очистка старых отчетов
```bash
# scripts/cleanup-reports.sh
#!/bin/bash

KEEP_DAYS=30
REPORT_DIR="docs"

echo "🧹 Cleaning old ontology reports..."

# Найти файлы старше KEEP_DAYS дней
find "$REPORT_DIR" -name "*DEPENDENCIES*.json" -mtime +$KEEP_DAYS -exec rm {} \;
find "$REPORT_DIR" -name "*TYPES*.json" -mtime +$KEEP_DAYS -exec rm {} \;

echo "✅ Cleanup completed"
```

---

Эти примеры показывают, как интегрировать онтологические инструменты AIRules в различные типы проектов и рабочие процессы разработки.