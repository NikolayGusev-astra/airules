# Визуализация ролевой модели AIRules 🤖

## Диаграмма процесса многоагентной разработки

```mermaid
graph TD
    A[👤 Пользователь<br/>Задача] --> B{Автономный<br/>Режим<br/>Оркестрации}

    B --> C[📋 ФАЗА 1: ARCHITECT<br/>Планирование]

    C --> C1[🔄 Синхронизация<br/>git status<br/>PROJECT_STATE.md<br/>SYSTEM_INSTRUCTION.md<br/>IMPLEMENTATION_PLAN.md]

    C1 --> C2[🔍 Анализ<br/>Проверка конфликтов<br/>Node.js vs Python]

    C2 --> C3[📝 Решение<br/>Создание плана<br/>Технический стек<br/>NUMERIC(15,2)]

    C3 --> C4[📄 Создание<br/>docs/TASK_SPEC.md]

    C4 --> D[⚡ АВТОМАТИЧЕСКИЙ<br/>ПЕРЕХОД]

    D --> E[💻 ФАЗА 2: EXECUTOR<br/>Выполнение]

    E --> E1[📖 Контекст<br/>План из Фазы 1<br/>ACCOUNTING_CONSTITUTION.md]

    E1 --> E2[🔍 Context7<br/>Проверка новых<br/>библиотек/API]

    E2 --> E3[✍️ Кодинг<br/>TypeScript/Node.js<br/>Supabase, Exceljs<br/>NUMERIC(15,2)]

    E3 --> E4{🐰 Rabbit Hole<br/>Detection<br/>Ошибка > 2 раз?}

    E4 -->|Да| E5[⛔ СТОП<br/>PROJECT_STATE.md<br/>Требуется человек]

    E4 -->|Нет| E6[✅ Код готов<br/>git commit]

    E6 --> F[⚡ АВТОМАТИЧЕСКИЙ<br/>ПЕРЕХОД]

    F --> G[🔍 ФАЗА 3: VALIDATOR<br/>Контроль]

    G --> G1[📋 Проверка Checklist<br/>Технологический стек<br/>Типы данных<br/>SQL RLS<br/>Бухгалтерия<br/>Context7 использование]

    G1 --> G2{❌ ОШИБКИ<br/>НАЙДЕНЫ?}

    G2 -->|Да| G3[⛔ VALIDATION FAILED<br/>Возврат к ФАЗЕ 2<br/>Причина ошибки]

    G2 -->|Нет| G4[✅ VALIDATION PASSED<br/>PROJECT_STATE.md<br/>git commit]

    G4 --> H[🎉 ЗАДАЧА<br/>ВЫПОЛНЕНА]

    %% Стилизация
    classDef phaseClass fill:#e1f5fe,stroke:#01579b,stroke-width:2px
    classDef successClass fill:#e8f5e8,stroke:#2e7d32,stroke-width:2px
    classDef errorClass fill:#ffebee,stroke:#c62828,stroke-width:2px
    classDef autoClass fill:#fff3e0,stroke:#ef6c00,stroke-width:2px

    class C,E,G phaseClass
    class G4,H successClass
    class E5,G3 errorClass
    class D,F autoClass
```

## Архитектура ролей

```mermaid
graph LR
    subgraph "🤖 Автономная Система"
        subgraph "👥 Роли"
            A1[🧠 ARCHITECT<br/>Старший Архитектор<br/>Создает ТЗ]
            A2[💻 EXECUTOR<br/>Middle Backend Dev<br/>Пишет код]
            A3[🔍 VALIDATOR<br/>Жесткий QA<br/>Проверяет код]
            A4[📚 CONTEXT7 RESEARCHER<br/>Исследователь<br/>Актуальная документация]
        end

        subgraph "🔄 Фазы выполнения"
            P1[📋 ФАЗА 1<br/>Планирование]
            P2[⚙️ ФАЗА 2<br/>Выполнение]
            P3[✅ ФАЗА 3<br/>Валидация]
        end
    end

    A1 --> P1
    A2 --> P2
    A3 --> P3
    A4 -.-> P1
    A4 -.-> P2

    %% Стилизация
    classDef roleClass fill:#f3e5f5,stroke:#6a1b9a,stroke-width:2px
    classDef phaseClass fill:#e8f5e8,stroke:#2e7d32,stroke-width:2px

    class A1,A2,A3,A4 roleClass
    class P1,P2,P3 phaseClass
```

