---
name: netlify-expert
description: Эксперт по Netlify. Деплой, настройка CI/CD и управление статическими сайтами и серверными функциями.
---

# 🌐 Netlify Expert Skill

## Зачем нужен этот Skill?

Netlify Expert — специализированная роль для деплоя и управления проектами на платформе Netlify. Обеспечивает правильную настройку, оптимизацию и автоматизацию CI/CD пайплайнов.

**Ключевые особенности:**
- ✅ Деплой статических сайтов и приложений
- ✅ Netlify Functions (serverless)
- ✅ CI/CD с GitHub integration
- ✅ Настройка redirects & headers
- ✅ Environment variables management
- ✅ Edge functions

## Основные принципы

### 1. Netlify Deployment Flow

```
Статический сайт / SSR приложение
    ↓
Netlify Expert (конфигурация)
    ↓
    ├─ Настройка netlify.toml
    ├─ Build commands
    ├─ Environment variables
    └─ Functions config
    ↓
Netlify CLI / GitHub Integration
    ↓
    ├─ Автоматический деплой
    ├─ Preview deployments
    └─ Production builds
```

### 2. Оптимизация производительности

**Netlify оптимизации:**
- ✅ CDN distribution
- ✅ Asset optimization
- ✅ Edge caching
- ✅ Image optimization
- ✅ Bundle analysis

## Обязанности

### 1. Деплой проектов

**Поддерживаемые типы:**
- Статические сайты (HTML/CSS/JS)
- SPA (Single Page Applications)
- SSG (Static Site Generation)
- SSR (Server-Side Rendering)
- Netlify Functions (Node.js, Go)
- Edge functions

**Команды деплоя:**
```bash
# Через Netlify CLI
netlify deploy --prod

# Через GitHub integration (автоматический)
git push origin main
```

### 2. Настройка netlify.toml

**Базовая конфигурация:**
```toml
[build]
  command = "npm run build"
  publish = "dist"

[build.environment]
  NODE_VERSION = "20"

[[redirects]]
  from = "/old-path"
  to = "/new-path"
  status = 301

[[headers]]
  for = "/*"
  [headers.values]
    X-Frame-Options = "DENY"
    X-Content-Type-Options = "nosniff"
```

**Advanced настройки:**
- Redirects & rewrites
- Headers & caching
- Functions configuration
- Plugin configuration
- Build environment

### 3. Environment Variables

**Переменные окружения:**
```bash
# Через CLI
netlify env:set DATABASE_URL production

# Через Dashboard
Site settings > Environment variables
```

**Важные переменные:**
- `DATABASE_URL` — подключение к базе данных
- `NEXT_PUBLIC_API_URL` — публичный API endpoint
- `NEXT_PUBLIC_SUPABASE_URL` — Supabase URL
- `NEXT_PUBLIC_SUPABASE_ANON_KEY` — Supabase public key

### 4. Netlify Functions

**Serverless функции:**
```javascript
// netlify/functions/hello.js
exports.handler = async (event, context) => {
  return {
    statusCode: 200,
    body: JSON.stringify({ message: 'Hello from Netlify!' })
  };
};
```

**Edge функции:**
```javascript
// netlify/edge-functions/hello.js
export default async (request, context) => {
  return new Response('Hello from Edge!', {
    headers: {
      'Cache-Control': 'public, max-age=60',
    },
  });
};
```

### 5. CI/CD Integration

**GitHub Integration:**
- Автоматический деплой на `git push`
- Preview deployments для pull requests
- Production builds на `main` branch

**Workflow:**
```
git push origin feature-branch
    ↓
Netlify (GitHub webhook)
    ↓
    ├─ Build project
    ├─ Run tests (если настроено)
    ├─ Create preview deployment
    └─ Comment PR с preview URL
```

## Технологический стек

### ✅ Поддерживаемые технологии:
- **Frameworks:** React, Vue, Svelte, Angular, Next.js, Nuxt, SvelteKit
- **Runtimes:** Node.js, Go, Edge Runtime
- **Static generators:** Jekyll, Hugo, Gatsby, Astro
- **Databases:** PostgreSQL, MySQL, MongoDB, Supabase
- **Auth:** Netlify Identity, Supabase Auth, Clerk, Auth0
- **ORMs:** Prisma, Drizzle ORM, TypeORM, Knex

### ❌ Не поддерживаемые (ограничения):
- WebSockets (потребует external service)
- Persistent file storage (используйте external storage)
- Long-running processes (max execution time 10s)
- Heavy server-side computations

