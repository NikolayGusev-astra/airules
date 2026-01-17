# 🧠 Ontological Schema for AIRules

## Обзор онтологии

Эта схема определяет формальную структуру знаний для AIRules, обеспечивая согласованность между ролями, фазами разработки, артефактами, правилами, доменными областями и технологиями.

## Классы онтологии

### Agent (Агенты)
Агенты — это исполняющие сущности, которые выполняют задачи в соответствии со своим подклассом.

**Подклассы Agent:**
- `Architect` — Архитектор (Phase 1)
- `Executor` — Разработчик (Phase 2)
- `Validator` — Валидатор (Phase 3)
- `Specialist` — Специалист по конкретной доменной области

### Phase (Фазы разработки)
Фазы — это этапы выполнения задач в процессе разработки.

**Классы Phase:**
- `Phase 1` — Архитектура (Architect)
- `Phase 2` — Выполнение (Executor)
- `Phase 3` — Валидация (Validator)

### Artifact (Артефакты)
Артефакты — это документы и файлы, создающиеся в процессе разработки.

**Классы Artifact:**
- `PLAN.md` — Архитектурный план (создаётся в Phase 1)
- `source_code` — Исходный код (создаётся в Phase 2)
- `VALIDATION_REPORT.md` — Отчёт о валидации (создаётся в Phase 3)
- `DEBUG_REPORT.md` — Отчёт об ошибках (создаётся при Rabbit Hole)
- `ONTOLOGY_VIOLATION_REPORT.md` — Отчёт об онтологических нарушениях

### Rule (Правила)
Правила — это ограничения и требования, которые должны соблюдаться при разработке.

**Типы Rule:**
- `Technical` — Технические ограничения (типы данных, технологии)
- `Business` — Бизнес-правила (доменная логика)
- `Quality` — Правила качества кода (типизация, тестирование)
- `Security` — Правила безопасности (OWASP, аутентификация)

### Domain (Доменные области)
Доменные области — это предметные области знаний.

**Классы Domain:**
- `Accounting` — Финансовая учёт (NUMERIC(15,2), Transfer vs Expense)
- `Technology` — Технологическая область (Node.js, TypeScript, Next.js, React)
- `Security Testing` — Тестирование безопасности (OWASP Top 10, OWASP ZAP, Burp Suite)
- `UI Development` — Разработка UI (React, shadcn/ui, Radix UI, Tailwind CSS)
- `Database` — Базы данных (Prisma, PostgreSQL, migrations)

### Technology (Технологии)
Технологии — это инструменты и библиотеки, используемые в проекте.

**Классы Technology:**
- `Next.js` — Фреймворк для React-приложений
- `React` — Библиотека UI
- `TypeScript` — Типизация для JavaScript
- `Prisma` — ORM для баз данных
- `PostgreSQL` — Реляционная база данных
- `Zod` — Валидация данных
- `DOMPurify` — Санитизация HTML (XSS защита)
- `Tailwind CSS` — Utility-first CSS фреймворк
- `Radix UI` — Неуправляемые UI компоненты
- `shadcn/ui` — UI компоненты на основе Radix UI
- `Framer Motion` — Анимации для React
- `Zustand` — State management для React
- `TanStack Query` — Data fetching для React
- `OWASP ZAP` — Инструмент для тестирования безопасности
- `Burp Suite` — Инструмент для тестирования безопасности
- `OpenAI API` — LLM API для промптов
- `Anthropic API` — LLM API для промптов

## Отношения между классами

### Agent executes Phase
**Аксиома:** `Agent executes Phase`

**Описание:** Агент может выполнять только те фазы, которые определены для его подкласса.

**Ограничения:**
```yaml
name: "agent_executes_phase"
type: "TECHNICAL"
severity: "CRITICAL"
rule: "agent.phase IN [phase_1, phase_2, phase_3]"
error_message: "⛔ ONTOLOGY VIOLATION: Agent {agent_name} пытается выполнить недопустимую фазу {phase_attempted}. Допустимые фазы для {subclass}: {allowed_phases}."
```