## Детальная карта ответственностей

```mermaid
mindmap
  root((🤖 AIRules<br/>Ролевая модель))
    Архитектор
      Планирование
        Анализ требований
        Создание ТЗ
        Определение стека
        Проверка Context7
      Запреты
        НЕ пишет код
        НЕ тестирует
    Разработчик
      Выполнение
        TypeScript/Node.js
        Supabase + Exceljs
        NUMERIC(15,2)
        Context7 интеграция
      Безопасность
        Rabbit Hole detection
        Максимум 2 попытки
    Валидатор
      Контроль
        Stack validation
        Type checking
        SQL policies
        Accounting rules
        Context7 verification
      Действия
        PASS → git commit
        FAIL → возврат к dev
    Context7 Researcher
      Исследования
        Библиотеки
        API документация
        Версии
        Примеры кода
      Качество
        High reputation
        Benchmark score
        Code snippets
```

## Процесс принятия решений

```mermaid
flowchart TD
    START([Новая задача]) --> DECIDE{Тип задачи}

    DECIDE -->|Новая библиотека/API| CONTEXT7[🔍 Context7 Researcher<br/>resolve-library-id<br/>query-docs]
    DECIDE -->|Реализация кода| ARCHITECT[🧠 Architect<br/>Создание плана<br/>TASK_SPEC.md]

    CONTEXT7 --> ARCHITECT

    ARCHITECT --> EXECUTOR[💻 Executor<br/>Кодинг по плану<br/>TypeScript/Node.js]

    EXECUTOR --> RABBIT{Rabbit Hole?<br/>Ошибка 2+ раза}

    RABBIT -->|Да| HUMAN[👤 Требуется человек<br/>PROJECT_STATE.md]

    RABBIT -->|Нет| VALIDATOR[🔍 Validator<br/>Жесткая проверка]

    VALIDATOR --> RESULT{Результат<br/>валидации}

    RESULT -->|PASS ✅| COMMIT[git commit<br/>PROJECT_STATE.md<br/>Задача выполнена]

    RESULT -->|FAIL ❌| EXECUTOR

    COMMIT --> END([✅ Готово])

    %% Стилизация
    classDef decisionClass fill:#fff3e0,stroke:#ef6c00,stroke-width:2px
    classDef successClass fill:#e8f5e8,stroke:#2e7d32,stroke-width:2px
    classDef errorClass fill:#ffebee,stroke:#c62828,stroke-width:2px

    class DECIDE,RABBIT,RESULT decisionClass
    class COMMIT,END successClass
    class HUMAN errorClass
```

## Легенда и правила

### 🎯 Ключевые принципы
- **3 фазы обязательно** - ARCHITECT → EXECUTOR → VALIDATOR
- **Автоматические переходы** - без вопросов пользователю
- **Жесткая валидация** - FAIL возвращает к EXECUTOR
- **Rabbit Hole защита** - остановка при повторных ошибках

### 📊 Метрики качества
- **Технологический стек**: Node.js only, NUMERIC(15,2), Supabase
- **Бухгалтерские правила**: Expense vs Transfer, кредитная логика
- **Context7 интеграция**: актуальная документация, реальные примеры
- **Безопасность**: нет NEW/OLD в RLS, type safety

### 🚨 Критические правила
- **ЗАПРЕЩЕНО**: Python, Float/Double, устаревшие API
- **ОБЯЗАТЕЛЬНО**: Context7 для новых библиотек
- **АВТОМАТИЧЕСКИ**: переходы между фазами
- **ЖЕСТКО**: отклонение кода при нарушениях

---
*Визуализация создана для демонстрации многоагентной ролевой модели AIRules* 🎨