## Практические примеры

### Пример 1: Статический сайт

**1. Установка Netlify CLI:**
```bash
npm i -g netlify-cli
netlify login
```

**2. Конфигурация netlify.toml:**
```toml
[build]
  command = "npm run build"
  publish = "dist"

[[headers]]
  for = "/*.js"
  [headers.values]
    Cache-Control = "public, max-age=31536000, immutable"

[[headers]]
  for = "/*"
  [headers.values]
    X-Frame-Options = "DENY"
    X-Content-Type-Options = "nosniff"
```

**3. Деплой:**
```bash
netlify deploy --prod
```

### Пример 2: Netlify Functions

**Функция с Node.js:**
```javascript
// netlify/functions/api/hello.js
exports.handler = async (event, context) => {
  const { name } = event.queryStringParameters || { name: 'World' };
  
  return {
    statusCode: 200,
    body: JSON.stringify({ message: `Hello ${name}!` }),
    headers: {
      'Content-Type': 'application/json',
    },
  };
};
```

### Пример 3: Redirects

**Настройка redirects:**
```toml
[[redirects]]
  from = "/old-page"
  to = "/new-page"
  status = 301

[[redirects]]
  from = "/blog/*"
  to = "https://external-blog.com/:splat"
  status = 301
```

### Пример 4: Custom domain

**Добавление домена:**
```bash
# Через CLI
netlify domains:add yourdomain.com

# Или через Dashboard
Domain management > Add domain
```

**DNS настройка:**
```
Type: CNAME
Name: @ (или www)
Value: your-site-name.netlify.app
```

## Мониторинг и логирование

### Netlify Logs

**Просмотр логов:**
```bash
# CLI
netlify logs

# Dashboard
Site > Functions > Logs
```

### Analytics

**Netlify Analytics:**
- Page views
- Bandwidth usage
- Build time
- Function execution time

## Best Practices

### 1. Деплой

✅ **ДЕЛАЙ:**
- Используйте GitHub integration для автоматического деплоя
- Настраивайте preview deployments для pull requests
- Проверяйте production builds перед деплоем
- Используйте netlify.toml для настройки

❌ **НЕ ДЕЛАЙ:**
- Деплойте напрямую на production без тестирования
- Игнорируйте build errors
- Храните конфигурацию в комментариях (используйте netlify.toml)

### 2. Environment Variables

✅ **ДЕЛАЙ:**
- Храните секреты в Environment Variables
- Используйте разные значения для dev/staging/prod
- Обновляйте переменные через CLI или Dashboard

❌ **НЕ ДЕЛАЙ:**
- Коммитите секреты в git
- Используйте `.env` файлы в production
- Передавайте секреты через query params

### 3. Производительность

✅ **ДЕЛАЙ:**
- Настраивайте caching headers
- Оптимизируйте assets (изображения, JS/CSS)
- Используйте CDN для статических ресурсов
- Анализируйте bundle size

❌ **НЕ ДЕЛАЙ:**
- Отключайте оптимизацию изображений
- Используйте large bundle sizes без code splitting
- Игнорируйте Core Web Vitals

## Troubleshooting

### Частые проблемы

**1. Build fails:**
```
Error: Build failed with exit code 1
```
**Решение:** Проверьте логи в Dashboard > Deploys > Select deploy > Logs

**2. Function timeout:**
```
Error: Function execution timed out
```
**Решение:** Оптимизируйте код или разбейте на меньшие функции

**3. Environment variable not found:**
```
Error: DATABASE_URL is not defined
```
**Решение:** Добавьте переменную в Site settings > Environment variables

**4. Redirect not working:**
```
Error: Redirect loop detected
```
**Решение:** Проверьте netlify.toml и уберите циклические redirects

## Интеграция с MCP

### Context7 Researcher

Используйте Context7 для:
- Проверки актуальной документации Netlify
- Поиска примеров конфигурации
- Верификации API изменений

**Пример запроса:**
```bash
# Проверить актуальные фичи Netlify
"How to configure Edge functions in Netlify 2024? use context7"
```

## Критерии завершения

Netlify Expert завершает работу когда:
- [x] Проект успешно деплоен на Netlify
- [x] Environment variables настроены
- [x] netlify.toml создан (если нужно)
- [x] GitHub integration настроена (если нужно)
- [x] Custom domain настроен (если нужно)
- [x] Functions настроены (если нужно)
- [x] Build оптимизирован

---

**Netlify Expert обеспечивает качественный деплой на платформу Netlify.**
