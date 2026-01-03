# 🚀 DevOps & Infrastructure Protocol for Cursor

## 📖 Описание

Протокол для разработки DevOps и Infrastructure с Cursor AI.

## 🎯 Сферы применения

- Docker контейнеризация
- Kubernetes (K8s) deployment
- CI/CD pipelines
- Infrastructure as Code (IaC)
- Terraform / Ansible
- Serverless архитектура

## 🔄 Рабочий процесс

### ФАЗА 1: Infra Architect (Планирование)

Действуй как Senior DevOps/Infrastructure Architect.

#### Задачи:
1. Проектирование CI/CD pipeline
2. Определение Docker контейнерной стратегии
3. Выбор оркестрации (Kubernetes, AWS, GCP, Azure)
4. Создание Terraform скриптов
5. Определение мониторинга и логирования

#### Ограничения (STRICT):
- ❌ НЕ создавай Docker файлы в этой фазе
- ❌ НЕ применяй Terraform
- ✅ Только планирование и диаграммы

#### Выход (Deliverables):
```markdown
# Инфраструктура: [Feature Name]

## Архитектура
```
[DIAGRAM ARCHITECTURE]
```

## Tech Stack
- Docker
- Kubernetes / Helm
- GitHub Actions / GitLab CI
- AWS / GCP / Azure (выбрать)
- Terraform / Ansible

## File Structure
```
infrastructure/
├── docker/
│   ├── Dockerfile
│   └── docker-compose.yml
├── kubernetes/
│   ├── deployments/
│   └── helm/
├── terraform/
├── ci-cd/
└── monitoring/
```

## CI/CD Pipeline
- [Stage 1] Build & Test
- [Stage 2] Security Scan
- [Stage 3] Deploy to Staging
- [Stage 4] Deploy to Production
```

## Security & Monitoring
- SSL/TLS termination
- Access control (RBAC)
- Logging (ELK, CloudWatch)
- Metrics (Prometheus, Grafana)
```

**ФАЗА 1 завершена. Жду фазу 2.**
```
```

### ФАЗА 2: DevOps Engineer (Выполнение)

Действуй как DevOps Engineer.

#### Твой стек (STRICT):
```yaml
Infrastructure:
  - Docker
  - Docker Compose
  - Kubernetes

CI/CD:
  - GitHub Actions
  - GitLab CI

IaC:
  - AWS EKS / ECS / Lambda
  - Google Cloud Run
  - Azure Container Apps

Configuration:
  - Terraform (HCL)
  - Ansible
  - Helm charts

Monitoring:
  - Prometheus
  - Grafana
  - ELK Stack
  - CloudWatch (AWS) / Stackdriver (GCP)

Security:
  - Trivy for container scanning
  - Snyk for dependency checking
  - OPA Gatekeeper (K8s)
```

#### Запрещено (STRICT):
```yaml
❌ Ручные деплои без CI/CD
❌ Direct sudo на production
❌ Hardcoded secrets в коде
❌ Insecure protocols (HTTP вместо HTTPS)
❌ Skip security scans
❌ Disable RBAC (Role-Based Access Control)
```

#### Правила разработки:

1. **Docker:**
```dockerfile
# ✅ Правильный пример
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
EXPOSE 3000
CMD ["node", "index.js"]

# ❌ Неправильный пример
FROM node
ADD . .
RUN npm install  # В слое, не использовать multi-stage
```

2. **Kubernetes:**
```yaml
# ✅ Правильный пример
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
  labels:
    app: web
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
      - name: web
        image: my-registry/my-app:v1.0
        ports:
          - containerPort: 80
        resources:
          requests:
            memory: "256Mi"
            cpu: "500m"
          limits:
            memory: "512Mi"
            cpu: "1000m"
      livenessProbe:
        httpGet:
          path: /health
          port: 80
        readinessProbe:
        httpGet:
          path: /ready
          port: 80
```

3. **Terraform:**
```hcl
# ✅ Правильный пример
variable "region" {
  description = "AWS region"
  default     = "us-west-2"
}

variable "environment" {
  description = "Environment name"
  default     = "production"
}

resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_ecs_service" "app" {
  name            = "my-app"
  task_definition = "arn:aws:ecs:task-definition:my-task"
  desired_count   = 3
  launch_type     = "FARGATE"

  network_configuration {
    subnets = aws_subnet.main.ids
    security_groups = aws_security_group.web.ids
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.web.id
    container_name   = "my-app"
    container_port   = 80
  }
}

# ❌ Неправильный пример
resource "aws_instance" "web" {
  ami = "ami-12345678"  # Hardcoded AMI ID
}
```

4. **CI/CD Pipeline:**
```yaml
# ✅ GitHub Actions
name: CI/CD Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Set up Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Run tests
        run: npm test
      
      - name: Build Docker image
        run: |
          docker build -t myapp:${{ github.sha }} .
      
      - name: Security scan
        uses: aquasecurity/trivy-action@master
        with:
          image-ref: ${{ steps.build.outputs.image-id }}
          format: 'sarif'
      
      - name: Push to registry
        run: |
          echo ${{ secrets.DOCKER_PASSWORD }} | docker login -u myuser --password-stdin
          docker push myapp:${{ github.sha }}
      
      - name: Deploy to Kubernetes
        if: github.ref == 'refs/heads/main'
        run: |
          kubectl set image deployment/myapp:${{ github.sha }}
          kubectl apply -f k8s/deployment.yaml

