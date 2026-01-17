# 🎭 Cursor Rules — Роли для AI-разработки

Система ролей для Cursor IDE, адаптированная из AIRules skills. Каждая роль предоставляет специализированную экспертизу для конкретных задач разработки.

## 📁 Структура правил

### Современный формат (2025-2026)

Правила в современном формате находятся в `.cursor/rules/*.mdc` с метаданными frontmatter:

```yaml
---
description: Краткое описание правила
globs: ["**/*.ts", "**/*.tsx"]  # Опционально: файлы/папки для применения
alwaysApply: true  # или false для "Apply Intelligently"
---
```

**Режимы применения:**
- **Always Apply** (`alwaysApply: true`) — правило всегда применяется
- **Apply Intelligently** (`alwaysApply: false`) — ИИ сам решает когда применять
- **Apply to Files/Folders** (через `globs`) — правило активируется только при работе с указанными файлами

### Legacy формат

Старые правила в `cursor-rules/*/protocol.md` остаются для совместимости, но рекомендуется использовать новый формат в `.cursor/rules/*.mdc`.

---

## 📋 Доступные роли

### Современный формат (`.cursor/rules/*.mdc`)

Все правила доступны в `.cursor/rules/` с полной поддержкой метаданных и режимов применения.

### 🏗️ Core Development Workflow

| Роль | Файл | Назначение | Режим применения |
|------|------|-----------|------------------|
| **architect** | [`.cursor/rules/architect.mdc`](../.cursor/rules/architect.mdc) | Архитектор систем | Always Apply |
| **backend-executor** | [`.cursor/rules/backend-executor.mdc`](../.cursor/rules/backend-executor.mdc) | Backend разработчик | Apply Intelligently |
| **validator** | [`.cursor/rules/validator.mdc`](../.cursor/rules/validator.mdc) | QA инженер | Always Apply |

### 📚 Documentation & Quality

| Роль | Файл | Назначение | Режим применения |
|------|------|-----------|------------------|
| **librarian** | [`.cursor/rules/librarian.mdc`](../.cursor/rules/librarian.mdc) | Библиотекарь документации | Always Apply (для `.md` файлов) |
| **documentation** | [`.cursor/rules/documentation.mdc`](../.cursor/rules/documentation.mdc) | Технический писатель | Apply to Files (`**/*.md`) |
| **prompt-engineering** | [`.cursor/rules/prompt-engineering.mdc`](../.cursor/rules/prompt-engineering.mdc) | Эксперт по промптам | Apply Intelligently |

### 🔍 Research & Knowledge

| Роль | Файл | Назначение | Режим применения |
|------|------|-----------|------------------|
| **research** | [`.cursor/rules/research.mdc`](../.cursor/rules/research.mdc) | Исследователь (Context7) | Apply Intelligently |
| **rag** | [`.cursor/rules/rag.mdc`](../.cursor/rules/rag.mdc) | RAG эксперт | Apply Intelligently |
| **ontology** | [`.cursor/rules/ontology.mdc`](../.cursor/rules/ontology.mdc) | Онтологический инженер | Apply Intelligently |
| **ontology-syncer** | [`.cursor/rules/ontology-syncer.mdc`](../.cursor/rules/ontology-syncer.mdc) | Синхронизация онтологии | Apply Intelligently |

### 🚀 Deployment & Infrastructure

| Роль | Файл | Назначение | Режим применения |
|------|------|-----------|------------------|
| **deployment-vercel** | [`.cursor/rules/deployment-vercel.mdc`](../.cursor/rules/deployment-vercel.mdc) | Vercel специалист | Apply to Files (`**/vercel.json`) |
| **deployment-netlify** | [`.cursor/rules/deployment-netlify.mdc`](../.cursor/rules/deployment-netlify.mdc) | Netlify специалист | Apply to Files (`**/netlify.toml`) |
| **database-supabase** | [`.cursor/rules/database-supabase.mdc`](../.cursor/rules/database-supabase.mdc) | Supabase инженер | Apply to Files (`**/supabase/**`, `**/*.sql`) |
| **devops-infrastructure** | [`.cursor/rules/devops-infrastructure.mdc`](../.cursor/rules/devops-infrastructure.mdc) | DevOps инженер | Apply Intelligently |
| **infra-setup** | [`.cursor/rules/infra-setup.mdc`](../.cursor/rules/infra-setup.mdc) | Инфраструктура (Terraform/Ansible) | Always Apply |

### 🤖 AI & Media

