# 🎨 Image Generation Protocol for Cursor

## 📖 Описание

Протокол для генерации изображений в Cursor AI. Специализирован на работе с AI-моделями генерации изображений и интеграции в приложения.

## 🎯 Сферы применения

- Генерация изображений через AI API
- Создание аватаров и профильных картинок
- Генерация иллюстраций для контента
- Создание mockup изображений
- Автоматизация графического контента

## 🔄 Рабочий процесс

### ФАЗА: Media Generator

Действуй как AI Image Generation Specialist.

#### Задачи:
1. Анализ требований к изображению
2. Создание эффективных промптов
3. Выбор подходящей AI модели
4. Оптимизация параметров генерации
5. Пост-обработка изображений
6. Интеграция в приложение

#### Ограничения (STRICT):
- ✅ Работай только с этичными и легальными запросами
- ✅ Соблюдай авторские права
- ✅ Оптимизируй для производительности

## 🎨 AI Модели генерации

### Основные модели:

#### DALL-E (OpenAI):
```typescript
// Типичные параметры
interface DalleConfig {
  model: 'dall-e-2' | 'dall-e-3'
  prompt: string
  size: '256x256' | '512x512' | '1024x1024' | '1792x1024' | '1024x1792'
  quality: 'standard' | 'hd'
  style: 'natural' | 'vivid'
}
```

#### Stable Diffusion:
```typescript
// Через API (Stability AI или локально)
interface StableDiffusionConfig {
  prompt: string
  negative_prompt: string
  width: number
  height: number
  steps: number
  guidance_scale: number
  seed?: number
}
```

#### Midjourney (через Discord API):
```typescript
// Discord bot integration
interface MidjourneyConfig {
  prompt: string
  aspect_ratio: string
  style: 'raw' | 'cute' | 'expressive' | 'scenic'
  version: '5.2' | '5.1' | '4' | '3'
}
```

## 📝 Создание промптов

### Структура эффективного промпта:

```
[Subject] [Action/Scene] [Style] [Lighting] [Composition] [Details]
```

### Примеры промптов:

#### Аватары пользователей:
```
"Professional headshot of a [age] year old [ethnicity] [gender] with [hair style], 
wearing [clothing], [expression], studio lighting, clean background, 
high resolution, photorealistic"
```

#### Иллюстрации продукта:
```
"Minimalist icon of [product] in [style], simple shapes, 
[primary color] background, clean lines, vector art style"
```

#### Контент иллюстрации:
```
"[Subject] in [environment], [mood] atmosphere, [art style], 
[color palette], detailed, high quality, digital art"
```

## 🔧 Интеграция в приложение

### React компонент для генерации:

```typescript
// components/ImageGenerator.tsx
import { useState } from 'react'

interface ImageGeneratorProps {
  onImageGenerated: (url: string) => void
  promptTemplate?: string
}

export const ImageGenerator = ({ onImageGenerated, promptTemplate }: ImageGeneratorProps) => {
  const [prompt, setPrompt] = useState('')
  const [loading, setLoading] = useState(false)
  const [generatedImage, setGeneratedImage] = useState<string | null>(null)

  const generateImage = async () => {
    setLoading(true)
    try {
      const finalPrompt = promptTemplate 
        ? promptTemplate.replace('{prompt}', prompt)
        : prompt

      const response = await fetch('/api/generate-image', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ prompt: finalPrompt })
      })

      const data = await response.json()
      setGeneratedImage(data.imageUrl)
      onImageGenerated(data.imageUrl)
    } catch (error) {
      console.error('Image generation failed:', error)
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="image-generator">
      <textarea
        value={prompt}
        onChange={(e) => setPrompt(e.target.value)}
        placeholder="Describe the image you want to generate..."
        rows={4}
      />
      <button onClick={generateImage} disabled={loading}>
        {loading ? 'Generating...' : 'Generate Image'}
      </button>
      
      {generatedImage && (
        <div className="generated-image">
          <img src={generatedImage} alt="Generated" />
          <button onClick={() => onImageGenerated(generatedImage)}>
            Use This Image
          </button>
        </div>
      )}
    </div>
  )
}
```

### API endpoint:

```typescript
// pages/api/generate-image.ts
import { NextApiRequest, NextApiResponse } from 'next'
import OpenAI from 'openai'

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY
})

export default async function handler(req: NextApiRequest, res: NextApiResponse) {
  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method not allowed' })
  }

  const { prompt } = req.body

  if (!prompt) {
    return res.status(400).json({ error: 'Prompt is required' })
  }

  try {
    const response = await openai.images.generate({
      model: 'dall-e-3',
      prompt: prompt,
      size: '1024x1024',
      quality: 'standard',
      n: 1,
    })

    const imageUrl = response.data[0].url

    res.status(200).json({ imageUrl })
  } catch (error) {
    console.error('OpenAI API error:', error)
    res.status(500).json({ error: 'Image generation failed' })
  }
}
```

## 🎭 Промпт шаблоны

### Предопределенные шаблоны:

```typescript
// utils/imagePrompts.ts
export const imagePrompts = {
  avatar: {
    template: "Professional headshot of a {age} year old {gender} {profession}, {hair}, wearing {clothing}, {expression}, studio lighting, clean white background, photorealistic, high resolution",
    variables: ['age', 'gender', 'profession', 'hair', 'clothing', 'expression']
  },
  
  product: {
    template: "Minimalist 3D render of {product}, {material}, {lighting}, clean background, high detail, commercial photography style",
    variables: ['product', 'material', 'lighting']
  },
  
  illustration: {
    template: "{subject} in {style} art style, {colors}, {mood} atmosphere, detailed, high quality, digital illustration",
    variables: ['subject', 'style', 'colors', 'mood']
  }
}
```

## 🖼️ Пост-обработка

### Оптимизация изображений:

```typescript
// utils/imageOptimization.ts
import sharp from 'sharp'

export const optimizeImage = async (imageBuffer: Buffer, options: {
  width?: number
  height?: number
  quality?: number
  format?: 'jpeg' | 'png' | 'webp'
}) => {
  let pipeline = sharp(imageBuffer)

  if (options.width || options.height) {
    pipeline = pipeline.resize(options.width, options.height, {
      fit: 'cover',
      position: 'center'
    })
  }

  if (options.format === 'jpeg') {
    pipeline = pipeline.jpeg({ quality: options.quality || 80 })
  } else if (options.format === 'webp') {
    pipeline = pipeline.webp({ quality: options.quality || 80 })
  }

  return pipeline.toBuffer()
}
```

### Batch генерация:

```typescript
// utils/batchImageGeneration.ts
export const generateBatchImages = async (prompts: string[], options = {}) => {
  const results = []
  
  for (const prompt of prompts) {
    try {
      const imageUrl = await generateImage(prompt, options)
      results.push({ prompt, imageUrl, success: true })
      
      // Rate limiting
      await new Promise(resolve => setTimeout(resolve, 1000))
    } catch (error) {
      results.push({ prompt, error: error.message, success: false })
    }
  }
  
  return results
}
```

## 💰 Оптимизация стоимости

### Эффективные стратегии:

1. **Кеширование результатов:**
```typescript
// Cache similar prompts
const promptCache = new Map<string, string>()

export const getCachedImage = async (prompt: string) => {
  const cacheKey = hashPrompt(prompt)
  
  if (promptCache.has(cacheKey)) {
    return promptCache.get(cacheKey)
  }
  
  const imageUrl = await generateImage(prompt)
  promptCache.set(cacheKey, imageUrl)
  
  return imageUrl
}
```

2. **Оптимизация размера:**
```typescript
// Use smaller sizes for previews
const sizes = {
  preview: '256x256',
  standard: '512x512',
  high: '1024x1024'
}
```

3. **Reuse элементов:**
```typescript
// Break complex prompts into reusable parts
const elements = {
  lighting: 'soft studio lighting',
  background: 'clean white background',
  style: 'photorealistic'
}
```

## 📚 Связанные материалы

- [Architect Protocol](../architect/protocol.md) — Планирование медиа интеграции
- [Backend Executor Protocol](../backend-executor/protocol.md) — Реализация API
- [Validator Protocol](../validator/protocol.md) — Проверка контента
- [Deployment Vercel Protocol](../deployment/vercel/protocol.md) — Деплой с изображениями