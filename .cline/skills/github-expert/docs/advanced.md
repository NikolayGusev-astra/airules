# GitHub Expert - Продвинутые сценарии

**Версия:** 1.0.0  
**Дата создания:** 2026-01-17  
**Статус:** ✅ Продвинутый

---

## 🎯 Продвинутые сценарии

Этот документ содержит продвинутые техники и паттерны для GitHub Actions.

---

## 📊 Scenario 1: Matrix с Conditional Logic

### Описание
Создайте workflow который:
- Тестирует на нескольких ОС (Ubuntu, Windows, macOS)
- Пропускает определённые комбинации
- Использует conditional steps

### Решение
```yaml
name: Matrix Testing

on:
  push:
    branches: [main]

jobs:
  test:
    runs-on: ${{ matrix.os }}
    strategy:
      fail-fast: false
      matrix:
        os: [ubuntu-latest, windows-latest, macos-latest]
        node: [18, 20]
        exclude:
          - os: windows-latest
            node: 18  # Исключаем Windows + Node 18
    
    steps:
      - uses: actions/checkout@v5
      
      - uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node }}
          cache: 'npm'
      
      - name: Install dependencies
        if: matrix.os != 'windows-latest'
        run: npm ci
      
      - name: Install dependencies (Windows)
        if: matrix.os == 'windows-latest'
        run: npm ci --no-audit --no-fund
      
      - name: Run tests
        run: npm test
      
      - name: Upload coverage
        if: matrix.node == 20
        uses: actions/upload-artifact@v4
        with:
          name: coverage-${{ matrix.os }}-node${{ matrix.node }}
          path: coverage/
```

**Ключевые моменты:**
- ✅ `fail-fast: false` - продолжает другие при ошибке
- ✅ `exclude` - исключает определённые комбинации
- ✅ Conditional steps - `if: matrix.os == '...'`
- ✅ Conditional upload - только для Node 20

---

## 🚀 Scenario 2: Multi-Environment Deployment

### Описание
Создайте reusable workflow для деплоя в несколько окружений (dev, staging, production).

### Решение
```yaml
# .github/workflows/reusable-deploy.yml
name: Reusable Deploy Workflow

on:
  workflow_call:
    inputs:
      environment:
        description: 'Deployment environment'
        required: true
        type: choice
        options:
          - dev
          - staging
          - production
      docker-image:
        description: 'Docker image to deploy'
        required: true
        type: string
    secrets:
      deploy-token:
        description: 'Deployment token'
        required: true
      api-key:
        description: 'API key for production'
        required: false

jobs:
  deploy:
    runs-on: ubuntu-latest
    environment:
      name: ${{ inputs.environment }}
      url: https://${{ inputs.environment }}.example.com
    
    steps:
      - uses: actions/checkout@v5
      
      - name: Configure AWS credentials
        if: inputs.environment == 'production'
        uses: aws-actions/configure-aws-credentials@v4
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: us-east-1
      
      - name: Deploy to ${{ inputs.environment }}
        run: |
          echo "Deploying to ${{ inputs.environment }}"
          echo "Docker image: ${{ inputs.docker-image }}"
          docker pull ${{ inputs.docker-image }}
          docker run -d -p 80:80 ${{ inputs.docker-image }}
```

**Вызов из основного workflow:**
```yaml
# .github/workflows/ci-cd.yml
name: CI/CD Pipeline

on:
  push:
    branches: [main]

jobs:
  deploy-dev:
    uses: ./.github/workflows/reusable-deploy.yml
    with:
      environment: dev
      docker-image: myapp:latest
    secrets:
      deploy-token: ${{ secrets.DEPLOY_TOKEN }}
  
  deploy-staging:
    needs: deploy-dev
    uses: ./.github/workflows/reusable-deploy.yml
    with:
      environment: staging
      docker-image: myapp:latest
    secrets:
      deploy-token: ${{ secrets.DEPLOY_TOKEN }}
  
  deploy-production:
    needs: deploy-staging
    uses: ./.github/workflows/reusable-deploy.yml
    with:
      environment: production
      docker-image: myapp:latest
    secrets:
      deploy-token: ${{ secrets.DEPLOY_TOKEN }}
      api-key: ${{ secrets.PROD_API_KEY }}
```