**Примеры:**
- `Architect` может выполнять только `Phase 1` (Архитектура)
- `Executor` может выполнять только `Phase 2` (Выполнение)
- `Validator` может выполнять только `Phase 3` (Валидация)

### Phase produces Artifact
**Аксиома:** `Phase produces Artifact`

**Описание:** Каждая фаза должна создавать только те артефакты, которые определены для неё.

**Ограничения:**
```yaml
name: "phase_produces_artifact"
type: "TECHNICAL"
severity: "CRITICAL"
rule: "phase == phase_1 → artifact == 'docs/PLAN.md'"
rule: "phase == phase_2 → artifact == 'source_code'"
rule: "phase == phase_3 → artifact == 'docs/VALIDATION_REPORT.md'"
error_message: "⛔ ONTOLOGY VIOLATION: Фаза {phase} пытается создать артефакт {artifact_created} вместо {expected_artifact}. Допустимый артефакт для {phase}: {expected_artifact}."
```

**Примеры:**
- `Phase 1` (Architect) создаёт `docs/PLAN.md`
- `Phase 2` (Executor) создаёт `source_code`
- `Phase 3` (Validator) создаёт `docs/VALIDATION_REPORT.md`

### Agent follows Rule
**Аксиома:** `Agent follows Rule`

**Описание:** Агент должен следовать правилам, определённым для него.

**Ограничения:**
```yaml
name: "agent_follows_rule"
type: "QUALITY"
severity: "CRITICAL"
rule: "rule.type == 'Technical' → technology IN [allowed_technologies]"
rule: "rule.type == 'Security' → agent implements Security Best Practices"
error_message: "⛔ ONTOLOGY VIOLATION: Агент {agent_name} нарушает правило {rule_name}. {description}."
```

**Примеры:**
- `Executor` (backend-executor) должен следовать техническому правилу `numeric_types_for_money` (NUMERIC(15,2))
- `Validator` должен следовать правилу `typescript_strict` (no any types)

### Domain requires Technology
**Аксиома:** `Domain requires Technology`

**Описание:** Доменная область требует использования определённых технологий.

**Ограничения:**
```yaml
name: "domain_requires_technology"
type: "TECHNICAL"
severity: "CRITICAL"
rule: "domain == 'Accounting' AND technology IN [Decimal.js, NUMERIC]"
rule: "domain == 'Security Testing' AND technology IN [OWASP ZAP, Burp Suite]"
error_message: "⛔ ONTOLOGY VIOLATION: Домен {domain} требует технологий {technologies}, но использована {technology_used}."
```

**Примеры:**
- Домен `Accounting` требует использования `Decimal.js` (не Float/Double)
- Домен `Security Testing` требует использования `OWASP ZAP` или `Burp Suite`

### Technology constrained by Rule
**Аксиома:** `Technology constrained by Rule`

**Описание:** Правило ограничивает использование технологий.

**Ограничения:**
```yaml
name: "technology_constrained_by_rule"
type: "TECHNICAL"
severity: "CRITICAL"
rule: "rule.name == 'typescript_strict' → NO 'any' type allowed"
rule: "rule.name == 'numeric_types_for_money' → NO 'Float'/'Double Precision' types for money"
error_message: "⛔ ONTOLOGY VIOLATION: Технология {technology} запрещена правилом {rule_name}. {description}."
```

**Примеры:**
- Правило `typescript_strict` запрещает использование типа `any` в TypeScript
- Правило `numeric_types_for_money` запрещает использование `Float`/`Double Precision` для финансовых операций

## Онтологические классы для SecAudit

### Agent классы

