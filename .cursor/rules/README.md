# Cursor Rules для AIRules

Эта директория содержит правила для Cursor IDE в современном формате (2025-2026).

## Формат правил

Каждое правило — это файл `.mdc` с метаданными frontmatter:

```yaml
---
description: Краткое описание правила
globs: ["**/*.ts", "**/*.tsx"]  # Опционально
alwaysApply: true  # или false
---
```

## Режимы применения

- **Always Apply** (`alwaysApply: true`) — правило всегда применяется
- **Apply Intelligently** (`alwaysApply: false`) — ИИ сам решает когда применять
- **Apply to Files/Folders** (через `globs`) — правило активируется только при работе с указанными файлами

## Все правила

Всего создано 32 правила, мигрированных из `.cline/skills/` и `.clinerules/roles/`.

См. [cursor-rules/README.md](../cursor-rules/README.md) для полного списка и описания.
