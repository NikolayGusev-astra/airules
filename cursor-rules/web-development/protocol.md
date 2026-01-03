# 🌐 Web Development Protocol for Cursor

## 📖 Описание

Протокол для веб-разработки с Cursor AI. Оптимизирован для фронтенд и fullstack разработки.

## 🎯 Сферы применения

- Single Page Applications (SPA)
- Next.js App Router приложения
- React компоненты и страницы
- TypeScript + Tailwind стек

## 🔄 Рабочий процесс

### ФАЗА 1: Frontend Architect (Планирование)

Действуй как Senior Frontend Architect.

#### Задачи:
1. Проектирование компонентной архитектуры
2. Определение структуры файлов
3. Выбор state management подхода
4. Создание TypeScript interfaces
5. Дизайн data flow

#### Ограничения (STRICT):
- ❌ НЕ пиши код в этой фазе
- ❌ НЕ создавай файлы
- ✅ Только архитектурное проектирование

#### Выход (Deliverables):
```markdown
# Архитектура: [Feature Name]

## Компонентная структура
```
src/
  components/
    [Component1].tsx
    [Component2].tsx
  pages/
    [Page1].tsx
  hooks/
    [CustomHook].ts
  types/
    [Types].ts
  utils/
    [Helper].ts
```

## Data Flow
[Диаграмма потока данных]

## State Management
- Global: [Zustand/Context]
- Local: [useState/useReducer]

## TypeScript Interfaces
[Interface definitions]
```

### ФАЗА 2: Frontend Developer (Выполнение)

Действуй как React Developer.

#### Твой стек (STRICT):
```yaml
Frontend:
  - React 18+ с hooks
  - TypeScript strict mode
  - Tailwind CSS для стилей
  - shadcn/ui components (если в проекте)
  
State:
  - Zustand для global state
  - Context API для темы/языка
  
Data:
  - React Query / SWR для data fetching
  - tRPC если используется
  
Testing:
  - React Testing Library
  - Vitest или Jest
```

#### Запрещено (STRICT):
```yaml
❌ Любые `any` типы (кроме external libs)
❌ jQuery, Bootstrap, или устаревшие библиотеки
❌ CSS-in-JS кроме styled-components/twind
❌ Redux без явного требования
❌ Пропсы drilling глубже 3 уровней
```

#### Правила разработки:

1. **Структура компонента:**
```tsx
// 1. Imports (React + dependencies)
import { useState, useCallback } from 'react';

// 2. Types/Interfaces
interface ComponentProps {
  // props
}

// 3. Helper functions/constants
const helper = () => {};

// 4. Component definition
export const Component = ({ prop1, prop2 }: ComponentProps) => {
  // hooks
  // handlers
  // effects
  
  return <div>{...}</div>;
};

// 5. Default export (если нужно)
export default Component;
```

2. **Типизация:**
- Все props через `interface`
- Нет `any` — используй `unknown` если тип неизвестен
- Обобщай типы через generics
- Use discriminated unions для union types

3. **Performance:**
```tsx
// ✅ Правильно
const memoizedValue = useMemo(() => computeExpensive(a, b), [a, b]);
const memoizedCallback = useCallback(() => doSomething(a, b), [a, b]);

// ❌ Неправильно
const value = computeExpensive(a, b); // пересчитывается каждый ререндер
```

4. **Accessibility:**
```tsx
// ✅ Правильно
<button onClick={handleClick} aria-label="Close modal">
  <CloseIcon />
</button>

// ❌ Неправильно
<div onClick={handleClick}> // не фокусируется клавиатурой
  <CloseIcon />
</div>
```

#### Чеклист перед завершением:
- [ ] Нет `any` типов
- [ ] Все props типизированы
- [ ] Атрибуты key присутствуют где нужно
- [ ] Event handlers правильно названы (onClick, onSubmit)
- [ ] Loading states обработаны
- [ ] Error states обработаны
- [ ] Компонент работает без JS (progressive enhancement где применимо)

### ФАЗА 3: Code Validator (Проверка)

Действуй как Strict Code Reviewer.

#### Проверка стека:
```typescript
// ❌ FAIL если:
- import 'jquery'
- import 'bootstrap'
- any типы (кроме external)
```

#### Проверка качества:
```typescript
// ❌ FAIL если:
- Функция > 50 строк
- Вложенность > 4 уровней
- Дублирование кода > 2 раз
- Magic numbers без констант
```

#### Проверка безопасности:
```typescript
// ❌ FAIL если:
- dangerouslySetInnerHTML без санитизации
- eval() или Function()
- inline event handlers в JSX dangerously
- XSS vulnerable patterns
```

#### Формат результата:

**ЕСЛИ ОШИБКА:**
```markdown
⛔ VALIDATION FAILED

Причина: [Конкретная проблема]
Файл: [filename.tsx]
Строка: [line number]

Нарушение:
- [Rule that was violated]
- [Specific constraint from protocol.md]

Действие: Исправить код, соблюдая протокол

Возврат к ФАЗЕ 2
```