#### Architect
```yaml
name: "Architect"
subclass: "Agent"
description: "Архитектор. Создает ТЗ."
expertise:
  - "Architectural Design"
  - "Technology Selection"
  - "Documentation Writing"
phase: "Phase 1"
domain: "Technology"
rules:
  - "technical_rules"
  - "domain_requirements"
```

#### Security Testing Expert (новый)
```yaml
name: "Security Testing Expert"
subclass: "Specialist"
description: "Эксперт по тестированию безопасности. OWASP Top 10, OWASP ZAP, Burp Suite и других инструментов безопасности."
expertise:
  - "OWASP Top 10 Compliance Checking"
  - "Vulnerability Detection (A01-A10)"
  - "Security Headers Analysis"
  - "Cookie Security Analysis"
  - "SSL/TLS Analysis"
  - "CORS Policy Validation"
  - "OWASP ZAP"
  - "Burp Suite"
  - "Security Best Practices"
phase: "Specialist: Security Testing"
domain: "Security Testing"
rules:
  - "security_rules"
  - "owasp_top_10"
  - "csp_security"
  - "ssl_tls_security"
  - "cookie_security"
```

#### Next.js 15 Expert (новый)
```yaml
name: "Next.js 15 Expert"
subclass: "Specialist"
description: "Эксперт по Next.js 15 с App Router, Server Components, Server Actions, Bun runtime."
expertise:
  - "Next.js 15 App Router"
  - "File-based Routing"
  - "Server Components vs Client Components"
  - "Server Actions"
  - "API Routes"
  - "Middleware"
  - "Data Fetching & Caching"
  - "Image Optimization"
  - "Internationalization (next-intl)"
  - "Bun Runtime Integration"
phase: "Specialist: Next.js 15"
domain: "Technology"
rules:
  - "nextjs_rules"
  - "app_router_rules"
  - "server_components_rules"
  - "bun_runtime_rules"
```

#### React UI Expert (новый)
```yaml
name: "React UI Expert"
subclass: "Specialist"
description: "Эксперт по React 19 UI разработке с shadcn/ui, Radix UI, Tailwind CSS, Zustand, TanStack Query для SecAudit."
expertise:
  - "React 19 Features"
  - "shadcn/ui + Radix UI Components"
  - "Tailwind CSS и cn() Utility"
  - "Zustand State Management"
  - "TanStack React Query"
  - "Framer Motion Animations"
  - "Lucide React Icons"
  - "Data Visualization с Recharts"
  - "Form Handling с react-hook-form и Zod"
  - "Accessibility (a11y)"
phase: "Specialist: UI Development"
domain: "UI Development"
rules:
  - "react_rules"
  - "tailwind_rules"
  - "shadcn_rules"
  - "accessibility_rules"
  - "zustand_rules"
  - "tanstack_query_rules"
```

#### Prisma Expert (новый)
```yaml
name: "Prisma Expert"
subclass: "Specialist"
description: "Эксперт по Prisma ORM с глубокими знаниями database schema design, migrations, query optimization и интеграцией с PostgreSQL для SecAudit."
expertise:
  - "Prisma Schema Design"
  - "Prisma Client Setup"
  - "Migrations & Schema Evolution"
  - "Query Operations (findMany, findUnique, create, update, delete, upsert)"
  - "Advanced Queries (filtering, sorting, pagination, relations, selection, aggregation, transactions)"
  - "Query Optimization (indexes, composite indexes, include vs select, cursor-based pagination, N+1 problem)"
  - "Transactions & Concurrency (sequential, interactive, optimistic, pessimistic)"
  - "Prisma Extensions (Accelerate, Pulse, custom extensions)"
  - "Error Handling (PrismaClientKnownRequestError, PrismaClientUnknownRequestError, PrismaClientInitializationError)"
  - "Seeding & Testing (seed files, test database, mocking)"
phase: "Specialist: Database"
domain: "Database"
rules:
  - "prisma_rules"
  - "sql_rules"
  - "transaction_rules"
  - "query_optimization_rules"
  - "error_handling_rules"
```

