# 💡 Решения для Supabase Expert Skill

## 🚀 Настройка проекта

```javascript
// lib/supabase.js
import { createClient } from '@supabase/supabase-js'

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL
const supabaseKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY

export const supabase = createClient(supabaseUrl, supabaseKey)
```

## 🔐 RLS Policies

```sql
-- Политика для чтения
CREATE POLICY "Public read access"
ON profiles FOR SELECT
USING (true);

-- Политика для вставки
CREATE POLICY "Users can insert own profile"
ON profiles FOR INSERT
WITH CHECK (auth.uid() = user_id);
```

## 📊 Edge Functions

```typescript
// supabase/functions/hello/index.ts
import { serve } from "https://deno.land/std@0.168.0/http/server.ts"

serve(async (req) => {
  const { name } = await req.json()
  return new Response(`Hello ${name}!`)
})