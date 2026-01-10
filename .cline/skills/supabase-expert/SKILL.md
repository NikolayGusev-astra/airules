---
name: supabase-expert
description: Эксперт по Supabase. Настройка базы данных, аутентификации, хранилища и Edge Functions.
---

# 🗄️ Supabase Expert Skill

## Зачем нужен этот Skill?

Supabase Expert — специализированная роль для работы с платформой Supabase. Обеспечивает правильную настройку базы данных, аутентификации, хранилища и Edge Functions.

**Ключевые особенности:**
- ✅ Настройка PostgreSQL базы данных
- ✅ Конфигурация аутентификации (Auth)
- ✅ Управление хранилищем файлов (Storage)
- ✅ Разработка Edge Functions
- ✅ Настройка Row Level Security (RLS)
- ✅ Realtime subscriptions

## Основные принципы

### 1. Supabase Architecture

```
Next.js / React приложение
    ↓
Supabase Expert (конфигурация)
    ↓
    ├─ Database (PostgreSQL)
    ├─ Auth (Auth providers)
    ├─ Storage (Files)
    ├─ Edge Functions
    └─ Realtime
    ↓
Supabase Dashboard / CLI
    ↓
    ├─ SQL Editor
    ├─ Table Editor
    ├─ API Management
    └─ Logs
```

### 2. RLS (Row Level Security)

**RLS политики — критически важны!**
- ✅ ВСЕ таблицы должны иметь RLS
- ✅ Использовать SECURITY DEFINER функции
- ❌ НЕ ИСПОЛЬЗОВАТЬ NEW./OLD. в RLS
- ✅ Уникальные ограничения через UNIQUE constraints

## Обязанности

### 1. Настройка базы данных

**Создание таблиц:**
```sql
-- Правильный подход
CREATE TABLE transactions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  amount NUMERIC(15,2) NOT NULL,  -- Для денег!
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- RLS политика
ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own transactions"
ON transactions
FOR SELECT
USING (auth.uid() = user_id);
```

**RLS без NEW./OLD.:**
```sql
-- ❌ ПЛОХО - Использовать NEW./OLD.
CREATE POLICY "..." ON transactions
FOR INSERT
WITH CHECK (NEW.amount > 0);

-- ✅ ХОРОШО - Использовать SECURITY DEFINER
CREATE OR REPLACE FUNCTION validate_transaction()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.amount <= 0 THEN
    RAISE EXCEPTION 'Amount must be positive';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
```

### 2. Аутентификация (Auth)

**Supabase Auth providers:**
- Email/Password
- Phone
- OAuth (Google, GitHub, GitLab, Bitbucket)
- SAML
- Magic Links

**Клиентская инициализация:**
```typescript
// lib/supabase.ts
import { createClient } from '@supabase/supabase-js';

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!;
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!;

export const supabase = createClient(supabaseUrl, supabaseAnonKey);
```

**Auth функции:**
```typescript
// Регистрация
const { data, error } = await supabase.auth.signUp({
  email: 'user@example.com',
  password: 'password123',
});

// Вход
const { data, error } = await supabase.auth.signInWithPassword({
  email: 'user@example.com',
  password: 'password123',
});

// Выход
await supabase.auth.signOut();
```

### 3. Хранилище (Storage)

**Создание bucket:**
```sql
-- SQL Editor
INSERT INTO storage.buckets (id, name, public)
VALUES ('documents', 'documents', true);
```

**RLS для storage:**
```sql
-- Политики для bucket
CREATE POLICY "Public read access"
ON storage.objects
FOR SELECT
USING (bucket_id = 'documents' AND public = true);

CREATE POLICY "Authenticated write access"
ON storage.objects
FOR INSERT
WITH CHECK (
  bucket_id = 'documents' 
  AND auth.role() = 'authenticated'
  AND auth.uid()::text = (storage.foldername(name))[1]
);
```

**Upload файла:**
```typescript
const { data, error } = await supabase.storage
  .from('documents')
  .upload('folder/file.pdf', file, {
    cacheControl: '3600',
    upsert: false,
  });
```

### 4. Edge Functions

**Создание функции:**
```typescript
// supabase/functions/hello/index.ts
import { serve } from 'https://deno.land/std@0.168.0/http/server.ts';

serve(async (req) => {
  const data = await req.json();
  
  return new Response(
    JSON.stringify({ message: `Hello ${data.name}!` }),
    { headers: { 'Content-Type': 'application/json' } }
  );
});
```

**Вызов функции:**
```typescript
const { data, error } = await supabase.functions.invoke('hello', {
  name: 'World',
});
```

### 5. Realtime

**Подписка на изменения:**
```typescript
const channel = supabase
  .channel('public:transactions')
  .on(
    'postgres_changes',
    {
      event: 'INSERT',
      schema: 'public',
      table: 'transactions',
    },
    (payload) => console.log('Change received!', payload)
  )
  .subscribe();
```

## Технологический стек

### ✅ Поддерживаемые технологии:
- **База данных:** PostgreSQL 15
- **ORM:** Prisma, Drizzle ORM, TypeORM, Kysely
- **Frontend:** React, Vue, Svelte, Next.js, Nuxt
- **Аутентификация:** Supabase Auth, NextAuth, Clerk
- **Хранение:** Supabase Storage, S3, R2
- **Realtime:** Supabase Realtime, Ably, Pusher

### ❌ Ограничения:
- ❌ Float/Double для денег (используйте NUMERIC(15,2))
- ❌ NEW./OLD. в RLS политиках
- ❌ Отсутствие RLS на таблицах
- ❌ Прямые SQL команды без миграций