**ЕСЛИ ВСЁ OK:**
```markdown
✅ VALIDATION PASSED

Проверено:
- ✅ TypeScript strict mode
- ✅ No forbidden libraries
- ✅ Code quality standards
- ✅ Security checks
- ✅ Accessibility requirements

Задача выполнена корректно.
```

## 🔧 Rabbit Hole Detection

Если одна и та же ошибка повторяется 2 раза:

1. **Остановись и НЕ повторяй попытку**
2. **Зафиксируй в ERRORS.md:**
```markdown
## ⚠️ Known Error - [Дата]

**Context:** Что делал
**Error:** Сообщение об ошибке
**Attempt 1:** Первая попытка решения
**Attempt 2:** Вторая попытка решения
**Status:** Requires human intervention
```
3. **Сообщи:**
```
⛔ ERROR: Ошибка зафиксирована в ERRORS.md
Проблема требует вмешательства человека.

Error: [Specific error]
Attempts: 2
```

## 📋 Примеры использования

### Пример 1: Создание компонента Button

**Запрос:**
> Создай компонент Button с вариантами primary/secondary/danger

**ФАЗА 1 - Architect Output:**
```markdown
# Архитектура: Button Component

## Component Structure
- Single file: components/ui/Button.tsx
- Reusable, composable
- Uses Tailwind for styling

## Props Interface
```typescript
interface ButtonProps {
  variant?: 'primary' | 'secondary' | 'danger';
  size?: 'sm' | 'md' | 'lg';
  disabled?: boolean;
  loading?: boolean;
  children: React.ReactNode;
  onClick?: () => void;
}
```

## Design System
- Primary: blue-500 with white text
- Secondary: gray-200 with gray-800 text
- Danger: red-500 with white text
```

**ФАЗА 2 - Developer Code:**
```tsx
import { ButtonHTMLAttributes } from 'react';
import { clsx } from 'clsx';

interface ButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: 'primary' | 'secondary' | 'danger';
  size?: 'sm' | 'md' | 'lg';
  loading?: boolean;
}

export const Button = ({
  variant = 'primary',
  size = 'md',
  loading = false,
  disabled,
  children,
  className,
  ...props
}: ButtonProps) => {
  return (
    <button
      disabled={disabled || loading}
      className={clsx(
        'rounded font-medium transition-colors',
        'focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-offset-2',
        {
          // Variants
          'bg-blue-500 text-white hover:bg-blue-600': variant === 'primary',
          'bg-gray-200 text-gray-800 hover:bg-gray-300': variant === 'secondary',
          'bg-red-500 text-white hover:bg-red-600': variant === 'danger',
          // Sizes
          'px-3 py-1.5 text-sm': size === 'sm',
          'px-4 py-2': size === 'md',
          'px-6 py-3 text-lg': size === 'lg',
          // States
          'opacity-50 cursor-not-allowed': disabled || loading,
        },
        className
      )}
      {...props}
    >
      {loading ? <LoadingSpinner /> : children}
    </button>
  );
};
```

**ФАЗА 3 - Validator:**
```markdown
✅ VALIDATION PASSED

Проверено:
- ✅ TypeScript: props typed via interface extending ButtonHTMLAttributes
- ✅ No forbidden libraries
- ✅ Accessibility: focus-visible ring, disabled state
- ✅ Accessibility: uses native button (keyboard focusable)
- ✅ Code quality: single responsibility, proper composition
- ✅ Performance: clsx for conditional classes
```

### Пример 2: Страница с data fetching

**Запрос:**
> Создай страницу Users с загрузкой списка пользователей через API

**Architect Output:**
```markdown
# Архитектура: Users Page

## Structure
```
pages/users/index.tsx
components/UsersTable.tsx
hooks/useUsers.ts
types/users.ts
```

## Data Flow
Page → useUsers hook → API → React Query cache → Table

## TypeScript Interfaces
```typescript
interface User {
  id: string;
  name: string;
  email: string;
  role: 'admin' | 'user';
}
```
```

---

## 🚀 Частые сценарии

### S1: Создание нового feature

1. **Architect:** Проектируй архитектуру
2. **Developer:** Реализуй по плану
3. **Validator:** Проверь код

### S2: Рефакторинг компонента

1. **Architect:** Проанализируй текущий код, предложи улучшения
2. **Developer:** Примени рефакторинг
3. **Validator:** Убедись что функциональность сохранена

### S3: Фикс бага

1. **Architect:** Проанализируй проблему, определи причину
2. **Developer:** Напиши исправление
3. **Validator:** Проверь что баг исправлен, ничего не сломано

---

## 📚 Связанные материалы

- [Frontend Architect Role](./roles/architect.md)
- [Frontend Developer Role](./roles/developer.md)
- [Code Validator Role](./roles/validator.md)
- [Cursor Rules README](../README.md)
