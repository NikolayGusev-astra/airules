---
name: vercel-expert
description: Эксперт по Vercel. Деплой, настройка CI/CD и управление проектами на платформе Vercel.
---

# 🚀 Vercel Expert Skill

## Зачем нужен этот Skill?

Vercel Expert — специализированная роль для деплоя и управления проектами на платформе Vercel. Обеспечивает правильную настройку, оптимизацию и автоматизацию CI/CD пайплайнов.

**Ключевые особенности:**
- ✅ Деплой приложений на Vercel
- ✅ Настройка CI/CD с GitHub integration
- ✅ Оптимизация производительности
- ✅ Управление environment variables
- ✅ Настройка custom domains
- ✅ Edge functions и serverless functions

## Основные принципы

### 1. Vercel Deployment Flow

```
Next.js/React проект
    ↓
Vercel Expert (конфигурация)
    ↓
    ├─ Настройка vercel.json
    ├─ Environment variables
    ├─ Build commands
    └─ Deploy settings
    ↓
Vercel CLI / GitHub Integration
    ↓
    ├─ Автоматический деплой
    ├─ Preview deployments
    └─ Production builds
```

### 2. Оптимизация производительности

**Vercel оптимизации:**
- ✅ Image optimization (next/image)
- ✅ Static generation (getStaticProps)
- ✅ ISR (Incremental Static Regeneration)
- ✅ Edge caching headers
- ✅ CDN configuration

## Обязанности

### 1. Деплой проектов

**Поддерживаемые фреймворки:**
- Next.js (native support)
- React (SPA)
- Node.js (API routes)
- Static sites (HTML/CSS/JS)
- Serverless functions

**Команды деплоя:**
```bash
# Через Vercel CLI
vercel --prod

# Через GitHub integration (автоматический)
git push origin main
```

### 2. Настройка vercel.json

**Базовая конфигурация:**
```json
{
  "version": 2,
  "buildCommand": "npm run build",
  "devCommand": "npm run dev",
  "installCommand": "npm install",
  "framework": "nextjs",
  "outputDirectory": ".next"
}
```

**Advanced настройки:**
- Rewrites & redirects
- Headers & caching
- Edge functions routes
- Regional deployments
- Build environment

### 3. Environment Variables

**Переменные окружения:**
```bash
# Через CLI
vercel env add DATABASE_URL production

# Через Dashboard
Settings > Environment Variables
```

**Важные переменные:**
- `DATABASE_URL` — подключение к базе данных
- `NEXT_PUBLIC_API_URL` — публичный API endpoint
- `NEXT_PUBLIC_SUPABASE_URL` — Supabase URL
- `NEXT_PUBLIC_SUPABASE_ANON_KEY` — Supabase public key

### 4. CI/CD Integration

**GitHub Integration:**
- Автоматический деплой на `git push`
- Preview deployments для pull requests
- Production builds на `main` branch

**Workflow:**
```
git push origin feature-branch
    ↓
Vercel (GitHub webhook)
    ↓
    ├─ Build project
    ├─ Run tests (если настроено)
    ├─ Create preview deployment
    └─ Comment PR с preview URL
```

## Технологический стек

### ✅ Поддерживаемые технологии:
- **Frameworks:** Next.js, React, Vue, Svelte, Nuxt
- **Runtimes:** Node.js, Edge Runtime
- **Databases:** PostgreSQL, MySQL, MongoDB, Supabase
- **Auth:** NextAuth, Supabase Auth, Clerk, Auth0
- **ORFMs:** Prisma, Drizzle ORM, TypeORM

### ❌ Не поддерживаемые (ограничения):
- Heavy server-side computations (timeout limit 10-60s)
- WebSockets (unsupported)
- Persistent file storage (use external S3/R2)
- Background jobs (use cron functions)

## Практические примеры

### Пример 1: Next.js деплой

**1. Установка Vercel CLI:**
```bash
npm i -g vercel
vercel login
```

