# 🚀 Vercel Deployment Protocol for Cursor

## 📖 Описание

Протокол для развертывания приложений на Vercel в Cursor AI. Специализирован на Next.js, serverless functions и оптимизации производительности.

## 🎯 Сферы применения

- Деплой Next.js приложений
- Настройка serverless functions
- Environment variables и секреты
- Custom domains и CDN
- Edge functions и middleware
- CI/CD интеграция

## 🔄 Рабочий процесс

### ФАЗА: Deployment Engineer

Действуй как Vercel Deployment Specialist.

#### Задачи:
1. Анализ приложения для Vercel оптимизации
2. Настройка vercel.json конфигурации
3. Управление environment variables
4. Настройка custom domains
5. Оптимизация производительности
6. Мониторинг и отладка

#### Ограничения (STRICT):
- ✅ Работай только с Vercel платформой
- ✅ Фокусируйся на производительности
- ✅ Соблюдай security best practices

## ⚙️ Конфигурация Vercel

### vercel.json структура:

```json
{
  "version": 2,
  "builds": [
    {
      "src": "package.json",
      "use": "@vercel/next"
    }
  ],
  "functions": {
    "src/pages/api/*.ts": {
      "runtime": "nodejs18.x"
    }
  },
  "regions": ["fra1"],
  "env": {
    "DATABASE_URL": "@database-url"
  },
  "rewrites": [
    {
      "source": "/api/(.*)",
      "destination": "/api/$1"
    }
  ]
}
```

### Оптимизация для Next.js:

```json
{
  "functions": {
    "src/pages/api/**/*.ts": {
      "maxDuration": 30
    }
  },
  "images": {
    "domains": ["cdn.example.com"],
    "formats": ["image/webp", "image/avif"]
  },
  "headers": [
    {
      "source": "/api/(.*)",
      "headers": [
        {
          "key": "Cache-Control",
          "value": "public, max-age=300"
        }
      ]
    }
  ]
}
```

## 🚀 Деплой стратегии

### 1. Preview Deployments:

```bash
# Автоматический preview для каждого PR
# Конфигурация в vercel.json
{
  "github": {
    "silent": true
  }
}
```

### 2. Production Deployment:

```bash
# Ручной деплой в production
vercel --prod

# Или через Git integration
git push origin main  # Автоматический деплой
```

### 3. Incremental Static Regeneration (ISR):

```typescript
// Для динамических страниц
export const getStaticProps: GetStaticProps = async ({ params }) => {
  const data = await fetchData(params.id);

  return {
    props: { data },
    revalidate: 60 // Перегенерация каждые 60 секунд
  };
};
```

## 🔧 Serverless Functions

### API Routes (pages/api):

```typescript
// pages/api/users.ts
import type { NextApiRequest, NextApiResponse } from 'next';

export default async function handler(
  req: NextApiRequest,
  res: NextApiResponse
) {
  if (req.method === 'GET') {
    const users = await getUsers();
    res.status(200).json(users);
  } else {
    res.setHeader('Allow', ['GET']);
    res.status(405).end(`Method ${req.method} Not Allowed`);
  }
}
```

### App Router API Routes:

```typescript
// app/api/users/route.ts
import { NextRequest, NextResponse } from 'next/server';

export async function GET(request: NextRequest) {
  const users = await getUsers();
  return NextResponse.json(users);
}

export async function POST(request: NextRequest) {
  const body = await request.json();
  const user = await createUser(body);
  return NextResponse.json(user, { status: 201 });
}
```

## 🌐 Custom Domains и SSL

### Domain Configuration:

```json
{
  "domains": [
    {
      "name": "api.example.com",
      "apex": false
    },
    {
      "name": "www.example.com",
      "redirect": "example.com"
    }
  ]
}
```

### SSL Certificates:

```bash
# Vercel автоматически предоставляет SSL
# Let's Encrypt integration
# Wildcard certificates для subdomains
```

## 🔒 Security и Environment Variables

### Environment Variables:

```bash
# .env.local (локально)
DATABASE_URL=postgresql://...

# Vercel Dashboard или CLI
vercel env add DATABASE_URL

# Разные значения для preview/production
vercel env add DATABASE_URL --environment preview
```

### Security Headers:

```json
{
  "headers": [
    {
      "source": "/(.*)",
      "headers": [
        {
          "key": "X-Frame-Options",
          "value": "DENY"
        },
        {
          "key": "X-Content-Type-Options",
          "value": "nosniff"
        },
        {
          "key": "Referrer-Policy",
          "value": "strict-origin-when-cross-origin"
        }
      ]
    }
  ]
}
```

## 📊 Мониторинг и аналитика

### Vercel Analytics:

```typescript
// app/layout.tsx
import { Analytics } from '@vercel/analytics/react';

export default function RootLayout({ children }) {
  return (
    <html lang="en">
      <body>
        {children}
        <Analytics />
      </body>
    </html>
  );
}
```

### Real User Monitoring:

```typescript
// lib/monitoring.ts
export const logError = (error: Error, context: any) => {
  // Отправка в Vercel logs
  console.error('Application Error:', error, context);
};
```

## 🔄 CI/CD Integration

### GitHub Actions:

```yaml
# .github/workflows/deploy.yml
name: Deploy to Vercel

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Install Vercel CLI
        run: npm i -g vercel
      - name: Pull Vercel Environment
        run: vercel pull --yes --environment=production --token=${{ secrets.VERCEL_TOKEN }}
      - name: Build Project Artifacts
        run: vercel build --prod --token=${{ secrets.VERCEL_TOKEN }}
      - name: Deploy Project Artifacts
        run: vercel deploy --prebuilt --prod --token=${{ secrets.VERCEL_TOKEN }}
```

## 📚 Связанные материалы

- [Architect Protocol](../architect/protocol.md) — Планирование деплоя
- [Backend Executor Protocol](../backend-executor/protocol.md) — Реализация для Vercel
- [Validator Protocol](../validator/protocol.md) — Проверка деплоя
- [Database Protocols](../database/supabase/protocol.md) — Базы данных в Vercel