#### AI Prompt Engineering Expert (новый)
```yaml
name: "AI Prompt Engineering Expert"
subclass: "Specialist"
description: "Эксперт по Prompt Engineering для SecAudit, специализирующийся на создании эффективных промптов для AI-исправления уязвимостей безопасности."
expertise:
  - "Prompt Design Patterns (Chain-of-Thought, Few-Shot Learning, Role Prompting, Context Injection)"
  - "SecAudit-Specific Prompts (OWASP Top 10 Fix Prompts, CSP Improvement Prompts, Security Header Prompts, Cookie Security Prompts, SSL/TLS Fix Prompts)"
  - "Prompt Optimization (Token Efficiency, Clear Instructions, Example Injection, Constraint Definition)"
  - "Prompt Testing & Validation (A/B Testing, Output Quality Metrics, Iterative Refinement)"
phase: "Specialist: AI Prompt Engineering"
domain: "Technology"
rules:
  - "prompt_engineering_rules"
  - "owasp_rules"
  - "context_rules"
  - "token_efficiency_rules"
```

### Domain классы для SecAudit

#### Security Testing Domain
```yaml
name: "Security Testing"
description: "Доменная область для тестирования безопасности."
requires:
  - "OWASP Top 10"
  - "OWASP ZAP"
  - "Burp Suite"
  - "Security Headers"
  - "Cookie Security"
  - "SSL/TLS"
  - "CSP"
  - "CORS"
expertise:
  - "OWASP Top 10 Compliance Checking"
  - "Vulnerability Detection"
  - "Security Headers Analysis"
  - "Cookie Security Analysis"
  - "SSL/TLS Analysis"
```

#### Next.js 15 Domain
```yaml
name: "Next.js 15"
description: "Доменная область для Next.js 15."
requires:
  - "Next.js 15.3.6"
  - "React 19.0.0"
  - "next-auth 4.24.11"
  - "next-intl 4.3.4"
  - "TypeScript 5"
  - "Bun Runtime"
expertise:
  - "App Router"
  - "Server Components"
  - "Server Actions"
  - "API Routes"
  - "Middleware"
  - "Data Fetching"
  - "Image Optimization"
```

#### React UI Domain
```yaml
name: "React UI"
description: "Доменная область для UI разработки."
requires:
  - "React 19.0.0"
  - "shadcn/ui"
  - "Radix UI"
  - "Tailwind CSS 4"
  - "Framer Motion 12.23.2"
  - "Zustand 5.0.6"
  - "TanStack Query 5.82.0"
  - "react-hook-form 7.60.0"
  - "Zod 4.0.2"
  - "Lucide React 0.525.0"
  - "Recharts 2.15.4"
  - "next-themes 0.4.6"
expertise:
  - "shadcn/ui Components"
  - "Tailwind CSS"
  - "Zustand State"
  - "TanStack Query"
  - "Form Handling"
  - "Framer Motion Animations"
  - "Lucide Icons"
  - "Recharts Data Visualization"
  - "Accessibility (a11y)"
```

#### Prisma Domain
```yaml
name: "Prisma"
description: "Доменная область для баз данных."
requires:
  - "Prisma 6.1.0"
  - "PostgreSQL 16"
  - "TypeScript 5"
expertise:
  - "Schema Design"
  - "Migrations"
  - "Query Operations"
  - "Advanced Queries"
  - "Query Optimization"
  - "Transactions"
  - "Error Handling"
  - "Prisma Extensions"
```

#### AI Prompt Engineering Domain
```yaml
name: "AI Prompt Engineering"
description: "Доменная область для Prompt Engineering."
requires:
  - "OpenAI GPT-4 / GPT-4 Turbo API"
  - "Claude 3.5 Sonnet API"
  - "Anthropic Prompt Engineering Guidelines"
expertise:
  - "Chain-of-Thought (CoT)"
  - "Few-Shot Learning"
  - "Role Prompting"
  - "Context Injection"
  - "Prompt Optimization"
  - "Prompt Testing & Validation"
```

