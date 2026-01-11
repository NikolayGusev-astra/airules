# 💡 Решения для Vercel Expert Skill

Этот файл содержит конкретные решения для типичных задач деплоя на Vercel.

---

## 🚀 Базовая конфигурация проекта

### Решение: vercel.json для Next.js

**Проблема:** Нужно настроить деплой Next.js проекта

```json
{
  "buildCommand": "npm run build",
  "outputDirectory": ".next",
  "devCommand": "npm run dev",
  "installCommand": "npm install",
  "framework": "nextjs",
  "regions": ["iad1"],
  "headers": [
    {
      "source": "/api/(.*)",
      "headers": [
        {
          "key": "Access-Control-Allow-Origin",
          "value": "*"
        }
      ]
    }
  ]
}
```

**Полезные ссылки:**
- [Vercel Configuration](https://vercel.com/docs/projects/configuration)
- [Next.js on Vercel](https://vercel.com/docs/frameworks/nextjs)

---

## 🔐 Environment Variables

### Решение: Управление секретами

**Проблема:** Нужно безопасно хранить переменные окружения

```bash
# Через CLI
vercel env add DATABASE_URL
vercel env add JWT_SECRET
vercel env add STRIPE_SECRET_KEY

# Через .env.local (локально)
DATABASE_URL=postgresql://...
JWT_SECRET=your-secret-here
STRIPE_SECRET_KEY=sk_test_...

# Vercel Dashboard
# Settings > Environment Variables
```

**Важные переменные для AIRules:**
- `DATABASE_URL` — строка подключения к базе
- `JWT_SECRET` — секрет для JWT токенов
- `NEXT_PUBLIC_API_URL` — публичный URL API
- `STRIPE_SECRET_KEY` — секретный ключ Stripe

**Полезные ссылки:**
- [Vercel Environment Variables](https://vercel.com/docs/projects/environment-variables)
- [Context7: Best Practices](https://www.context7.ai)

---

## ⚙️ Конфигурация для API Routes

### Решение: Serverless Functions

**Проблема:** Нужно настроить API endpoints

```javascript
// api/hello.js (Node.js runtime)
export default function handler(req, res) {
  res.status(200).json({ message: 'Hello!' });
}

// api/users.ts (TypeScript runtime)
import type { VercelRequest, VercelResponse } from '@vercel/node';

export default async function handler(
  req: VercelRequest,
  res: VercelResponse
) {
  const { method } = req;
  
  if (method === 'GET') {
    const users = await getUsers();
    res.status(200).json(users);
  } else {
    res.status(405).json({ error: 'Method not allowed' });
  }
}

// Конфигурация в vercel.json
{
  "functions": {
    "api/**/*.ts": {
      "runtime": "@vercel/node"
    }
  }
}
```

**Полезные ссылки:**
- [Vercel Functions](https://vercel.com/docs/functions/serverless-functions)
- [Context7: Serverless Patterns](https://www.context7.ai)

---

## 📊 Мониторинг и аналитика

### Решение: Vercel Analytics

**Проблема:** Нужно отслеживать производительность

```javascript
// lib/analytics.js
import { Analytics } from '@vercel/analytics/react';

export function App() {
  return (
    <Analytics
      beforeSend={(event) => {
        // Фильтровать события
        if (event.url.includes('/api/')) {
          return null; // Не логировать API запросы
        }
        return event;
      }}
    >
      {/* Your app */}
    </Analytics>
  );
}

// Custom Events
import { track } from '@vercel/analytics/react';

function handleSignup() {
  track('User Signup', {
    plan: 'premium',
    source: 'referral'
  });
}
```

**Полезные ссылки:**
- [Vercel Analytics](https://vercel.com/docs/analytics)
- [Context7: Monitoring](https://www.context7.ai)

---

## 🔄 CI/CD Integration

### Решение: GitHub Actions для деплоя

**Проблема:** Автоматический деплой при пуше в main

```yaml
# .github/workflows/deploy.yml
name: Deploy to Vercel

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Run tests
        run: npm test
      
      - name: Deploy to Vercel (Production)
        if: github.ref == 'refs/heads/main'
        uses: amondnet/vercel-action@v25
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.ORG_ID }}
          vercel-project-id: ${{ secrets.PROJECT_ID }}
          vercel-args: '--prod'
      
      - name: Deploy to Vercel (Preview)
        if: github.ref != 'refs/heads/main'
        uses: amondnet/vercel-action@v25
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.ORG_ID }}
          vercel-project-id: ${{ secrets.PROJECT_ID }}
```

**Полезные ссылки:**
- [Vercel GitHub Integration](https://vercel.com/docs/deployments/overview)
- [Context7: CI/CD Patterns](https://www.context7.ai)

---

## 🌍 Custom Domains

### Решение: Настройка кастомного домена

**Проблема:** Нужно подключить свой домен к Vercel

```bash
# Через CLI
vercel domains add mydomain.com

# Через Dashboard
# Settings > Domains > Add Domain

# Сконфигурировать DNS
# A Record: @ → 76.76.21.21
# CNAME: www → cname.vercel-dns.com
```

**Конфигурация для Next.js:**
```javascript
// next.config.js
module.exports = {
  async headers() {
    return [
      {
        source: '/(.*)',
        headers: [
          {
            key: 'X-DNS-Prefetch-Control',
            value: 'on'
          }
        ]
      }
    ];
  }
};
```

**Полезные ссылки:**
- [Vercel Domains](https://vercel.com/docs/projects/custom-domains)
- [Context7: DNS Configuration](https://www.context7.ai)

---

## 🧪 Edge Functions

### Решение: Edge Runtime для производительности

**Проблема:** Нужно быстрее обрабатывать запросы

```javascript
// api/edge-function.ts
export const config = {
  runtime: 'edge',
};

export default async function handler(req) {
  const url = new URL(req.url);
  const userAgent = req.headers.get('user-agent');
  
  // Логика на edge
  if (userAgent.includes('bot')) {
    return new Response('Bot detected', {
      status: 403
    });
  }
  
  return new Response('OK');
}

// Конфигурация в vercel.json
{
  "functions": {
    "api/edge-function.ts": {
      "runtime": "edge"
    }
  }
}
```

**Преимущества Edge Runtime:**
- Латентность < 100ms
- Глобальное распределение
- HTTP/2 по умолчанию

**Полезные ссылки:**
- [Vercel Edge Functions](https://vercel.com/docs/functions/edge-functions)
- [Context7: Edge Computing](https://www.context7.ai)

---

## 📦 Управление зависимостями

### Решение: Оптимизация bundle size

**Проблема:** Долгое время сборки

```json
{
  "buildCommand": "npm run build",
  "functions": {
    "app/api/**/*.ts": {
      "maxDuration": 10
    }
  },
  "installCommand": "npm install --prefer-offline",
  "ignoreCommand": "node scripts/prune-dependencies.js"
}
```

**Полезные ссылки:**
- [Vercel Build Optimization](https://vercel.com/docs/build-optimization)
- [Context7: Bundle Analysis](https://www.context7.ai)