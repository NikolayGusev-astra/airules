# 🚀 Продвинутые паттерны для Ontologist Skill

Этот файл содержит продвинутые техники онтологической валидации.

---

## 🤖 Автоматическая валидация через Git Hooks

### Техника: Pre-commit hook для онтологической валидации

**Когда использовать:**
- Автоматическая проверка перед коммитом
- Интеграция с Git
- Предотвращение онтологических нарушений

```bash
#!/bin/bash
# .git/hooks/pre-commit

echo "🔍 Running ontology validation..."

# Проверить все роли
for role_file in .cline/skills/*/role.yaml; do
  echo "Validating $role_file..."
  
  # Извлечь подкласс
  subclass=$(grep "^subclass:" "$role_file" | awk '{print $2}' | tr -d '"')
  
  # Проверить допустимость подкласса
  if [[ "$subclass" != "Architect" && "$subclass" != "Executor" && "$subclass" != "Validator" && "$subclass" != "Specialist" ]]; then
    echo "❌ ERROR: Invalid subclass '$subclass' in $role_file"
    echo "Valid subclasses: Architect, Executor, Validator, Specialist"
    exit 1
  fi
done

echo "✅ Ontology validation passed"
exit 0
```

**Установка:**
```bash
# Копировать hook
cp .git/hooks/pre-commit.example .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```

