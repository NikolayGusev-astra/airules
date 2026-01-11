# ⚠️ Известные проблемы для Netlify Expert Skill

Этот файл содержит известные проблемы и их решения для работы с Netlify.

---

## 🔥 Критические проблемы

### Проблема: Ошибка деплоя "Build failed"

**Симптомы:**
- Веб-интерфейс показывает "Build failed"
- Логи содержат ошибки сборки

**Причины:**
1. Неверная конфигурация netlify.toml
2. Отсутствующие переменные окружения
3. Проблемы с зависимостями
4. Неверная команда сборки

**Решения:**
```bash
# 1. Проверить логи деплоя
netlify status
netlify logs

# 2. Локально протестировать сборку
npm run build

# 3. Проверить netlify.toml
cat netlify.toml

# 4. Проверить переменные окружения
netlify env:list
```

**Полезные ссылки:**
- [Netlify Build Logs](https://docs.netlify.com/site-deploys/overview)
- [Context7: Netlify Deployment](https://www.context7.ai)

---

### Проблема: Netlify Functions не работают

**Симптомы:**
- API возвращает 500 ошибку
- Function не деплоится
- Таймаут выполнения

**Причины:**
1. Неверный экспорт функции
2. Отсутствие handler
3. Превышение размера функции (50MB лимит)
4. Неверная конфигурация runtime

**Решения:**
```typescript
// ✅ Правильно
export default async (event, context) => {
  return {
    statusCode: 200,
    body: JSON.stringify({ message: 'Hello' })
  };
}

// ❌ Неправильно (нет default export)
export async function handler(event, context) {
  return {
    statusCode: 200,
    body: JSON.stringify({ message: 'Hello' })
  };
}
```

**Полезные ссылки:**
- [Netlify Functions](https://docs.netlify.com/functions)
- [Context7: Functions Best Practices](https://www.context7.ai)

---

## ⚠️ Общие проблемы

### Проблема: Переменные окружения не доступны

**Симптомы:**
- Код выдает `undefined` для переменных окружения
- Локально работает, но на Netlify — нет

**Причины:**
1. Переменная не добавлена в Netlify Dashboard
2. Неверное имя переменной
3. Переменная не обновлена после деплоя

**Решения:**
```bash
# 1. Добавить переменную
netlify env:set MY_VAR=value

# 2. Проверить доступность
netlify env:list

# 3. Обновить функции
netlify functions:deploy
```

**Полезные ссылки:**
- [Netlify Environment Variables](https://docs.netlify.com/environment-variables/overview)

---

### Проблема: Redirects не работают

**Симптомы:**
- Ссылки не перенаправляются
- 404 на старых URL

**Причины:**
1. Неверный формат в _redirects файле
2. Отсутствие _redirects файла
3. Конфликт с netlify.toml

**Решения:**
```toml
# netlify.toml
[[redirects]]
  from = "/old-path"
  to = "/new-path"
  status = 301
  force = true
```

**Или через файл:**
```
# _redirects
/old-path /new-path 301!
```

**Полезные ссылки:**
- [Netlify Redirects](https://docs.netlify.com/routing/redirects)
- [Context7: URL Routing](https://www.context7.ai)

---

### Проблема: Headers не применяются

**Симптомы:**
- CORS ошибки
- Cache-Control не работает
- Security headers отсутствуют

**Причины:**
1. Неверная конфигурация в netlify.toml
2. Конфликт с _headers файлом

**Решения:**
```toml
# netlify.toml
[[headers]]
  for = "/*"
  [headers.values]
    Access-Control-Allow-Origin = "*"
    Cache-Control = "public, max-age=3600"
    X-Frame-Options = "DENY"
```

**Полезные ссылки:**
- [Netlify Headers](https://docs.netlify.com/routing/headers)
- [Context7: HTTP Headers](https://www.context7.ai)

---

## 📚 Дополнительные ресурсы

- [Netlify Documentation](https://docs.netlify.com)
- [Netlify CLI](https://docs.netlify.com/cli/get-started)
- [Context7: Netlify Best Practices](https://www.context7.ai)