| Роль | Файл | Назначение | Режим применения |
|------|------|-----------|------------------|
| **llm** | [`.cursor/rules/llm.mdc`](../.cursor/rules/llm.mdc) | LLM с публичными API | Apply Intelligently |
| **llm-openai** | [`.cursor/rules/llm-openai.mdc`](../.cursor/rules/llm-openai.mdc) | LLM с OpenAI API | Apply Intelligently |
| **llm-web** | [`.cursor/rules/llm-web.mdc`](../.cursor/rules/llm-web.mdc) | LLM через браузер (Заюшь) | Apply Intelligently |
| **image-generation** | [`.cursor/rules/image-generation.mdc`](../.cursor/rules/image-generation.mdc) | Генерация изображений | Apply to Files (`**/*image*.ts`) |
| **video-generation** | [`.cursor/rules/video-generation.mdc`](../.cursor/rules/video-generation.mdc) | Генерация видео | Apply to Files (`**/*video*.ts`) |
| **tts** | [`.cursor/rules/tts.mdc`](../.cursor/rules/tts.mdc) | Text-to-Speech | Apply to Files (`**/*tts*.ts`) |
| **asr** | [`.cursor/rules/asr.mdc`](../.cursor/rules/asr.mdc) | Automatic Speech Recognition | Apply to Files (`**/*asr*.ts`) |
| **vlm** | [`.cursor/rules/vlm.mdc`](../.cursor/rules/vlm.mdc) | Vision Language Model | Apply to Files (`**/*vlm*.ts`) |

### 🎨 Frontend & Design

| Роль | Файл | Назначение | Режим применения |
|------|------|-----------|------------------|
| **frontend-design** | [`.cursor/rules/frontend-design.mdc`](../.cursor/rules/frontend-design.mdc) | Frontend дизайн | Apply to Files (`**/*.tsx`, `**/*.jsx`) |
| **canvas-design** | [`.cursor/rules/canvas-design.mdc`](../.cursor/rules/canvas-design.mdc) | Canvas API дизайн | Apply to Files (`**/*canvas*.ts`) |

### 🧪 Testing

| Роль | Файл | Назначение | Режим применения |
|------|------|-----------|------------------|
| **e2e-testing** | [`.cursor/rules/e2e-testing.mdc`](../.cursor/rules/e2e-testing.mdc) | E2E тестирование | Apply to Files (`**/*.spec.ts`, `**/*.e2e.ts`) |

### 🌐 Web & Search

| Роль | Файл | Назначение | Режим применения |
|------|------|-----------|------------------|
| **web-search** | [`.cursor/rules/web-search.mdc`](../.cursor/rules/web-search.mdc) | Поиск в интернете | Apply Intelligently |
| **web-reader** | [`.cursor/rules/web-reader.mdc`](../.cursor/rules/web-reader.mdc) | Чтение веб-страниц | Apply Intelligently |

### 📄 Document Processing

| Роль | Файл | Назначение | Режим применения |
|------|------|-----------|------------------|
| **docx** | [`.cursor/rules/docx.mdc`](../.cursor/rules/docx.mdc) | Работа с DOCX | Apply to Files (`**/*.docx`) |
| **pdf** | [`.cursor/rules/pdf.mdc`](../.cursor/rules/pdf.mdc) | Работа с PDF | Apply to Files (`**/*.pdf`) |
| **pptx** | [`.cursor/rules/pptx.mdc`](../.cursor/rules/pptx.mdc) | Работа с PPTX | Apply to Files (`**/*.pptx`) |
| **xlsx** | [`.cursor/rules/xlsx.mdc`](../.cursor/rules/xlsx.mdc) | Работа с XLSX | Apply to Files (`**/*.xlsx`) |

---

## 🔄 Рабочий процесс

### Стандартный workflow разработки:

```
1. 🏗️ Architect → Создает ТЗ и план
2. 💻 Backend Executor → Реализует код (TDD)
3. ✅ Validator → Проверяет качество
4. 📚 Documentation → Документирует решение
```

### С дополнительными ролями:

```
Research → Architect → Backend Executor → Ontology → Validator
   ↓         ↓            ↓              ↓         ↓
Context7 → Planning → Implementation → Analysis → Quality Check
```

---

## 🎯 Специализация ролей

### Architect (Планирование)
- ✅ Создает TASK_SPEC.md
- ❌ НЕ пишет код
- Фокус: архитектура, технологии, MVP подход