**Ключевые моменты:**
- ✅ `environment:` - создаёт GitHub environment
- ✅ Conditional secrets - `required: false` для необязательных
- ✅ Sequential deployment - `needs:` для последовательности
- ✅ Type `choice` - выбор из списка

---

## 🔐 Scenario 3: Advanced Secret Management

### Описание
Создайте workflow который:
- Использует OIDC для безопасности (без PAT)
- Валидирует секреты перед использованием
- Маскирует секреты в логах

### Решение
```yaml
name: Secure Deployment

on:
  push:
    branches: [main]

permissions:
  contents: read
  id-token: write  # Для OIDC

jobs:
  validate-secrets:
    runs-on: ubuntu-latest
    outputs:
      secrets-valid: ${{ steps.validate.outputs.valid }}
    steps:
      - name: Validate secrets
        id: validate
        env:
          DEPLOY_TOKEN: ${{ secrets.DEPLOY_TOKEN }}
          API_KEY: ${{ secrets.API_KEY }}
        run: |
          if [ -z "$DEPLOY_TOKEN" ]; then
            echo "valid=false" >> $GITHUB_OUTPUT
          else
            echo "valid=true" >> $GITHUB_OUTPUT
          fi
  
  deploy:
    needs: validate-secrets
    if: needs.validate-secrets.outputs.secrets-valid == 'true'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v5
      
      - name: Configure OIDC
        uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: ${{ secrets.AWS_ROLE_ARN }}
          role-session-name: github-actions
      
      - name: Deploy
        env:
          DEPLOY_TOKEN: ${{ secrets.DEPLOY_TOKEN }}  # Автоматически маскируется
          API_KEY: ${{ secrets.API_KEY }}        # Автоматически маскируется
        run: |
          echo "Deploying with masked secrets"
          # DEPLOY_TOKEN и API_KEY автоматически маскируются в логах
```

**Ключевые моменты:**
- ✅ OIDC вместо PAT - безопаснее
- ✅ `id-token: write` - для OIDC токенов
- ✅ `role-to-assume` - AWS role assumption
- ✅ Outputs для передачи между jobs
- ✅ Автоматическое маскирование секретов

---

## 🎨 Scenario 4: Custom Action with Outputs

### Описание
Создайте composite action который:
- Устанавливает зависимости
- Запускает тесты
- Возвращает результаты (passed, failed, coverage)

### Решение
```yaml
# .github/actions/run-tests/action.yml
name: 'Run Tests'
description: 'Install dependencies, run tests, and return results'

inputs:
  node-version:
    description: 'Node.js version'
    required: true
    default: '20'
  test-command:
    description: 'Test command'
    required: true
    default: 'npm test'

outputs:
  status:
    description: 'Test status (passed/failed)'
    value: ${{ steps.test.outputs.status }}
  coverage:
    description: 'Test coverage percentage'
    value: ${{ steps.test.outputs.coverage }}

runs:
  using: 'composite'
  steps:
    - name: Setup Node.js
      uses: actions/setup-node@v4
      with:
        node-version: ${{ inputs.node-version }}
    
    - name: Cache dependencies
      uses: actions/cache@v4
      id: cache
      with:
        path: node_modules
        key: ${{ runner.os }}-node-${{ hashFiles('**/package-lock.json') }}
    
    - name: Install dependencies
      shell: bash
      run: npm ci
    
    - name: Run tests
      id: test
      shell: bash
      run: |
        ${{ inputs.test-command }}
        
        if [ $? -eq 0 ]; then
          echo "status=passed" >> $GITHUB_OUTPUT
        else
          echo "status=failed" >> $GITHUB_OUTPUT
        fi
        
        if [ -f coverage/coverage-summary.json ]; then
          coverage=$(cat coverage/coverage-summary.json | jq -r '.total.lines.pct')
          echo "coverage=$coverage" >> $GITHUB_OUTPUT
        fi
```

