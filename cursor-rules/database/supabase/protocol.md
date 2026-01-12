# 🗄️ Supabase Database Protocol for Cursor

## 📖 Описание

Протокол для работы с Supabase в Cursor AI. Специализирован на PostgreSQL, RLS политиках, аутентификации и serverless функциях.

## 🎯 Сферы применения

- Настройка PostgreSQL базы данных
- Row Level Security (RLS) политики
- Authentication и authorization
- Storage для файлов
- Edge Functions
- Real-time subscriptions

## 🔄 Рабочий процесс

### ФАЗА: Database Architect

Действуй как Supabase Database Engineer.

#### Задачи:
1. Проектирование схемы базы данных
2. Настройка RLS политик
3. Реализация аутентификации
4. Настройка Storage
5. Создание Edge Functions
6. Оптимизация запросов

#### Ограничения (STRICT):
- ✅ Используй только PostgreSQL возможности Supabase
- ✅ Соблюдай RLS принципы безопасности
- ✅ Оптимизируй для serverless архитектуры

## 🗃️ Схема базы данных

### SQL-first подход:

```sql
-- Таблица пользователей (расширяет auth.users)
CREATE TABLE public.profiles (
  id UUID REFERENCES auth.users(id) PRIMARY KEY,
  username TEXT UNIQUE,
  full_name TEXT,
  avatar_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Таблица проектов
CREATE TABLE public.projects (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  owner_id UUID REFERENCES public.profiles(id),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Таблица задач
CREATE TABLE public.tasks (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  project_id UUID REFERENCES public.projects(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT,
  status TEXT DEFAULT 'todo' CHECK (status IN ('todo', 'in_progress', 'done')),
  assignee_id UUID REFERENCES public.profiles(id),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### TypeScript типы (генерируются автоматически):

```typescript
// types/supabase.ts (сгенерировано)
export interface Database {
  public: {
    Tables: {
      profiles: {
        Row: {
          id: string
          username: string | null
          full_name: string | null
          avatar_url: string | null
          created_at: string
          updated_at: string
        }
        Insert: {
          id: string
          username?: string | null
          // ...
        }
        Update: {
          id?: string
          username?: string | null
          // ...
        }
      }
      // ... другие таблицы
    }
  }
}
```

## 🔒 Row Level Security (RLS)

### Включение RLS:

```sql
-- Включить RLS для всех таблиц
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.tasks ENABLE ROW LEVEL SECURITY;
```

### Политики безопасности:

```sql
-- Profiles: пользователи видят только свой профиль
CREATE POLICY "Users can view own profile" ON public.profiles
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON public.profiles
  FOR UPDATE USING (auth.uid() = id);

-- Projects: владелец видит свои проекты
CREATE POLICY "Users can view own projects" ON public.projects
  FOR SELECT USING (auth.uid() = owner_id);

CREATE POLICY "Users can create projects" ON public.projects
  FOR INSERT WITH CHECK (auth.uid() = owner_id);

-- Tasks: участники проекта видят задачи
CREATE POLICY "Project members can view tasks" ON public.tasks
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM public.projects
      WHERE id = project_id AND owner_id = auth.uid()
    )
  );
```

## 🔐 Аутентификация

### Auth Helpers:

```typescript
// utils/auth.ts
import { createClient } from '@supabase/supabase-js'

const supabase = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL!,
  process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
)

export const signUp = async (email: string, password: string) => {
  const { data, error } = await supabase.auth.signUp({
    email,
    password,
  })
  return { data, error }
}

export const signIn = async (email: string, password: string) => {
  const { data, error } = await supabase.auth.signInWithPassword({
    email,
    password,
  })
  return { data, error }
}

export const signOut = async () => {
  const { error } = await supabase.auth.signOut()
  return { error }
}
```

### Защищенные роуты:

```typescript
// components/AuthGuard.tsx
import { useEffect } from 'react'
import { useRouter } from 'next/router'
import { useSupabaseClient, useUser } from '@supabase/auth-helpers-react'

export const AuthGuard = ({ children }) => {
  const user = useUser()
  const router = useRouter()

  useEffect(() => {
    if (!user) {
      router.push('/login')
    }
  }, [user, router])

  if (!user) {
    return <div>Loading...</div>
  }

  return children
}
```

## 📁 Storage для файлов

### Настройка Storage:

```typescript
// utils/storage.ts
import { createClient } from '@supabase/supabase-js'

