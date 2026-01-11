# ⚠️ Известные проблемы для Supabase Expert Skill

Этот файл содержит известные проблемы и их решения для работы с Supabase.

---

## 🔥 Критические проблемы

### Проблема: RLS Policy возвращает ошибку

**Симптомы:**
- Запросы к базе данных отклоняются
- Ошибка: `permission denied`
- Пользователь не может получить данные

**Причины:**
1. NEW./OLD. используются в RLS (запрещено)
2. Отсутствие RLS policies для таблицы
3. Неверное condition в USING clause

**Решения:**
```sql
-- ✅ Правильно (использование auth.uid())
CREATE POLICY "Users can view own data" ON users
FOR SELECT
USING (auth.uid() = id)
TO authenticated;

-- ❌ Неправильно (NEW./OLD. запрещены)
CREATE POLICY "Users can view own data" ON users
FOR SELECT
USING (NEW.id = auth.uid())
TO authenticated;
```

**Полезные ссылки:**
- [Supabase RLS Docs](https://supabase.com/docs/guides/auth/row-level-security)
- [Context7: RLS Best Practices](https://www.context7.ai)

---

### Проблема: Edge Function таймаут

**Симптомы:**
- Функция возвращает 504 Gateway Timeout
- Долгий отклик (>30 сек)
- Function не завершается

**Причины:**
1. Превышение лимита 25 сек для Edge Functions
2. Долгая операция с базой данных
3. Внешний API не отвечает

**Решения:**
```typescript
// ✅ Оптимизация запросов
import { createClient } from '@supabase/supabase-js';

const supabase = createClient();

// Использование select вместо * для оптимизации
const { data, error } = await supabase
  .from('users')
  .select('id, name, email')  // только нужные поля
  .limit(100);

// Индексация в базе данных
CREATE INDEX idx_users_email ON users(email);
```

**Полезные ссылки:**
- [Supabase Edge Functions](https://supabase.com/docs/guides/functions)
- [Context7: Function Optimization](https://www.context7.ai)

---

## ⚠️ Общие проблемы

### Проблема: Auth не работает

**Симптомы:**
- Пользователь не может войти
- Auth API возвращает ошибку
- Сессия истекает сразу

**Причины:**
1. Неверная конфигурация Auth
2. Отсутствие email confirmation
3. Проблемы с email provider

**Решения:**
```typescript
// ✅ Правильная настройка Auth
const { data, error } = await supabase.auth.signUp({
  email: 'user@example.com',
  password: 'password123',
  options: {
    emailRedirectTo: 'https://example.com/auth/callback'
  }
});
```

**Полезные ссылки:**
- [Supabase Auth](https://supabase.com/docs/guides/auth)
- [Context7: Auth Best Practices](https://www.context7.ai)

---

### Проблема: Storage RLS не работает

**Симптомы:**
- Пользователь не может загрузить файлы
- Storage возвращает permission denied
- Файл не скачивается

**Причины:**
1. Отсутствие RLS policies для storage
2. Неверная политика (public вместо authenticated)
3. Отсутствие bucket или folder

**Решения:**
```sql
-- ✅ Правильная Storage RLS
CREATE POLICY "Users can upload files" ON storage.objects
FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'user-files'
  AND auth.uid()::text = (storage.foldername(name))[1]
);
```

**Полезные ссылки:**
- [Supabase Storage](https://supabase.com/docs/guides/storage)
- [Context7: Storage Best Practices](https://www.context7.ai)

---

### Проблема: Realtime subscription не работает

**Симптомы:**
- Изменения в базе не приходят
- Subscription не устанавливается
- События пропадают

**Причины:**
1. Отсутствие PGRST replication
2. Неверная подписка (неправильная таблица)
3. Отсутствие RLS для Realtime

**Решения:**
```sql
-- ✅ Включение Realtime
ALTER PUBLICATION supabase_realtime ADD TABLE users;

-- ✅ Установка RLS для Realtime
CREATE POLICY "Users can subscribe" ON users
FOR SELECT
TO authenticated
USING (true);  -- Realtime требует SELECT policy
```

**Полезные ссылки:**
- [Supabase Realtime](https://supabase.com/docs/guides/realtime)
- [Context7: Realtime Best Practices](https://www.context7.ai)

---

## 📚 Дополнительные ресурсы

- [Supabase Documentation](https://supabase.com/docs)
- [Supabase Dashboard](https://supabase.com/dashboard)
- [Context7: Supabase Best Practices](https://www.context7.ai)