# 💡 Решения для Ontology Syncer Skill

Этот файл содержит конкретные решения для типичных задач синхронизации онтологического графа.

---

## 📊 Анализ зависимостей

### Решение: Построение графа импортов

**Проблема:** Нужно построить граф зависимостей проекта

```javascript
// scripts/ontology/analyze-dependencies.js
const fs = require('fs');
const path = require('path');

function analyzeImports(filePath) {
  const content = fs.readFileSync(filePath, 'utf-8');
  const imports = content.match(/import.*from\s+['"]([^'"]+)['"]/g) || [];
  
  return imports.map(imp => {
    const match = imp.match(/import.*from\s+['"]([^'"]+)['"]/);
    return match ? match[1] : null;
  }).filter(Boolean);
}

function buildGraph(directory) {
  const graph = { nodes: [], edges: [] };
  const files = getAllTsFiles(directory);
  
  files.forEach(file => {
    const relativePath = path.relative(directory, file);
    graph.nodes.push({ id: relativePath, file });
    
    const imports = analyzeImports(file);
    imports.forEach(imp => {
      graph.edges.push({
        from: relativePath,
        to: imp,
        type: 'import'
      });
    });
  });
  
  return graph;
}

function getAllTsFiles(dir, files = []) {
  const entries = fs.readdirSync(dir, { withFileTypes: true });
  
  entries.forEach(entry => {
    const fullPath = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      getAllTsFiles(fullPath, files);
    } else if (entry.name.endsWith('.ts') || entry.name.endsWith('.tsx')) {
      files.push(fullPath);
    }
  });
  
  return files;
}

const graph = buildGraph('./src');
console.log(JSON.stringify(graph, null, 2));
```

**Полезные ссылки:**
- [Context7: AST Parsing](https://www.context7.ai)
- [TypeScript Compiler API](https://github.com/microsoft/TypeScript/wiki/Using-the-Compiler-API)

---

## 🔄 Обнаружение циклических зависимостей

### Решение: DFS для нахождения циклов

**Проблема:** Нужно найти циклические зависимости в коде

```javascript
// scripts/ontology/detect-cycles.js
function findCycles(graph) {
  const visited = new Set();
  const recursionStack = new Set();
  const cycles = [];
  
  function dfs(node, path = []) {
    if (recursionStack.has(node)) {
      // Нашли цикл
      const cycleStart = path.indexOf(node);
      const cycle = path.slice(cycleStart).concat([node]);
      cycles.push(cycle);
      return;
    }
    
    if (visited.has(node)) return;
    
    visited.add(node);
    recursionStack.add(node);
    
    const neighbors = graph.edges
      .filter(e => e.from === node)
      .map(e => e.to);
    
    neighbors.forEach(neighbor => {
      dfs(neighbor, [...path, node]);
    });
    
    recursionStack.delete(node);
  }
  
  graph.nodes.forEach(node => dfs(node.id));
  return cycles;
}

const graph = JSON.parse(fs.readFileSync('./DEPENDENCIES.json', 'utf-8'));
const cycles = findCycles(graph);

if (cycles.length > 0) {
  console.log('❌ Found cyclic dependencies:');
  cycles.forEach(cycle => {
    console.log(`  ${cycle.join(' → ')}`);
  });
  process.exit(1);
} else {
  console.log('✅ No cyclic dependencies found');
}
```

**Полезные ссылки:**
- [Context7: Graph Algorithms](https://www.context7.ai)
- [DFS Algorithm](https://en.wikipedia.org/wiki/Depth-first_search)

---

## 🌐 Синхронизация с Memory Graph MCP

### Решение: Автоматическая отправка сущностей

**Проблема:** Нужно синхронизировать граф с Memory Graph

```javascript
// scripts/ontology/sync-to-memory-graph.js
async function syncToMemoryGraph(graph) {
  // Создать сущности для файлов
  const fileEntities = graph.nodes.map(node => ({
    name: `File_${node.id.replace(/\//g, '_').replace(/\./g, '_')}`,
    entityType: 'typescript_file',
    observations: [
      `Path: ${node.id}`,
      `Type: ${node.file.endsWith('.tsx') ? 'component' : 'module'}`
    ]
  }));
  
  // Создать сущности для связей
  const relationEntities = graph.edges.map(edge => ({
    from: `File_${edge.from.replace(/\//g, '_').replace(/\./g, '_')}`,
    to: `File_${edge.to.replace(/\//g, '_').replace(/\./g, '_')}`,
    relationType: 'imports_module'
  }));
  
  // Отправить в Memory Graph
  const response = await fetch('http://localhost:3000/mcp', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      action: 'create_entities',
      params: { entities: fileEntities }
    })
  });
  
  const relationResponse = await fetch('http://localhost:3000/mcp', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      action: 'create_relations',
      params: { relations: relationEntities }
    })
  });
  
  console.log('✅ Synced to Memory Graph');
}
```

**Полезные ссылки:**
- [Memory Graph MCP](../../../mcp/servers/memory.md)
- [Context7: MCP Integration](https://www.context7.ai)

---

## 🔍 Поиск неиспользуемых экспортов

### Решение: Анализ экспортов без использования

**Проблема:** Нужно найти неиспользуемый код

```javascript
// scripts/ontology/find-unused-exports.js
function findUnusedExports(graph) {
  const exports = new Map();
  const imports = new Set();
  
  // Собрать все экспорты
  graph.nodes.forEach(node => {
    const content = fs.readFileSync(`./src/${node.id}`, 'utf-8');
    const exportMatches = content.match(/export\s+(?:const|function|class|interface)\s+(\w+)/g) || [];
    
    exportMatches.forEach(match => {
      const name = match.match(/\s+(\w+)$/)[1];
      exports.set(`${node.id}:${name}`, { file: node.id, name });
    });
  });
  
  // Собрать все импорты
  graph.edges.forEach(edge => {
    if (edge.to.includes('./')) {
      // Локальный импорт
      const [file, name] = edge.to.split('/').pop().split('.');
      imports.add(`${edge.from}:${name}`);
    }
  });
  
  // Найти неиспользуемые
  const unused = [];
  exports.forEach((value, key) => {
    if (!imports.has(key)) {
      unused.push(value);
    }
  });
  
  return unused;
}

