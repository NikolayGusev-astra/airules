# 🚀 Продвинутые паттерны для Ontology Syncer Skill

Этот файл содержит продвинутые техники синхронизации онтологического графа.

---

## ⚡ Инкрементальный анализ зависимостей

### Техника: Только измененные файлы

**Когда использовать:**
- Большие проекты с длинным временем анализа
- Оптимизация производительности
- Частые изменения

```javascript
// scripts/ontology/incremental-analysis.js
const { execSync } = require('child_process');

function getChangedFiles() {
  // Получить измененные файлы с последнего коммита
  const output = execSync('git diff --name-only HEAD~1').toString();
  return output.split('\n').filter(Boolean);
}

function incrementalAnalyze(changedFiles) {
  const changedTsFiles = changedFiles.filter(file => 
    file.endsWith('.ts') || file.endsWith('.tsx')
  );
  
  console.log(`Analyzing ${changedTsFiles.length} changed files...`);
  
  // Анализировать только измененные файлы
  changedTsFiles.forEach(file => {
    const imports = analyzeImports(`./${file}`);
    console.log(`${file}: ${imports.length} imports`);
  });
  
  return { files: changedTsFiles, analysis: changedTsFiles.length };
}

const changedFiles = getChangedFiles();
const result = incrementalAnalyze(changedFiles);

console.log(`✅ Incremental analysis complete: ${result.analysis} files`);
```

**Преимущества:**
- Быстрее полного анализа
- Меньше нагрузки на CPU
- Актуальный граф