### Backend Executor (Реализация)
- ✅ Пишет код по ТЗ
- ✅ TDD подход (тесты сначала)
- ✅ Context Hygiene (изоляция контекста)
- Фокус: реализация, качество кода

### Validator (Проверка)
- ✅ Проверяет соответствие ТЗ
- ✅ Security и compliance
- ✅ Code quality standards
- ❌ НЕ изменяет код

### Research (Исследование)
- ✅ Context7 интеграция
- ✅ Верификация технологий
- ✅ Best practices
- Фокус: техническая экспертиза

### Ontology (Анализ)
- ✅ Зависимости проекта
- ✅ Memory Graph
- ✅ Domain validation
- Фокус: структура и связи

### Documentation (Документация)
- ✅ Diátaxis framework
- ✅ Docs-as-Code
- ✅ Technical writing
- Фокус: качество документации

---

## 🔧 Интеграция с MCP

Роли автоматически интегрируются с MCP серверами:

- **Context7**: Исследование документации
- **Memory Graph**: Хранение знаний
- **Sequential Thinking**: Структурированное мышление
- **Filesystem/Git**: Работа с файлами

---

## 📊 Производительность ролей

| Роль | Типовые задачи | Время выполнения | Качество результата |
|------|----------------|------------------|-------------------|
| Architect | Планирование системы | 15-30 мин | Высокое (структурировано) |
| Backend Executor | Реализация фич | 30-120 мин | Высокое (TDD + tests) |
| Validator | Проверка кода | 10-20 мин | Высокое (систематично) |
| Research | Техническое исследование | 5-15 мин | Высокое (экспертное) |
| Ontology | Анализ зависимостей | 5-10 мин | Высокое (автоматизировано) |
| Documentation | Написание docs | 20-60 мин | Высокое (стандартизировано) |

---

## 🚀 Быстрый старт

### 1. Выберите задачу
```
"Создай REST API для управления пользователями"
```

### 2. Cursor автоматически активирует роли
```
Architect → планирует API
Backend Executor → реализует endpoints
Validator → проверяет код
```

### 3. Используйте специфические роли
```
/architect Создай ТЗ для чата
/backend-executor Реализуй WebSocket сервер
/validator Проверь безопасность
```

---

## 📚 Документация

### Основные руководства
- **[Architect Protocol](./architect/protocol.md)** — Планирование и архитектура
- **[Backend Executor Protocol](./backend-executor/protocol.md)** — Реализация и TDD
- **[Validator Protocol](./validator/protocol.md)** — Качество и безопасность
- **[Research Protocol](./research/protocol.md)** — Техническое исследование

### Специализированные роли
- **[Ontology Protocol](./ontology/protocol.md)** — Анализ зависимостей
- **[Documentation Protocol](./documentation/protocol.md)** — Техническое писательство
- **[Vercel Deployment](./deployment/vercel/protocol.md)** — Деплой на Vercel
- **[Supabase Database](./database/supabase/protocol.md)** — Работа с Supabase

---

## 🎨 Адаптация из Skills

Эти роли адаптированы из AIRules skills системы (`.cline/skills/` и `.clinerules/roles/`):

| Skill (оригинал) | Rule (адаптация) | Файл | Изменения |
|------------------|------------------|------|-----------|
| architect | architect | `.cursor/rules/architect.mdc` | Полная адаптация протокола |
| backend-executor | backend-executor | `.cursor/rules/backend-executor.mdc` | Добавлен TDD фокус |
| validator | validator | `.cursor/rules/validator.mdc` | Усилена security проверка |
| librarian | librarian | `.cursor/rules/librarian.mdc` | Diátaxis и Docs-as-Code |
| context7-researcher | research | `.cursor/rules/research.mdc` | Интеграция с Context7 |
| rag-expert | rag | `.cursor/rules/rag.mdc` | RAG паттерны |
| ontologist | ontology | `.cursor/rules/ontology.mdc` | Memory Graph фокус |
| ontologist-syncer | ontology-syncer | `.cursor/rules/ontology-syncer.mdc` | Синхронизация графа |
| vercel-expert | deployment-vercel | `.cursor/rules/deployment-vercel.mdc` | Оптимизация для Next.js |
| netlify-expert | deployment-netlify | `.cursor/rules/deployment-netlify.mdc` | Netlify деплой |
| supabase-expert | database-supabase | `.cursor/rules/database-supabase.mdc` | RLS и Auth фокус |
| LLM-web | llm-web | `.cursor/rules/llm-web.mdc` | Браузерная автоматизация |
| image-generation | image-generation | `.cursor/rules/image-generation.mdc` | AI генерация изображений |
| video-generation | video-generation | `.cursor/rules/video-generation.mdc` | AI генерация видео |
| frontend-design | frontend-design | `.cursor/rules/frontend-design.mdc` | Design tokens подход |
| e2e-testing-expert | e2e-testing | `.cursor/rules/e2e-testing.mdc` | Playwright/Cypress |
| prompt-engineering-expert | prompt-engineering | `.cursor/rules/prompt-engineering.mdc` | Оптимизация промптов |

