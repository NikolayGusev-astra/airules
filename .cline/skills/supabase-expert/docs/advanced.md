# 🚀 Продвинутые паттерны для Supabase Expert Skill

---

## ⚡ Realtime Subscriptions

```typescript
// lib/realtime.ts
import { supabase } from '@/lib/supabase'
import { useEffect, useState } from 'react'

export function useRealtime(channel: string) {
  const [data, setData] = useState(null)

  useEffect(() => {
    const subscription = supabase
      .channel(channel)
      .on('postgres_changes', {
        event: 'INSERT',
        schema: 'public',
        table: 'notifications'
      }, (payload) => {
        setData(payload.new)
      })
      .subscribe()

    return () => subscription.unsubscribe()
  }, [channel])

  return data
}
```

## 🔐 Advanced Auth

```typescript
// lib/auth.ts
import { supabase } from '@/lib/supabase'

export async function signUp(email: string, password: string) {
  const { data, error } = await supabase.auth.signUp({
    email,
    password,
    options: {
      emailRedirectTo: `${location.origin}/auth/callback`
    }
  })
  return { data, error }
}

export async function signIn(email: string, password: string) {
  const { data, error } = await supabase.auth.signInWithPassword({
    email,
    password
  })
  return { data, error }
}
```

## 📊 Storage with RLS

```sql
-- Storage buckets
INSERT INTO storage.buckets (id, name, public)
VALUES ('avatars', 'avatars', true);

-- RLS для storage
CREATE POLICY "Users can upload own avatar"
ON storage.objects FOR INSERT
WITH CHECK (
  bucket_id = 'avatars' AND 
  auth.role() = 'authenticated' AND
  (storage.foldername(name))[1] = auth.uid()::text
);