const supabase = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL!,
  process.env.SUPABASE_SERVICE_ROLE_KEY!
)

export const uploadFile = async (bucket: string, path: string, file: File) => {
  const { data, error } = await supabase.storage
    .from(bucket)
    .upload(path, file)

  return { data, error }
}

export const downloadFile = async (bucket: string, path: string) => {
  const { data, error } = await supabase.storage
    .from(bucket)
    .download(path)

  return { data, error }
}

export const getPublicUrl = (bucket: string, path: string) => {
  const { data } = supabase.storage
    .from(bucket)
    .getPublicUrl(path)

  return data.publicUrl
}
```

### Storage политики:

```sql
-- Bucket policies
CREATE POLICY "Users can upload their own files" ON storage.objects
  FOR INSERT WITH CHECK (
    bucket_id = 'avatars' AND
    auth.uid()::text = (storage.foldername(name))[1]
  );

CREATE POLICY "Users can view their own files" ON storage.objects
  FOR SELECT USING (
    bucket_id = 'avatars' AND
    auth.uid()::text = (storage.foldername(name))[1]
  );
```

## ⚡ Edge Functions

### Создание Edge Function:

```typescript
// supabase/functions/hello-world/index.ts
import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'

serve(async (req) => {
  const { name } = await req.json()

  const data = {
    message: `Hello ${name}!`,
    timestamp: new Date().toISOString(),
  }

  return new Response(
    JSON.stringify(data),
    { headers: { 'Content-Type': 'application/json' } },
  )
})
```

### Вызов Edge Function:

```typescript
// utils/edge-functions.ts
import { createClient } from '@supabase/supabase-js'

const supabase = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL!,
  process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
)

export const callHelloWorld = async (name: string) => {
  const { data, error } = await supabase.functions.invoke('hello-world', {
    body: { name }
  })

  return { data, error }
}
```

## 📊 Real-time subscriptions

### Live queries:

```typescript
// hooks/useTasks.ts
import { useEffect, useState } from 'react'
import { supabase } from '../utils/supabase'
import { Task } from '../types'

export const useTasks = (projectId: string) => {
  const [tasks, setTasks] = useState<Task[]>([])

  useEffect(() => {
    // Initial fetch
    const fetchTasks = async () => {
      const { data } = await supabase
        .from('tasks')
        .select('*')
        .eq('project_id', projectId)

      setTasks(data || [])
    }

    fetchTasks()

    // Real-time subscription
    const subscription = supabase
      .channel('tasks')
      .on('postgres_changes', {
        event: '*',
        schema: 'public',
        table: 'tasks',
        filter: `project_id=eq.${projectId}`
      }, (payload) => {
        if (payload.eventType === 'INSERT') {
          setTasks(prev => [...prev, payload.new as Task])
        }
        // Handle UPDATE, DELETE similarly
      })
      .subscribe()

    return () => {
      subscription.unsubscribe()
    }
  }, [projectId])

  return tasks
}
```

## 🔧 Оптимизация производительности

### Database индексы:

```sql
-- Индексы для часто используемых запросов
CREATE INDEX idx_tasks_project_id ON public.tasks(project_id);
CREATE INDEX idx_tasks_assignee_id ON public.tasks(assignee_id);
CREATE INDEX idx_projects_owner_id ON public.projects(owner_id);

-- Composite indexes для сложных запросов
CREATE INDEX idx_tasks_status_assignee ON public.tasks(status, assignee_id);
```

### Query optimization:

```typescript
// Оптимизированные запросы
export const getProjectWithTasks = async (projectId: string) => {
  const { data, error } = await supabase
    .from('projects')
    .select(`
      *,
      tasks (
        id,
        title,
        status,
        assignee_id,
        profiles (
          username,
          full_name
        )
      )
    `)
    .eq('id', projectId)
    .single()

  return { data, error }
}
```

## 📚 Связанные материалы

- [Architect Protocol](../architect/protocol.md) — Проектирование схемы
- [Backend Executor Protocol](../backend-executor/protocol.md) — Реализация запросов
- [Validator Protocol](../validator/protocol.md) — Проверка RLS политик
- [Deployment Vercel Protocol](../deployment/vercel/protocol.md) — Деплой с Supabase