**Использование в workflow:**
```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v5
      
      - uses: ./.github/actions/run-tests
        id: tests
        with:
          node-version: '20'
          test-command: 'npm test'
      
      - name: Check results
        run: |
          echo "Test status: ${{ steps.tests.outputs.status }}"
          echo "Coverage: ${{ steps.tests.outputs.coverage }}%"
      
      - name: Notify on failure
        if: steps.tests.outputs.status == 'failed'
        uses: actions/github-script@v7
        with:
          script: |
            github.rest.issues.create({
              owner: context.repo.owner,
              repo: context.repo.repo,
              title: 'Tests failed',
              body: 'Coverage: ${{ steps.tests.outputs.coverage }}%'
            })
```

**Ключевые моменты:**
- ✅ Composite action с `outputs`
- ✅ Shell execution в composite action
- ✅ Passing outputs между steps
- ✅ Conditional notification на основе outputs

---

## 🔄 Scenario 5: Workflow с Manual Approval

### Описание
Создайте workflow который:
- Требует ручного одобрения перед деплоем
- Оповещает через Slack/Discord
- Сохраняет статус деплоя

### Решение
```yaml
name: Deployment with Approval

on:
  push:
    tags:
      - 'v*'

jobs:
  notify:
    runs-on: ubuntu-latest
    steps:
      - name: Notify Slack
        uses: slackapi/slack-github-action@v1.26.0
        with:
          payload: |
            {
              "text": "🚀 New version ${{ github.ref_name }} ready for deployment"
            }
        env:
          SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK_URL }}
  
  request-approval:
    needs: notify
    runs-on: ubuntu-latest
    environment:
      name: production
      url: https://example.com
    steps:
      - uses: actions/checkout@v5
      
      - name: Wait for approval
        run: echo "Waiting for manual approval..."
  
  deploy:
    needs: request-approval
    runs-on: ubuntu-latest
    environment: production
    steps:
      - uses: actions/checkout@v5
      
      - name: Deploy
        run: |
          echo "Deploying ${{ github.ref_name }}"
          # Команды деплоя
      
      - name: Update deployment status
        uses: chrnorm/deployment-status@v2
        with:
          token: ${{ secrets.GITHUB_TOKEN }}
          environment-url: https://example.com
          environment: production
          state: success
      
      - name: Notify success
        if: success()
        uses: slackapi/slack-github-action@v1.26.0
        with:
          payload: |
            {
              "text": "✅ Deployment ${{ github.ref_name }} completed successfully"
            }
        env:
          SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK_URL }}
      
      - name: Notify failure
        if: failure()
        uses: slackapi/slack-github-action@v1.26.0
        with:
          payload: |
            {
              "text": "❌ Deployment ${{ github.ref_name }} failed"
            }
        env:
          SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK_URL }}
```

**Ключевые моменты:**
- ✅ Manual approval через GitHub environment
- ✅ `needs:` для последовательности jobs
- ✅ Conditional execution на основе `success()`/`failure()`
- ✅ External notifications (Slack)
- ✅ Deployment status API

---

## 📈 Scenario 6: Performance Monitoring

### Описание
Создайте workflow который:
- Запускает performance тесты
- Сравнивает с предыдущим baseline
- Оповещает если производительность ухудшилась