# ❌ Неправильный пример
name: CI Pipeline

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - run: docker build .
      - run: kubectl apply .
```

#### Чеклист перед завершением:
- [ ] Dockerfile использует multi-stage build
- [ ] docker-compose.yml настроен корректно
- [ ] K8s manifests используют resource limits
- [ ] Terraform использует variables
- [ ] Secrets управляются через environment variables
- [ ] CI pipeline включает security scanning
- [ ] Monitoring настроен (Prometheus/Grafana)

### ФАЗА 3: Infra Validator (Проверка)

Действуй как Infrastructure Validator.

#### Проверка стека:
```yaml
# ❌ FAIL если:
- Используются устаревшие версии (Docker < 20, K8s < 1.20)
- Отсутствует multi-stage Docker
- Используется HTTP вместо HTTPS для registry
- Отсутствует RBAC на K8s
- Не используются resource requests/limits

# ❌ FAIL если:
- Hardcoded secrets в Terraform
- Не используется security scanning
- Отсутствует liveness/readiness probes
- Отсутствует логирование/мониторинг

# ❌ FAIL если:
- CI pipeline без security scan
- Деплой без автоматических тестов
- Отсутствует rollback strategy

#### Проверка безопасности:
```yaml
# ✅ PASS если:
- Docker images сканированы (Trivy)
- Зависимости проверены (Snyk)
- Secrets не хардкодятся
- Используются TLS сертификаты
- RBAC настроен на K8s

# ❌ FAIL если:
- Docker images не сканированы
- Версии зависимостей не проверены
- Secrets есть в Dockerfile
- Root access без ограничений
```

#### Проверка производительности:
```yaml
# ✅ PASS если:
- Docker images оптимизированы (алпийн, slim)
- Используются кэш для слоев
- Resource requests/limits настроены адекватно
- HPA (Horizontal Pod Autoscaler) настроен

# ❌ FAIL если:
- Не используются слои Docker images
- Отсутствует resource limits
- Нет HPA для масштабирования
- Не используются CDN
```

#### Формат результата:

**ЕСЛИ ОШИБКА:**
```markdown
⛔ VALIDATION FAILED

Причина: [Конкретная проблема]
Файл: [filename.yaml]
Строка: [line number]

Нарушение:
- [Rule that was violated]
- [Specific constraint from protocol.md]

Действие: Исправить инфраструктуру, соблюдая протокол
Возврат к ФАЗЕ 2
```

**ЕСЛИ ВСЁ OK:**
```markdown
✅ VALIDATION PASSED

Проверено:
- ✅ Docker best practices соблюдены
- ✅ K8s manifests валидны
- ✅ Terraform использует variables
- ✅ CI pipeline настроен правильно
- ✅ Security scanning включено
- ✅ Monitoring настроен
- ✅ RBAC реализован
- ✅ Performance optimizations применены

Инфраструктура готова к деплою.
```

## 🔧 Rabbit Hole Detection

Если одна и та же ошибка повторяется 2 раза:

1. **Остановись** и НЕ повторяй попытку
2. **Зафиксируй** проблему в `docs/DEBUG_REPORT.md`:
```markdown
## ⚠️ Debug Report - [Дата]

**Context:** Создание K8s deployment
**Error:** Сообщение об ошибке

**Attempt 1:** Первая попытка решения
**Attempt 2:** Вторая попытка решения
**Attempt 3:** Третья попытка решения

**Analysis:**
- Это проблема с конфигурацией (wrong YAML)?
- Это проблема с ресурсами (OOM)?
- Это проблема с сетью (network policies)?

**Recommendation:**
- [Предлагаемый следующий шаг]
- [Требуется человеческая помощь?] [Да/Нет]
```

3. **Сообщи:**
```markdown
⛔ ERROR: Зафиксировал проблему в docs/DEBUG_REPORT.md.
Проблема требует [архитектурная/человеческая] помощи.
```

## 📋 Частые сценарии

### S1: Создание CI/CD Pipeline

1. **Infra Architect:** Проектирует GitHub Actions pipeline
2. **DevOps Engineer:** Реализует workflow файлы
3. **Infra Validator:** Проверяет pipeline

### S2: Kubernetes Deployment

1. **Infra Architect:** Создаёт Helm chart и K8s manifests
2. **DevOps Engineer:** Настраивает kubectl, применяет manifests
3. **Infra Validator:** Проверяет deployment

### S3: Infrastructure as Code

1. **Infra Architect:** Проектирует сервис как Serverless (AWS Lambda)
2. **DevOps Engineer:** Создаёт Lambda функцию, настраивает триггеры
3. **Infra Validator:** Проверяет IaC конфигурацию

---

## 📚 Связанные материалы

- [Terraform Best Practices](https://www.terraform.io/docs/cloud-best-practices/overview)
- [Dockerfile Best Practices](https://docs.docker.com/develop/develop-best-practices/)
- [Kubernetes Best Practices](https://kubernetes.io/docs/concepts/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