### Technology классы для SecAudit

```yaml
name: "Next.js"
version: "15.3.6"
description: "Фреймворк для React-приложений с App Router."

name: "React"
version: "19.0.0"
description: "Библиотека UI."

name: "TypeScript"
version: "5"
description: "Типизация для JavaScript."

name: "Prisma"
version: "6.1.0"
description: "ORM для баз данных."

name: "PostgreSQL"
version: "16"
description: "Реляционная база данных."

name: "Zod"
version: "4.0.2"
description: "Валидация данных."

name: "DOMPurify"
version: "latest"
description: "Санитизация HTML (XSS защита)."

name: "Tailwind CSS"
version: "4"
description: "Utility-first CSS фреймворк."

name: "Radix UI"
version: "latest"
description: "Неуправляемые UI компоненты."

name: "shadcn/ui"
version: "latest"
description: "UI компоненты на основе Radix UI."

name: "Framer Motion"
version: "12.23.2"
description: "Анимации для React."

name: "Zustand"
version: "5.0.6"
description: "State management для React."

name: "TanStack Query"
version: "5.82.0"
description: "Data fetching для React."

name: "react-hook-form"
version: "7.60.0"
description: "Form handling."

name: "next-auth"
version: "4.24.11"
description: "Аутентификация."

name: "next-intl"
version: "4.3.4"
description: "Интернационализация."

name: "Lucide React"
version: "0.525.0"
description: "Иконки."

name: "Recharts"
version: "2.15.4"
description: "Data visualization."

name: "OWASP ZAP"
version: "latest"
description: "Инструмент для тестирования безопасности."

name: "Burp Suite"
version: "latest"
description: "Инструмент для тестирования безопасности."

name: "OpenAI API"
version: "latest"
description: "LLM API для промптов."

name: "Anthropic API"
version: "latest"
description: "LLM API для промптов."

name: "Bun"
version: "latest"
description: "JavaScript runtime."
```

### Rule классы для SecAudit

#### Technical Rules
```yaml
name: "typescript_strict"
type: "Technical"
severity: "CRITICAL"
description: "TypeScript код должен быть в строгом режиме: no any types, только интерфейсы и типы."
enforcement: "AUTOMATIC"
rule: "NO 'any' type allowed in TypeScript code"
error_message: "⛔ ONTOLOGY VIOLATION: Использован тип 'any' в TypeScript. Используйте интерфейсы или типы вместо 'any'."
```

#### Security Rules
```yaml
name: "csp_security"
type: "Security"
severity: "CRITICAL"
description: "Content Security Policy должна быть безопасной: без unsafe-inline/unsafe-eval, с nonce-based script execution."
enforcement: "AUTOMATIC"
rule: "NO 'unsafe-inline' OR 'unsafe-eval' in CSP directives"
error_message: "⛔ SECURITY VIOLATION: CSP содержит unsafe-inline или unsafe-eval директивы. Используйте nonce-based script execution."

name: "cookie_security"
type: "Security"
severity: "HIGH"
description: "Cookies для сессий должны иметь флаги безопасности: HttpOnly, Secure, SameSite."
enforcement: "AUTOMATIC"
rule: "Session cookies MUST have HttpOnly, Secure, and SameSite attributes"
error_message: "⛔ SECURITY VIOLATION: Сессионный cookie не имеет необходимых флагов безопасности: HttpOnly, Secure, SameSite."

name: "ssl_tls_security"
type: "Security"
severity: "CRITICAL"
description: "SSL/TLS версия должна быть актуальной: минимум TLS 1.2, сертификат должен быть валидным."
enforcement: "AUTOMATIC"
rule: "TLS version >= 1.2 AND certificate NOT expired"
error_message: "⛔ SECURITY VIOLATION: Устаревшая TLS версия или истёкший сертификат."

name: "xss_prevention"
type: "Security"
severity: "CRITICAL"
description: "XSS защита: использование DOMPurify, избегание dangerouslySetInnerHTML без санитизации."
enforcement: "AUTOMATIC"
rule: "Use DOMPurify.sanitize() for user input; Avoid dangerouslySetInnerHTML without sanitization"
error_message: "⛔ SECURITY VIOLATION: Потенциальная XSS уязвимость. Используйте DOMPurify для санитизации пользовательского ввода."
```