### Решение
```yaml
name: Performance Testing

on:
  pull_request:
    branches: [main]

jobs:
  benchmark:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v5
        with:
          fetch-depth: 0  # Для сравнения с main
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Build
        run: npm run build
      
      - name: Run benchmark
        id: benchmark
        run: |
          npm run benchmark > results.json
          
          # Сравнить с baseline
          gh api repos/OWNER/REPO/contents/benchmarks/baseline.json > baseline.json
          
          current_score=$(jq '.score' results.json)
          baseline_score=$(jq '.score' baseline.json)
          
          echo "current=$current_score" >> $GITHUB_OUTPUT
          echo "baseline=$baseline_score" >> $GITHUB_OUTPUT
          
          if (( $(echo "$current_score > $baseline_score * 1.1" | bc -l) )); then
            echo "regression=true" >> $GITHUB_OUTPUT
          else
            echo "regression=false" >> $GITHUB_OUTPUT
          fi
      
      - name: Comment on PR
        if: steps.benchmark.outputs.regression == 'true'
        uses: actions/github-script@v7
        with:
          script: |
            github.rest.issues.createComment({
              owner: context.repo.owner,
              repo: context.repo.repo,
              issue_number: context.issue.number,
              body: `⚠️ Performance regression detected!
              Current: ${{ steps.benchmark.outputs.current }}
              Baseline: ${{ steps.benchmark.outputs.baseline }}
              Regression: >10%`
            })
```

**Ключевые моменты:**
- ✅ `fetch-depth: 0` - полный git history
- ✅ Сравнение с baseline через GitHub API
- ✅ Math operations в shell
- ✅ Conditional comment на PR
- ✅ Threshold для regression (>10%)

---

## 🧪 Scenario 7: Self-Hosted Runner

### Описание
Настройте workflow который:
- Использует self-hosted runner для деплоя
- Падает gracefully если runner недоступен
- Повторяет попытки

### Решение
```yaml
name: Deploy to Self-Hosted

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: [self-hosted, linux, x64]  # Self-hosted runner
    timeout-minutes: 60
    
    steps:
      - uses: actions/checkout@v5
      
      - name: Check runner availability
        id: check-runner
        run: |
          echo "Checking runner availability..."
          if ! command -v docker; then
            echo "Docker not available" >&2
            exit 1
          fi
          echo "available=true" >> $GITHUB_OUTPUT
      
      - name: Deploy
        if: steps.check-runner.outputs.available == 'true'
        uses: nick-invision/retry@v3
        with:
          timeout_minutes: 10
          max_attempts: 3
          retry_on: error
          command: |
            docker build -t myapp .
            docker save myapp | gzip > myapp.tar.gz
            
            # SCP на self-hosted server
            scp myapp.tar.gz user@self-hosted:/tmp/
            
            ssh user@self-hosted "docker load < /tmp/myapp.tar.gz"
            ssh user@self-hosted "docker run -d --restart always myapp"
      
      - name: Notify on failure
        if: failure()
        uses: actions/github-script@v7
        with:
          script: |
            github.rest.issues.create({
              owner: context.repo.owner,
              repo: context.repo.repo,
              title: 'Self-hosted runner deployment failed',
              body: 'Runner: ${{ runner.name }}\nStatus: Unavailable'
            })
```

**Ключевые моменты:**
- ✅ Self-hosted runner labels: `[self-hosted, linux, x64]`
- ✅ Timeout для предотвращения зависания
- ✅ Retry action для повторных попыток
- ✅ Graceful degradation
- ✅ Notification при недоступности

---

## 📚 Дополнительные ресурсы

### Официальная документация
- [GitHub Actions Security](https://docs.github.com/en/actions/security-guides/automatic-token-authentication)
- [Self-hosted runners](https://docs.github.com/en/actions/hosting-your-own-runners)
- [Reusable workflows](https://docs.github.com/en/actions/using-workflows/reusing-workflows)

### Advanced patterns
- [Action inputs/outputs](https://docs.github.com/en/actions/creating-actions/metadata-syntax-for-github-actions)
- [OIDC integration](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-github-actions)
- [Composite actions](https://docs.github.com/en/actions/creating-actions/creating-a-composite-action)

---

## 🎯 Ключевые takeaways

1. **Matrix strategy** - для параллельного тестирования
2. **Reusable workflows** - для DRY принципа
3. **OIDC** - безопасная альтернатива PAT
4. **Outputs** - передача данных между jobs/steps
5. **Manual approval** - через GitHub environments
6. **Self-hosted runners** - для контроля над execution
7. **Retry logic** - для устойчивости к ошибкам

---

**Масштируйте свои workflows с этими продвинутыми паттернами!** 🚀