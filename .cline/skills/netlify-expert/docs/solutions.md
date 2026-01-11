# 💡 Решения для Netlify Expert Skill

## 🚀 Базовая конфигурация

```toml
[build]
  command = "npm run build"
  publish = "dist"

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

## 🔐 Environment Variables

```bash
netlify env:set VAR_NAME value
netlify env:import .env.production
```

## ⚙️ Netlify Functions

```javascript
// netlify/functions/hello.js
exports.handler = async (event, context) => {
  return {
    statusCode: 200,
    body: JSON.stringify({ message: 'Hello!' })
  };
};
```

## 📊 CI/CD Integration

```yaml
name: Deploy to Netlify
on: [push]
jobs:
  deploy:
    steps:
      - uses: actions/checkout@v3
      - uses: nwtgck/actions-netlify@v2.0
        with:
          publish-dir: './dist'
          production-branch: main
          github-token: ${{ secrets.GITHUB_TOKEN }}
          deploy-message: "Deploy from GitHub Actions"