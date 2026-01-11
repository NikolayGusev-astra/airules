# 🚀 Продвинутые паттерны для Vercel Expert Skill

Этот файл содержит продвинутые техники деплоя и оптимизации на Vercel.

---

## ⚡ Оптимизация Image CDN

### Техника: Next.js Image Optimization

**Когда использовать:**
- Сайты с большим количеством изображений
- Улучшение производительности
- Снижение стоимости

```javascript
// next.config.js
module.exports = {
  images: {
    domains: ['example.com'],
    formats: ['image/avif', 'image/webp'],
    deviceSizes: [640, 750, 828, 1080, 1200],
    imageSizes: [16, 32, 48, 64, 96, 128, 256],
    minimumCacheTTL: 60,
    dangerouslyAllowSVG: true,
  },
  // Использование Vercel Image Optimization
  async rewrites() {
    return [
      {
        source: '/:path*',
        destination: '/:path*',
      },
    ];
  },
};

// Использование в компоненте
import Image from 'next/image';

export default function ProductImage({ src, alt }) {
  return (
    <Image
      src={src}
      alt={alt}
      width={800}
      height={600}
      priority
      placeholder="blur"
    />
  );
}
```

**Полезные ссылки:**
- [Vercel Image Optimization](https://vercel.com/docs/concepts/functions/edge-functions/og-image-generation)
- [Context7: Image Optimization](https://www.context7.ai)

---

## 🌍 Геолокация и регионы

### Техника: Deployment regions

**Когда использовать:**
- Глобальный проект
- Низкая латентность
- Compliance требования

```json
{
  "regions": ["iad1", "hnd1", "sfo1"],
  "functions": {
    "api/**/*.ts": {
      "runtime": "@vercel/node",
      "memory": 1024,
      "maxDuration": 10
    }
  }
}
```

**Доступные регионы:**
- `iad1` — Washington, D.C. (США Восток)
- `sfo1` — San Francisco (США Запад)
- `hnd1` — Tokyo (Азия)
- `arn1` — Paris (Европа)

**Полезные ссылки:**
- [Vercel Regions](https://vercel.com/docs/concepts/edge-network/regions)
- [Context7: Global Deployment](https://www.context7.ai)

---

## 🔒 Rate Limiting

### Техника: Защита от DDoS

**Когда использовать:**
- API endpoints
- Public формы
- Защита от abuse

```javascript
// api/rate-limiter.ts
import { Ratelimit } from '@upstash/ratelimit';
import { Redis } from '@upstash/redis';

const ratelimit = new Ratelimit({
  redis: Redis.fromEnv(),
  limiter: Ratelimit.slidingWindow(10, '10 s'),
});

export default async function handler(req, res) {
  const ip = req.headers['x-forwarded-for'] || 'unknown';
  const { success } = await ratelimit.limit(ip);
  
  if (!success) {
    return res.status(429).json({ 
      error: 'Too many requests' 
    });
  }
  
  // Продолжить обработку
  return res.status(200).json({ message: 'OK' });
}
```

**Полезные ссылки:**
- [Vercel Rate Limiting](https://vercel.com/docs/concepts/functions/serverless-functions/edge-functions/rate-limiting)
- [Context7: DDoS Protection](https://www.context7.ai)

---

## 📊 Advanced Analytics

### Техника: Custom Web Vitals

**Когда использовать:**
- Мониторинг производительности
- SEO оптимизация
- UX улучшение

```javascript
// app/layout.tsx
import { WebVitals } from '@vercel/analytics/react';

export default function RootLayout({ children }) {
  return (
    <html>
      <head>
        <WebVitals
          onCLS={(metric) => console.log('CLS:', metric.value)}
          onFID={(metric) => console.log('FID:', metric.value)}
          onFCP={(metric) => console.log('FCP:', metric.value)}
          onLCP={(metric) => console.log('LCP:', metric.value)}
          onTTFB={(metric) => console.log('TTFB:', metric.value)}
        />
      </head>
      <body>{children}</body>
    </html>
  );
}

// Custom Analytics Events
import { track } from '@vercel/analytics/react';

export function trackEvent(name, properties) {
  track(name, {
    ...properties,
    timestamp: Date.now(),
  });
}

// Использование
trackEvent('Button Click', {
  button: 'Sign Up',
  location: 'homepage',
  variant: 'variant-A',
});
```

**Полезные ссылки:**
- [Web Vitals](https://vercel.com/docs/analytics/web-vitals)
- [Context7: Performance Monitoring](https://www.context7.ai)

---

## 🔄 Staged Deployment

### Техника: Preview Deployments

**Когда использовать:**
- Pull Request деплой
- A/B тестирование
- Code review в проде

```yaml
# .github/workflows/staging.yml
name: Deploy Preview

on:
  pull_request:
    types: [opened, synchronize, reopened]

jobs:
  deploy-preview:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Deploy to Vercel (Preview)
        uses: amondnet/vercel-action@v25
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.ORG_ID }}
          vercel-project-id: ${{ secrets.PROJECT_ID }}
          working-directory: ./
          alias-domains: pr-${{ github.event.number }}.your-app.vercel.app
      
      - name: Comment PR with URL
        uses: actions/github-script@v6
        with:
          script: |
            github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: '✅ Preview deployed: https://pr-${{ context.issue.number }}.your-app.vercel.app'
            })
```

**Полезные ссылки:**
- [Vercel Previews](https://vercel.com/docs/deployments/overview#preview-deployments)
- [Context7: Staged Deployment](https://www.context7.ai)

---

## 🧪 Edge Middleware

### Техника: Middleware для аутентификации

**Когда использовать:**
- Защита routes
- Локализация
- A/B тестирование

```javascript
// middleware.ts
import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';

export function middleware(req: NextRequest) {
  // Проверить аутентификацию
  const token = req.cookies.get('auth-token');
  
  if (!token && !req.nextUrl.pathname.startsWith('/login')) {
    return NextResponse.redirect(new URL('/login', req.url));
  }
  
  // Локализация
  const acceptLanguage = req.headers.get('accept-language') || 'en';
  const locale = acceptLanguage.split(',')[0];
  
  if (locale === 'ru') {
    const url = req.nextUrl.clone();
    url.pathname = `/ru${url.pathname}`;
    return NextResponse.redirect(url);
  }
  
  return NextResponse.next();
}

export const config = {
  matcher: ['/((?!api|_next/static|_next/image|favicon.ico).*)'],
};
```

**Полезные ссылки:**
- [Next.js Middleware](https://nextjs.org/docs/advanced-features/middleware)
- [Context7: Middleware Patterns](https://www.context7.ai)

---

## 📦 Advanced Build Optimization

### Техника: Tree Shaking и Code Splitting

**Когда использовать:**
- Большой bundle size
- Медленный Time to Interactive
- Оптимизация загрузки

```javascript
// next.config.js
module.exports = {
  experimental: {
    optimizeCss: true,
    optimizePackageImports: ['lucide-react', 'date-fns'],
  },
  // Динамические imports для code splitting
  webpack: (config, { isServer }) => {
    if (!isServer) {
      config.resolve.alias = {
        ...config.resolve.alias,
        // Динамический import для тяжелых библиотек
      };
    }
    return config;
  },
};

// Динамический импорт в компоненте
import dynamic from 'next/dynamic';

const HeavyComponent = dynamic(
  () => import('./HeavyComponent'),
  { 
    loading: () => <p>Loading...</p>,
    ssr: false 
  }
);

export default function Page() {
  return <HeavyComponent />;
}
```

**Полезные ссылки:**
- [Next.js Optimization](https://nextjs.org/docs/app/building-your-application/optimizing)
- [Context7: Bundle Optimization](https://www.context7.ai)

---

## 🔐 Advanced Security

### Техника: CSRF Protection

**Когда использовать:**
- Forms с POST запросами
- API endpoints
- Защита от CSRF attacks

```javascript
// lib/csrf.ts
import { createHash } from 'crypto';

export function generateCSRFToken() {
  return createHash('sha256')
    .update(Date.now().toString() + Math.random())
    .digest('hex');
}

export function validateCSRFToken(token: string, sessionToken: string) {
  return token === sessionToken;
}

// api/protected-route.ts
import { validateCSRFToken } from '@/lib/csrf';

export default async function handler(req, res) {
  const csrfToken = req.headers['x-csrf-token'];
  const sessionToken = req.session.csrfToken;
  
  if (!validateCSRFToken(csrfToken, sessionToken)) {
    return res.status(403).json({ error: 'Invalid CSRF token' });
  }
  
  // Продолжить обработку
  return res.status(200).json({ message: 'Success' });
}
```

**Полезные ссылки:**
- [Vercel Security](https://vercel.com/docs/concepts/security/overview)
- [Context7: Security Best Practices](https://www.context7.ai)