**Полезные ссылки:**
- [Context7: Performance Optimization](https://www.context7.ai)
- [Git Diff Documentation](https://git-scm.com/docs/git-diff)

---

## 🔄 Автоматическая синхронизация при коммите

### Техника: Git pre-commit hook

**Когда использовать:**
- Автоматическая синхронизация
- Свежий граф в Memory Graph
- Непрерывная актуальность

```bash
#!/bin/bash
# .git/hooks/pre-commit

echo "🔄 Running ontology sync..."

# Запустить анализ зависимостей
node scripts/ontology/analyze-dependencies.js

# Проверить результат
if [ ! -f DEPENDENCIES.json ]; then
  echo "❌ DEPENDENCIES.json not found"
  exit 1
fi

# Синхронизировать с Memory Graph (если доступен)
if curl -s http://localhost:3000/health > /dev/null 2>&1; then
  echo "🌐 Syncing with Memory Graph..."
  node scripts/ontology/sync-to-memory-graph.js
  echo "✅ Synced with Memory Graph"
else
  echo "⚠️  Memory Graph not available, skipping sync"
fi

# Валидировать граф
node scripts/ontology/validate-graph.js
if [ $? -ne 0 ]; then
  echo "❌ Graph validation failed"
  exit 1
fi

echo "✅ Ontology sync complete"
exit 0
```

**Полезные ссылки:**
- [Git Hooks Documentation](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks)
- [Context7: Git Automation](https://www.context7.ai)

---

## 📊 Визуализация онтологического графа

### Техника: Генерация графического представления

**Когда использовать:**
- Демонстрация архитектуры
- Анализ зависимостей
- Документация проекта

```javascript
// scripts/ontology/generate-graphviz.js
function generateGraphViz(graph) {
  let dot = 'digraph dependencies {\n  node [shape=box];\n';
  
  graph.edges.forEach(edge => {
    dot += `  "${edge.from}" -> "${edge.to}";\n`;
  });
  
  dot += '}';
  return dot;
}

function saveGraphViz(dot, outputPath) {
  const { execSync } = require('child_process');
  
  fs.writeFileSync('dependencies.dot', dot);
  
  // Генерировать PNG (требует Graphviz)
  execSync('dot -Tpng dependencies.dot -o dependencies.png');
  
  console.log('✅ Graph generated: dependencies.png');
}

const graph = JSON.parse(fs.readFileSync('DEPENDENCIES.json', 'utf-8'));
const dot = generateGraphViz(graph);
saveGraphViz(dot, 'dependencies.png');
```

**Полезные ссылки:**
- [Graphviz Documentation](https://graphviz.org/)
- [Context7: Visualization](https://www.context7.ai)

---

## 🧪 Интеграция с CI/CD

### Техника: Автоматическая валидация в GitHub Actions

**Когда использовать:**
- Continuous Integration
- Автоматическая проверка PR
- Облачная валидация

```yaml
# .github/workflows/ontology-validation.yml
name: Ontology Graph Validation

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Analyze dependencies
        run: node scripts/ontology/analyze-dependencies.js
      
      - name: Validate graph
        run: node scripts/ontology/validate-graph.js
      
      - name: Check for cyclic dependencies
        run: node scripts/ontology/detect-cycles.js
      
      - name: Upload DEPENDENCIES.json
        uses: actions/upload-artifact@v3
        with:
          name: dependencies-graph
          path: DEPENDENCIES.json
      
      - name: Check Accounting domain
        run: node scripts/ontology/validate-accounting.js
```

**Полезные ссылки:**
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Context7: CI/CD Patterns](https://www.context7.ai)

---

## 🔍 Advanced анализ зависимостей

### Техника: Выявление "God Objects"

**Когда использовать:**
- Рефакторинг
- Улучшение архитектуры
- Упрощение зависимостей

```javascript
// scripts/ontology/analyze-complexity.js
function findGodObjects(graph) {
  const importCounts = new Map();
  
  // Считать количество импортов каждого файла
  graph.edges.forEach(edge => {
    const count = importCounts.get(edge.to) || 0;
    importCounts.set(edge.to, count + 1);
  });
  
  // Найти файлы с большим количеством импортов (>20)
  const godObjects = [];
  importCounts.forEach((count, file) => {
    if (count > 20) {
      godObjects.push({ file, importCount: count });
    }
  });
  
  return godObjects.sort((a, b) => b.importCount - a.importCount);
}

const graph = JSON.parse(fs.readFileSync('DEPENDENCIES.json', 'utf-8'));
const godObjects = findGodObjects(graph);

if (godObjects.length > 0) {
  console.log('⚠️  Potential God Objects found:');
  godObjects.forEach(obj => {
    console.log(`  ${obj.file}: ${obj.importCount} imports`);
  });
} else {
  console.log('✅ No God Objects found');
}
```

**Полезные ссылки:**
- [Context7: Code Smells](https://www.context7.ai)
- [Refactoring Guru](https://refactoring.guru/smells/god-object)

---

## 🌐 Advanced Memory Graph интеграция

### Техника: Differential Sync (только изменения)

**Когда использовать:**
- Большой граф (>1000 сущностей)
- Оптимизация MCP запросов
- Уменьшение времени синхронизации

```javascript
// scripts/ontology/differential-sync.js
async function differentialSync(graph, previousGraph) {
  const changes = {
    added: [],
    modified: [],
    deleted: []
  };
  
  // Найти добавленные узлы
  const currentNodes = new Set(graph.nodes.map(n => n.id));
  const previousNodes = new Set(previousGraph.nodes.map(n => n.id));
  
  currentNodes.forEach(node => {
    if (!previousNodes.has(node)) {
      changes.added.push({ type: 'node', id: node });
    }
  });
  
  // Найти удаленные узлы
  previousNodes.forEach(node => {
    if (!currentNodes.has(node)) {
      changes.deleted.push({ type: 'node', id: node });
    }
  });
  
  // Синхронизировать только изменения
  if (changes.added.length > 0) {
    await syncToMemoryGraph(changes.added);
    console.log(`✅ Synced ${changes.added.length} additions`);
  }
  
  if (changes.deleted.length > 0) {
    await deleteFromMemoryGraph(changes.deleted);
    console.log(`✅ Synced ${changes.deleted.length} deletions`);
  }
  
  return changes;
}

const graph = JSON.parse(fs.readFileSync('DEPENDENCIES.json', 'utf-8'));
const previousGraph = fs.existsSync('PREVIOUS_DEPENDENCIES.json') 
  ? JSON.parse(fs.readFileSync('PREVIOUS_DEPENDENCIES.json', 'utf-8'))
  : { nodes: [], edges: [] };

differentialSync(graph, previousGraph);
```

**Полезные ссылки:**
- [Memory Graph MCP](../../../mcp/servers/memory.md)
- [Context7: MCP Optimization](https://www.context7.ai)