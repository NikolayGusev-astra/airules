---
name: github-expert
description: Эксперт по GitHub Actions, вебхукам, workflow и автоматизации CI/CD. Используйте когда нужно создать workflow, настроить secrets, управлять автоматизацией в GitHub.
---

# 🧠 GitHub Expert Skill

## Зачем нужен этот Skill?

GitHub Expert Skill предоставляет профессиональную экспертизу по:
- GitHub Actions Workflows (.github/workflows/*.yml)
- Webhook Events (push, pull_request, pull_request_target, release, workflow_dispatch)
- Reusable Workflows (workflow_call)
- Composite Actions (action.yml)
- Custom Actions (Docker, JavaScript, TypeScript)
- Secret Management (secrets context, inherit all)
- GitHub CLI (gh commands)
- CI/CD Pipeline автоматизация
- Security Best Practices

Этот Skill активируется когда запрос содержит:
- "создать workflow", "github actions", "webhook"
- "автоматизация CI/CD", "deploy workflow"
- "настроить secrets", "pull_request vs pull_request_target"

---

## Основные принципы

### 1. Безопасность сначала
- ✅ Используйте `secrets` context, NEVER hardcode секреты
- ✅ Выбирайте правильное событие: `pull_request` vs `pull_request_target`
- ✅ Проверяйте права доступа к секретам
- ✅ Логируйте без раскрытия секретов

### 2. YAML синтаксис
- ✅ Используйте правильные отступы (2 пробела)
- ✅ Проверяйте валидность YAML
- ✅ Используйте `on`, `jobs`, `steps`, `runs-on`, `env`, `with`
- ✅ Условные выполнения: `if conditions`

### 3. Оптимизация производительности
- ✅ Кеширование зависимостей (actions/cache@v4)
- ✅ Параллельное выполнение jobs
- ✅ Артефакты для хранения результатов (actions/upload-artifact@v4)
- ✅ Conditional execution для пропуска ненужных шагов

### 4. Best Practices
- ✅ Используйте официальные actions: actions/checkout@v5, actions/setup-node@v4
- ✅ Reusable workflows для DRY принципа
- ✅ Composite actions для повторного использования
- ✅ Чёткие названия jobs и steps
- ✅ Коментарии для сложной логики

---

## Практические примеры

### Пример 1: Создание workflow для CI/CD

**Запрос:** "Создай workflow для автоматического тестирования и деплоя"

**Решение:**
```yaml
# .github/workflows/ci-cd.yml
name: CI/CD Pipeline

on:
  push:
    branches: [main, 'releases/**']
  pull_request:
    types: [opened, synchronize]
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v5
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
      - run: npm ci
      - run: npm test
  
  deploy:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v5
      - run: npm run build
      - name: Deploy to Vercel
        run: npx vercel --prod --token=${{ secrets.VERCEL_TOKEN }}
```

**Ключевые моменты:**
- ✅ Правильные webhook события (push, pull_request)
- ✅ Кеширование зависимостей (cache: 'npm')
- ✅ Conditional deployment (if github.ref == 'refs/heads/main')
- ✅ Использование secrets (secrets.VERCEL_TOKEN)

---

### Пример 2: Pull Request Target vs Pull Request

**Запрос:** "Какой webhook использовать для безопасности?"

**Решение:**

**pull_request:**
```yaml
on:
  pull_request:
    branches: [main]
jobs:
  secure:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v5  # PR код (небезопасно)
      - run: npm test
```
⚠️ **Риск:** Выполняет код из PR без review

**pull_request_target:**
```yaml
on:
  pull_request_target:
    branches: [main]
jobs:
  secure:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v5  # base branch код (безопасно)
      - run: npm test
```
✅ **Безопасно:** Выполняет код из base branch

**Когда использовать:**
- `pull_request`: Для обычной проверки PR
- `pull_request_target`: Для безопасности и выполнения из base branch

---

### Пример 3: Reusable Workflow

**Запрос:** "Создай reusable workflow для деплоя"

**Решение:**
```yaml
# .github/workflows/reusable-deploy.yml
name: Reusable Deploy Workflow

on:
  workflow_call:
    inputs:
      environment:
        description: 'Deployment environment'
        required: true
        type: string
    secrets:
      deploy-token:
        description: 'Deployment token'
        required: true

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v5
      - name: Deploy to ${{ inputs.environment }}
        run: echo "Deploying to ${{ inputs.environment }}"
        env:
          DEPLOY_TOKEN: ${{ secrets.deploy-token }}
```

**Вызов из другого workflow:**
```yaml
jobs:
  deploy:
    uses: ./.github/workflows/reusable-deploy.yml
    with:
      environment: production
    secrets:
      deploy-token: ${{ secrets.TOKEN }}
```

---

### Пример 4: Composite Action

**Запрос:** "Создай composite action для установки зависимостей"

**Решение:**
```yaml
# .github/actions/install-deps/action.yml
name: 'Install Dependencies'
description: 'Install project dependencies with caching'

inputs:
  node-version:
    description: 'Node.js version'
    required: true
    default: '20'

outputs:
  cache-key:
    description: 'Cache key used'
    value: ${{ steps.cache.outputs.key }}

runs:
  using: 'composite'
  steps:
    - name: Setup Node.js
      uses: actions/setup-node@v4
      with:
        node-version: ${{ inputs.node-version }}
    
    - id: cache
      uses: actions/cache@v4
      with:
        path: node_modules
        key: ${{ runner.os }}-node-${{ hashFiles('**/package-lock.json') }}
    
    - name: Install dependencies
      shell: bash
      run: npm ci
```

---

## Интеграция с MCP

### Context7 Researcher
При необходимости проверки актуальности GitHub Actions API:

**Когда использовать:**
- Новые webhook events или фичи
- Неизвестные action syntax
- Проверка совместимости версий

**Примеры запросов:**
```bash
# Проверить API совместимость
"Verify if GitHub Actions supports matrix strategies in 2024"

# Найти реальные паттерны
"Show real-world examples of GitHub Actions caching strategies"

# Проверить официальные actions
"Check current version and usage patterns for actions/checkout@v5"
```

---

## Лучшие практики

### Performance Optimization
- ✅ Кеширование зависимостей (actions/cache@v4)
- ✅ Параллельное выполнение jobs
- ✅ Артефакты для результатов (actions/upload-artifact@v4)
- ✅ Conditional execution

### Security
- ✅ Используйте `secrets` context
- ✅ Pull request target для безопасности
- ✅ Проверяйте права доступа
- ✅ Минимизируйте разрешения PAT tokens

### Maintainability
- ✅ Reusable workflows (DRY принцип)
- ✅ Composite actions для повторного использования
- ✅ Чёткие названия и комментарии
- ✅ Documentation (README в workflow)

---

## Критерии завершения

GitHub Expert Skill завершен когда:
- [x] Workflow файл создан и валиден
- [x] Правильные webhook события выбраны
- [x] Секреты переданы корректно через secrets context
- [x] Условные выполнения настроены
- [x] Reusable workflows или composite actions созданы (если нужно)
- [x] Security best practices соблюдены
- [x] Workflow оптимизирован (кеширование, параллельность)
- [x] Documentation добавлена (комментарии, README)

---

## Переход к следующей фазе

После создания workflow:

1. **Валидация:** Проверьте YAML синтаксис
2. **Тестирование:** Запустите workflow вручную (workflow_dispatch)
3. **Деплой:** Push в репозиторий для активации
4. **Мониторинг:** Следите за выполнением в Actions tab

---

**GitHub Expert создаёт надёжные и безопасные GitHub Actions workflows!** 🚀