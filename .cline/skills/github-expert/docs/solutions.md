# GitHub Expert - Решения проблем

## 📚 Каталог решений

Это документ содержит решения для частых проблем при работе с GitHub Actions.

---

## 🚀 Быстрые решения

### Workflow не запускается
```yaml
# ✅ Решение: Проверьте структуру директории
.github/workflows/
├── ci.yml              # Правильно
└── .github/workflows/  # Неправильно (двойной путь)
```

**Диагностика:**
```bash
gh workflow list
yamllint .github/workflows/*.yml
```

---

### Secrets не доступны
```bash
# ✅ Решение: Добавьте секрет через GitHub UI
Settings → Secrets and variables → Actions → New repository secret
```

**Проверка:**
```bash
gh secret list
gh secret set MY_SECRET
```

---

### Cache не работает
```yaml
# ✅ Решение: Используйте hashFiles() для детерминированного ключа
- uses: actions/cache@v4
  with:
    path: node_modules
    key: ${{ runner.os }}-node-${{ hashFiles('**/package-lock.json') }}
```

---

### Permissions error
```yaml
# ✅ Решение: Добавьте permissions на уровне workflow
permissions:
  contents: read
  id-token: write

jobs:
  deploy:
    runs-on: ubuntu-latest
    # ...
```

---

## 🔧 Расширенные решения

### Проблема: Workflow timeout
```yaml
# ✅ Решение: Добавьте timeout-minutes
jobs:
  build:
    runs-on: ubuntu-latest
    timeout-minutes: 30  # Максимум 6 часов
    steps:
      - uses: actions/checkout@v5
```

---

### Проблема: Parallel execution
```yaml
# ✅ Решение: Используйте matrix strategy
jobs:
  test:
    strategy:
      fail-fast: false  # Не останавливать другие при ошибке
      matrix:
        os: [ubuntu-latest, windows-latest]
        node: [18, 20]
    runs-on: ${{ matrix.os }}
    steps:
      # ...
```

---

### Проблема: Artifact not found
```yaml
# ✅ Решение: Проверьте имя и путь артефакта
jobs:
  build:
    steps:
      - uses: actions/upload-artifact@v4
        with:
          name: my-artifact  # Это имя для download-artifact
          path: dist/

jobs:
  deploy:
    needs: build
    steps:
      - uses: actions/download-artifact@v4
        with:
          name: my-artifact  # Должно совпадать с upload-artifact
          path: dist/
```

---

## 📊 Ссылки на known-issues

| Проблема | Решение | known-issues.md |
|-----------|----------|-----------------|
| Workflow не запускается | Проверьте структуру | Проблема 1 |
| Secrets не доступны | Добавьте через UI | Проблема 2 |
| Pull Request Target | Используйте pull_request_target | Проблема 3 |
| Cache не работает | Используйте hashFiles() | Проблема 4 |
| Matrix не работает | Проверьте структуру | Проблема 5 |
| Secrets раскрываются | Используйте env | Проблема 6 |
| Composite Action | Проверьте путь | Проблема 7 |
| Permissions error | Добавьте permissions | Проблема 8 |

---

**Больше решений? Проверьте [advanced.md](advanced.md) для продвинутых сценариев!**