const graph = JSON.parse(fs.readFileSync('./DEPENDENCIES.json', 'utf-8'));
const unused = findUnusedExports(graph);

if (unused.length > 10) {
  console.log('⚠️  Too many unused exports (>10):');
  unused.forEach(exp => {
    console.log(`  ${exp.file}:${exp.name}`);
  });
} else {
  console.log(`✅ Found ${unused.length} unused exports`);
}
```

**Полезные ссылки:**
- [Context7: Code Analysis](https://www.context7.ai)
- [Tree Shaking](https://webpack.js.org/guides/tree-shaking/)

---

## 🧪 Валидация Accounting домена

### Решение: Проверка NUMERIC типов

**Проблема:** Нужно проверить использование NUMERIC в SQL

```javascript
// scripts/ontology/validate-accounting.js
function validateAccountingTypes(sqlFiles) {
  const errors = [];
  
  sqlFiles.forEach(file => {
    const content = fs.readFileSync(file, 'utf-8');
    
    // Найти все NUMERIC использования
    const numerics = content.match(/NUMERIC\([^)]+\)/g) || [];
    
    numerics.forEach(numeric => {
      if (!numeric.includes('15,2')) {
        errors.push({
          file,
          message: `NUMERIC precision "${numeric}" does not match NUMERIC(15,2)`,
          severity: 'CRITICAL'
        });
      }
    });
    
    // Найти запрещенные типы
    const forbidden = ['FLOAT', 'DOUBLE PRECISION', 'REAL'];
    forbidden.forEach(type => {
      if (content.includes(type)) {
        errors.push({
          file,
          message: `Accounting domain forbids ${type}. Use NUMERIC(15,2)`,
          severity: 'CRITICAL'
        });
      }
    });
  });
  
  return errors;
}

const sqlFiles = getAllFiles('./migrations', '.sql');
const errors = validateAccountingTypes(sqlFiles);

if (errors.length > 0) {
  console.log('❌ Accounting validation failed:');
  errors.forEach(error => {
    console.log(`  ${error.file}: ${error.message}`);
  });
  process.exit(1);
} else {
  console.log('✅ Accounting domain validation passed');
}
```

**Полезные ссылки:**
- [Accounting Constitution](../ACCOUNTING_CONSTITUTION.md)
- [Context7: Database Types](https://www.context7.ai)