**Всего мигрировано:** 32 правила из `.cline/skills/` и `.clinerules/roles/` в современный формат `.cursor/rules/*.mdc`

---

## 🔄 Обновления

- **v1.0.0** — Начальная версия с core ролями
- **v1.1.0** — Добавлены research и ontology роли
- **v1.2.0** — Интеграция deployment и database ролей
- **v1.3.0** — Media generation роль
- **v2.0.0** — Миграция в современный формат `.cursor/rules/*.mdc` с frontmatter метаданными
  - ✅ Все 32 skills мигрированы из `.cline/skills/` и `.clinerules/roles/`
  - ✅ Добавлены метаданные (description, globs, alwaysApply)
  - ✅ Определены режимы применения для каждого правила
  - ✅ Особое внимание к librarian (критический приоритет)

---

## 📋 Контроль качества

### Автоматические проверки
- ✅ Все `.mdc` файлы созданы в `.cursor/rules/`
- ✅ Frontmatter метаданные добавлены ко всем правилам
- ✅ Режимы применения определены
- ✅ Globs настроены для файл-специфичных правил
- ✅ Интеграция с MCP серверами сохранена

### Структура файлов

```
.cursor/rules/
├── architect.mdc (Always Apply)
├── backend-executor.mdc (Apply Intelligently)
├── validator.mdc (Always Apply)
├── librarian.mdc (Always Apply для .md файлов) ⭐
├── research.mdc (Apply Intelligently)
├── rag.mdc (Apply Intelligently)
├── ontology.mdc (Apply Intelligently)
├── ontology-syncer.mdc (Apply Intelligently)
├── database-supabase.mdc (Apply to Files: **/supabase/**)
├── deployment-vercel.mdc (Apply to Files: **/vercel.json)
├── deployment-netlify.mdc (Apply to Files: **/netlify.toml)
├── devops-infrastructure.mdc (Apply Intelligently)
├── infra-setup.mdc (Always Apply)
├── documentation.mdc (Apply to Files: **/*.md)
├── prompt-engineering.mdc (Apply Intelligently)
├── llm.mdc (Apply Intelligently)
├── llm-openai.mdc (Apply Intelligently)
├── llm-web.mdc (Apply Intelligently)
├── image-generation.mdc (Apply to Files: **/*image*.ts)
├── video-generation.mdc (Apply to Files: **/*video*.ts)
├── tts.mdc (Apply to Files: **/*tts*.ts)
├── asr.mdc (Apply to Files: **/*asr*.ts)
├── vlm.mdc (Apply to Files: **/*vlm*.ts)
├── frontend-design.mdc (Apply to Files: **/*.tsx, **/*.jsx)
├── canvas-design.mdc (Apply to Files: **/*canvas*.ts)
├── e2e-testing.mdc (Apply to Files: **/*.spec.ts, **/*.e2e.ts)
├── web-search.mdc (Apply Intelligently)
├── web-reader.mdc (Apply Intelligently)
├── docx.mdc (Apply to Files: **/*.docx)
├── pdf.mdc (Apply to Files: **/*.pdf)
├── pptx.mdc (Apply to Files: **/*.pptx)
└── xlsx.mdc (Apply to Files: **/*.xlsx, **/*.xls)
```

### Ручные проверки
- [ ] Тестирование workflow в реальных проектах
- [ ] Валидация качества результатов
- [ ] Обратная связь от пользователей

---

## 📚 Дополнительная информация

### Legacy формат

Старые правила в `cursor-rules/*/protocol.md` остаются для совместимости, но рекомендуется использовать новый формат в `.cursor/rules/*.mdc`.

### Совместимость

- `.clinerules/` — для совместимости с Cline
- `.cline/skills/` — для совместимости с Cline
- `cursor-rules/` — legacy формат (можно пометить как устаревший)

### Миграция завершена

Все правила из `.cline/skills/` и `.clinerules/roles/` успешно мигрированы в современный формат Cursor с метаданными и режимами применения.