#### Quality Rules
```yaml
name: "prompt_quality"
type: "Quality"
severity: "MEDIUM"
description: "Промпты должны быть чёткими, конкретными и с ограничениями."
enforcement: "AUTOMATIC"
rule: "Prompt instructions MUST be clear, specific, and include constraints"
error_message: "⛔ PROMPT QUALITY VIOLATION: Промпт размыт или содержит неопределённые инструкции. Сделайте промпт более конкретным."

name: "token_efficiency"
type: "Quality"
severity: "LOW"
description: "Оптимизация использования токенов в промптах."
enforcement: "AUTOMATIC"
rule: "Minimize token usage in prompts while maintaining quality"
error_message: "⛔ TOKEN EFFICIENCY VIOLATION: Промпт слишком длинный. Оптимизируйте использование токенов."
```

## Артефакты

### PLAN.md (Architect Artifact)
Артефакт, создаваемый в Phase 1 (Architect). Содержит:
- Технологический стек
- Архитектурные решения
- План реализации
- Ограничения и правила

### source_code (Executor Artifact)
Артефакт, создаваемый в Phase 2 (Executor). Содержит:
- TypeScript/Node.js код
- Реализация бизнес-логики
- API endpoints
- UI компоненты

### VALIDATION_REPORT.md (Validator Artifact)
Артефакт, создаваемый в Phase 3 (Validator). Содержит:
- Результаты проверки
- Список нарушений
- Рекомендации по исправлению

## Правила валидации

### TypeScript Strict Mode
- ❌ **Запрещено:** Использование типа `any`
- ✅ **Допустимо:** Интерфейсы (`interface`, `type`), Типы (`type`), Union types

### Numeric Types for Money
- ❌ **Запрещено:** Использование `Float`/`Double Precision`
- ✅ **Допустимо:** `BigInt` или `Decimal.js` для финансовых операций

### OWASP Top 10 Compliance
- ✅ **Допустимо:** CSP без `unsafe-inline`/`unsafe-eval`
- ✅ **Допустимо:** Cookies с `HttpOnly`, `Secure`, `SameSite`
- ✅ **Допустимо:** TLS 1.2+ и валидные сертификаты

## Использование онтологической схемы

### При создании новой роли:
1. Определить `name` — уникальное имя роли
2. Определить `subclass` — `Agent` (Architect, Executor, Validator) или `Specialist`
3. Определить `description` — краткое описание ответственности
4. Определить `expertise` — список экспертиз ролей
5. Определить `phase` — фаза выполнения
6. Определить `domain` — доменная область
7. Определить `rules` — список файлов правил

### При создании нового правила:
1. Определить `name` — уникальное имя правила
2. Определить `type` — тип правила (`Technical`, `Business`, `Quality`, `Security`)
3. Определить `severity` — уровень критичности (`CRITICAL`, `HIGH`, `MEDIUM`, `LOW`)
4. Определить `description` — описание правила
5. Определить `rule` — логическое правило проверки
6. Определить `enforcement` — тип принуждения (`AUTOMATIC` или `MANUAL`)
7. Определить `error_message` — сообщение об ошибке

---

**Версия:** 1.0.0
**Последнее обновление:** 2026-01-17
**Домены:** Accounting, Technology, Security Testing, UI Development, Database, AI Prompt Engineering