## Практические примеры

### Пример 1: Настройка проекта с Supabase

**1. Установка Supabase CLI:**
```bash
npm i -g supabase
supabase login
```

**2. Инициализация проекта:**
```bash
supabase init
```

**3. Локальное запускаение:**
```bash
supabase start
```

### Пример 2: Миграции

**Создание миграции:**
```bash
supabase migration new add_transactions_table
```

**SQL миграции:**
```sql
-- supabase/migrations/20240101000000_add_transactions_table.sql
CREATE TABLE transactions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  amount NUMERIC(15,2) NOT NULL,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- RLS
ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;
```

**Применение миграции:**
```bash
supabase db push
```

### Пример 3: TypeScript с Prisma

**Схема Prisma:**
```prisma
// schema.prisma
datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

generator client {
  provider = "prisma-client-js"
}

model Transaction {
  id        String   @id @default(uuid())
  amount    Decimal  @db.Decimal(15, 2)
  userId    String
  createdAt DateTime @default(now())
}
```

**Клиент:**
```typescript
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

const transactions = await prisma.transaction.findMany({
  where: { userId: user.id },
});
```

### Пример 4: Auth с Next.js

**Server Actions:**
```typescript
// app/actions/auth.ts
'use server';

import { supabase } from '@/lib/supabase';
import { revalidatePath } from 'next/cache';

export async function signIn(formData: FormData) {
  const email = formData.get('email') as string;
  const password = formData.get('password') as string;

  const { error } = await supabase.auth.signInWithPassword({
    email,
    password,
  });

  if (error) {
    return { error: error.message };
  }

  revalidatePath('/', 'layout');
  return { success: true };
}
```

### Пример 5: Storage upload

**Upload с progress:**
```typescript
const { data, error } = await supabase.storage
  .from('avatars')
  .upload(`${userId}/${file.name}`, file, {
    cacheControl: '3600',
    upsert: false,
    onUploadProgress: (progress) => {
      console.log('Upload progress:', progress);
    },
  });

if (error) {
  console.error('Upload failed:', error);
  return;
}

// Получение публичного URL
const { data: publicUrl } = supabase.storage
  .from('avatars')
  .getPublicUrl(data.path);
```

## Best Practices

### 1. RLS (Row Level Security)

✅ **ДЕЛАЙ:**
- Включайте RLS на ВСЕ таблицы
- Используйте SECURITY DEFINER функции
- Проверяйте auth.uid() в политиках
- Используйте UNIQUE constraints вместо NEW./OLD.

❌ **НЕ ДЕЛАЙ:**
- Отключайте RLS
- Используйте NEW./OLD. в политиках
- Игнорируйте проверки auth.uid()
- Позволяйте доступ без аутентификации

### 2. Типы данных

✅ **ДЕЛАЙ:**
- NUMERIC(15,2) для финансовых данных
- DECIMAL в TypeScript/Prisma
- UUID для первичных ключей
- TIMESTAMPTZ для времени

❌ **НЕ ДЕЛАЙ:**
- Float/Double для денег
- Integer для больших чисел
- String для числовых данных

### 3. Аутентификация

✅ **ДЕЛАЙ:**
- Используйте Supabase Auth
- Настраивайте RLS на основе auth.uid()
- Проверяйте session на сервере
- Используйте JWT для API

❌ **НЕ ДЕЛАЙ:**
- Храните пароли в открытом виде
- Передавайте credentials в query params
- Игнорируйте session expiration

### 4. Edge Functions

✅ **ДЕЛАЙ:**
- Используйте Deno runtime
- Кэшируйте ответы
- Обрабатывайте ошибки
- Валидируйте входные данные

❌ **НЕ ДЕЛАЙ:**
- Используйте long-running процессы (>10s)
- Храните секреты в коде
- Игнорируйте rate limiting

## Мониторинг и логирование

### Supabase Logs

**Просмотр логов:**
```bash
# Dashboard
Logs > Select type (database, api, functions)
```

**Фильтрация:**
- По таблице
- По пользователю
- По timeframe

### Database Insights

**Метрики:**
- Query performance
- Table size
- Connection pool
- Storage usage

## Интеграция с MCP

### Context7 Researcher

Используйте Context7 для:
- Проверки актуальной документации Supabase
- Поиска примеров RLS политик
- Верификации API изменений

**Пример запроса:**
```bash
# Проверить актуальные фичи Supabase
"How to configure RLS policies with Supabase 2024? use context7"
```

### Memory Graph Expert

Используйте Memory Graph для:
- Хранения схемы базы данных
- Создания связей между таблицами
- Документирования RLS политик
- Трассировки зависимостей

**Пример создания сущности:**
```javascript
await use_mcp_tool("create_entities", {
  entities: [{
    name: "Table_transactions",
    entityType: "supabase_table",
    observations: [
      "Has RLS enabled",
      "Uses NUMERIC(15,2) for amount",
      "Foreign key to auth.users"
    ]
  }]
});
```

## Критерии завершения

Supabase Expert завершает работу когда:
- [x] База данных настроена
- [x] RLS политики созданы (без NEW./OLD.)
- [x] Auth настроен
- [x] Storage bucket создан
- [x] Edge Functions созданы (если нужно)
- [x] Типы данных проверены (NUMERIC vs Float)
- [x] Environment variables настроены
- [x] Проект подключен к Supabase

---

**Supabase Expert обеспечивает качественную работу с платформой Supabase.**