**2. Конфигурация vercel.json:**
```json
{
  "version": 2,
  "framework": "nextjs",
  "regions": ["iad1"],
  "functions": {
    "app/**/*.js": {
      "runtime": "nodejs20.x"
    }
  },
  "headers": [
    {
      "source": "/(.*)",
      "headers": [
        {
          "key": "X-Content-Type-Options",
          "value": "nosniff"
        }
      ]
    }
  ]
}
```

**3. Деплой:**
```bash
vercel --prod
```

### Пример 2: Environment variables

**Настройка через CLI:**
```bash
# Production
vercel env add DATABASE_URL production

# Preview environments
vercel env add DATABASE_URL preview --branch=develop

# Development
vercel env add DATABASE_URL development
```

### Пример 3: Custom domain

**Добавление домена:**
```bash
# Через CLI
vercel domains add yourdomain.com

# Или через Dashboard
Domains > Add Domain
```

**DNS настройка:**
```
Type: CNAME
Name: @ (или www)
Value: cname.vercel-dns.com
```

### Пример 4: Edge functions

**API route с Edge runtime:**
```typescript
// app/api/hello/route.ts
export const runtime = 'edge';

export async function GET(request: Request) {
  return new Response('Hello from Edge!', {
    headers: {
      'Cache-Control': 's-maxage=60',
    },
  });
}
```

## Мониторинг и логирование

### Vercel Logs

**Просмотр логов:**
```bash
# CLI
vercel logs --follow

# Dashboard
Deployments > Select deployment > Logs
```

**Фильтрация логов:**
- `filter` — фильтрация по уровню (error, warn, info)
- `source` — фильтрация по source (build, lambda)
- `code` — фильтрация по HTTP коду

### Analytics

**Vercel Analytics:**
- Real-time page views
- Core Web Vitals (LCP, FID, CLS)
- Geography distribution
- Device breakdown

**Интеграция в Next.js:**
```typescript
// app/layout.tsx
import { Analytics } from '@vercel/analytics/react';

export default function RootLayout({ children }) {
  return (
    <html>
      <head>
        <Analytics />
      </head>
      <body>{children}</body>
    </html>
  );
}
```

## Best Practices

### 1. Деплой

✅ **ДЕЛАЙ:**
- Используйте GitHub integration для автоматического деплоя
- Настраивайте preview deployments для pull requests
- Используйте branch-based deployments
- Проверяйте production builds перед деплоем

❌ **НЕ ДЕЛАЙ:**
- Деплойте напрямую на production без тестирования
- Игнорируйте build errors
- Используйте `vercel.json` для чувствительных данных

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
- Используйте next/image для оптимизации изображений
- Включите ISR для динамических страниц
- Настраивайте Edge caching headers
- Используйте Analytics для мониторинга

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
**Решение:** Проверьте логи в Dashboard > Deployments > Logs

**2. Timeout exceeded:**
```
Error: Function execution time exceeded maximum
```
**Решение:** Оптимизируйте код или перейдите на serverless functions

**3. Environment variable not found:**
```
Error: DATABASE_URL is not defined
```
**Решение:** Добавьте переменную в Settings > Environment Variables

**4. Custom domain not working:**
```
Error: DNS configuration error
```
**Решение:** Проверьте DNS records и TTL settings

## Интеграция с MCP

### Context7 Researcher

Используйте Context7 для:
- Проверки актуальной документации Vercel
- Поиска примеров конфигурации
- Верификации API изменений

**Пример запроса:**
```bash
# Проверить актуальные фичи Vercel
"How to configure Edge functions in Vercel 2024? use context7"
```

## Критерии завершения

Vercel Expert завершает работу когда:
- [x] Проект успешно деплоен на Vercel
- [x] Environment variables настроены
- [x] vercel.json создан (если нужно)
- [x] GitHub integration настроена (если нужно)
- [x] Custom domain настроен (если нужно)
- [x] Analytics подключены
- [x] Build оптимизирован

---

**Vercel Expert обеспечивает качественный деплой на платформу Vercel.**