**Полезные ссылки:**
- [Git Hooks Documentation](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks)
- [Context7: Git Automation](https://www.context7.ai)

---

## 🔄 CI/CD интеграция онтологической валидации

### Техника: GitHub Actions для автоматической проверки

**Когда использовать:**
- Continuous Integration
- Автоматическая проверка Pull Requests
- Облачная валидация

```yaml
# .github/workflows/ontology-validation.yml
name: Ontology Validation

on:
  pull_request:
    paths:
      - '.cline/skills/**'
      - '.clinerules/roles/**'

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
      
      - name: Run ontology validation
        run: npm run validate:ontology
      
      - name: Comment PR with results
        uses: actions/github-script@v6
        with:
          script: |
            github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: '✅ Ontology validation passed!'
            })
```

**Полезные ссылки:**
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Context7: CI/CD Patterns](https://www.context7.ai)

---

## 📊 Визуализация онтологических нарушений

### Техника: Генерация отчетов с графами

**Когда использовать:**
- Анализ паттернов нарушений
- Демонстрация проблем команде
- Отслеживание прогресса

```typescript
// scripts/ontology/generate-visualization.ts
import { readFileSync, writeFileSync } from 'fs';
import { YAML } from 'yaml-cfn';

interface Violation {
  type: string;
  severity: 'CRITICAL' | 'WARNING' | 'INFO';
  file: string;
  message: string;
}

const violations: Violation[] = [
  {
    type: 'Invalid Subclass',
    severity: 'CRITICAL',
    file: '.cline/skills/backend-developer/role.yaml',
    message: 'Subclass "Backend Developer" is not defined in ontology'
  },
  {
    type: 'Invalid Technology',
    severity: 'WARNING',
    file: '.cline/skills/backend-executor/SKILL.md',
    message: 'Technology "jQuery" is not in ontology'
  }
];

// Генерация HTML отчета
const html = `
<!DOCTYPE html>
<html>
<head>
  <title>Ontology Violations Report</title>
  <style>
    body { font-family: Arial, sans-serif; }
    .critical { background: #fee; border-left: 4px solid #c00; }
    .warning { background: #ffd; border-left: 4px solid #fc0; }
    .info { background: #eef; border-left: 4px solid #00c; }
    .violation { margin: 10px 0; padding: 10px; }
  </style>
</head>
<body>
  <h1>🚨 Ontology Violations</h1>
  ${violations.map(v => `
    <div class="violation ${v.severity.toLowerCase()}">
      <strong>${v.type}</strong> (${v.severity})<br>
      <code>${v.file}</code><br>
      ${v.message}
    </div>
  `).join('')}
</body>
</html>
`;

writeFileSync('ontology-report.html', html);
console.log('Report generated: ontology-report.html');
```

**Полезные ссылки:**
- [Context7: Visualization](https://www.context7.ai)
- [D3.js Visualization Library](https://d3js.org/)

---

## 🔍 Анализ влияния изменений на онтологию

### Техника: Diff-анализ для Pull Requests

**Когда использовать:**
- Оценка влияния изменений
- Review онтологических модификаций
- Предотвращение регрессий

```typescript
// scripts/ontology/analyze-impact.ts
import { execSync } from 'child_process';

interface ChangedFile {
  file: string;
  type: 'added' | 'modified' | 'deleted';
}

function getChangedFiles(): ChangedFile[] {
  const output = execSync('git diff --name-status origin/main...HEAD').toString();
  return output.split('\n')
    .filter(line => line.startsWith('M') || line.startsWith('A'))
    .map(line => ({
      file: line.substring(2),
      type: line.startsWith('M') ? 'modified' : 'added'
    }));
}

function analyzeImpact(changedFiles: ChangedFile[]) {
  const impact = {
    roles: 0,
    technologies: 0,
    rules: 0,
    artifacts: 0
  };
  
  changedFiles.forEach(file => {
    if (file.file.includes('role.yaml')) impact.roles++;
    if (file.file.includes('SKILL.md')) impact.technologies++;
    if (file.file.includes('constraints.md')) impact.rules++;
    if (file.file.includes('PLAN.md')) impact.artifacts++;
  });
  
  return impact;
}

const changedFiles = getChangedFiles();
const impact = analyzeImpact(changedFiles);

console.log('📊 Impact Analysis:');
console.log(`  Roles changed: ${impact.roles}`);
console.log(`  Technologies changed: ${impact.technologies}`);
console.log(`  Rules changed: ${impact.rules}`);
console.log(`  Artifacts changed: ${impact.artifacts}`);

if (impact.roles > 0) {
  console.log('⚠️  Roles changed - re-run ontology validation');
}
```

**Полезные ссылки:**
- [Context7: Impact Analysis](https://www.context7.ai)
- [Git Diff Documentation](https://git-scm.com/docs/git-diff)

---

## 🧪 Unit-тесты для онтологической валидации

### Техника: Автоматизированная проверка правил

**Когда использовать:**
- Непрерывное тестирование
- Проверка правил валидации
- Быстрый feedback loop

```typescript
// tests/ontology/validation.test.ts
import { validateRole } from '../src/ontology/validator';

describe('Ontology Validation', () => {
  test('validates correct role', () => {
    const role = {
      name: 'Backend Executor',
      description: 'Backend developer',
      subclass: 'Executor',
      expertise: ['Node.js', 'TypeScript'],
      rules: ['instructions.md']
    };
    
    const result = validateRole(role);
    expect(result.valid).toBe(true);
    expect(result.errors).toHaveLength(0);
  });
  
  test('rejects invalid subclass', () => {
    const role = {
      name: 'Invalid Role',
      description: 'Test',
      subclass: 'InvalidSubclass',
      expertise: [],
      rules: []
    };
    
    const result = validateRole(role);
    expect(result.valid).toBe(false);
    expect(result.errors).toContain(
      'Invalid subclass "InvalidSubclass"'
    );
  });
  
  test('rejects undefined technology', () => {
    const role = {
      name: 'Test Role',
      description: 'Test',
      subclass: 'Specialist',
      expertise: ['UndefinedTech'], // Not in ontology
      rules: []
    };
    
    const result = validateRole(role);
    expect(result.valid).toBe(false);
    expect(result.errors).toContain(
      'Technology "UndefinedTech" is not defined in ontology'
    );
  });
});
```

**Полезные ссылки:**
- [Jest Testing Framework](https://jestjs.io/)
- [Context7: Testing Ontologies](https://www.context7.ai)

---

## 🌐 Интеграция с Memory Graph MCP

### Техника: Автоматическая синхронизация онтологии

**Когда использовать:**
- Актуальность онтологии в MCP
- Поиск сущностей через Memory Graph
- Кросс-проектная синхронизация

```typescript
// scripts/ontology/sync-to-memory-graph.ts
import { readFileSync } from 'fs';
import { YAML } from 'yaml-cfn';

interface Role {
  name: string;
  description: string;
  subclass: string;
  expertise: string[];
}

async function syncRolesToMemoryGraph() {
  const rolesDir = '.cline/skills';
  const roles: Role[] = [];
  
  // Прочитать все роли
  const roleFiles = readFileSync(`${rolesDir}/index.yaml`, 'utf-8');
  const yamlRoles = YAML.parse(roleFiles).skills;
  
  // Создать сущности для Memory Graph
  const entities = yamlRoles.map((role: any) => ({
    name: `Role_${role.name.replace(/\s/g, '_')}`,
    entityType: 'ontological_role',
    observations: [
      `Description: ${role.description}`,
      `Subclass: ${role.subclass}`,
      `Category: ${role.category}`,
      `Expertise: ${role.expertise.join(', ')}`
    ]
  }));
  
  // Отправить в Memory Graph через MCP
  await fetch('http://localhost:3000/memory-graph', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ entities })
  });
  
  console.log(`✅ Synced ${entities.length} roles to Memory Graph`);
}

syncRolesToMemoryGraph().catch(console.error);
```

**Полезные ссылки:**
- [Memory Graph MCP](../../../mcp/servers/memory.md)
- [Context7: MCP Integration](https://www.context7.ai)