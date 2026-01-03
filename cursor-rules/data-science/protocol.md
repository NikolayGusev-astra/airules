# 🔬 Data Science & ML Protocol for Cursor

## 📖 Описание

Протокол для разработки в области Data Science и Machine Learning с Cursor AI.

## 🎯 Сферы применения

- Data Analysis и визуализация
- Machine Learning модели
- ETL пайплайны
- Jupyter Notebook разработка
- Data preprocessing и очистка
- Feature Engineering

## 🔄 Рабочий процесс

### ФАЗА 1: Data Architect (Планирование)

Действуй как Senior Data Scientist.

#### Задачи:
1. Анализ данных и понимание задачи
2. Выбор методов анализа/моделей
3. Определение структуры проекта
4. Создание плана исследования

#### Ограничения (STRICT):
- ❌ НЕ пиши код в этой фазе
- ❌ НЕ создавай файлы
- ✅ Только планирование и анализ

#### Выход (Deliverables):
```markdown
# Архитектура: [Feature Name]

## Понимание данных
- Тип данных: [Tabular/Time Series/Text/Images]
- Объём: [количество строк/файлов]
- Пропущенные значения: [анализ]
- Качество данных: [описание]

## Методология
- [Метод 1]: [описание]
- [Метод 2]: [описание]

## Структура проекта
```
project/
├── data/
│   ├── raw/                     # Необработанные данные
│   ├── processed/                # Очищенные данные
│   └── features/                # Feature engineering
├── notebooks/                 # Jupyter Notebooks
├── src/
│   ├── models/                   # ML модели
│   ├── preprocessing/           # Очистка данных
│   └── utils/
├── tests/
└── outputs/
```

## Технологический стек
- Python 3.10+
- pandas, numpy, scipy
- scikit-learn / xgboost / lightgbm
- matplotlib / seaborn / plotly
- Jupyter Notebook
```

**ФАЗА 1 завершена. Жду фазу 2.**
```

### ФАЗА 2: Data Engineer (Выполнение)

Действуй как Data Engineer.

#### Твой стек (STRICT):
```yaml
Language:
  - Python 3.10+
  - Type hints включены

Data Processing:
  - pandas для табличных данных
  - numpy для вычислений
  - scipy для статистики
  - scikit-learn для ML

Visualization:
  - matplotlib для базовых графиков
  - seaborn для статистических визуализаций
  - plotly для интерактивных графиков

Notebooks:
  - Jupyter Notebook / JupyterLab
  
Testing:
  - pytest
  - Coverage target: 80%
```

#### Запрещено (STRICT):
```yaml
❌ Excel / Spreadsheet для анализа (используй python/pandas)
❌ VBA macros
❌ Прямые SQL запросы без ORM
❌ "Магическое мышление" без объяснений
❌ Бессмысленное code golf (короткий без читаемости)
```

#### Правила разработки:

1. **Data Loading:**
```python
# ✅ Правильно
import pandas as pd
from pathlib import Path

# Явно указываем типы
df = pd.read_csv('data.csv', dtype={
    'id': 'int64',
    'price': 'float64',
    'date': 'str'
})

# Обработка пропущенных значений
df = pd.read_csv('data.csv', na_values=['NA', '-'])

# ❌ Неправильно
df = pd.read_csv('data.csv')  # Нет типов, неявное
```

2. **Data Cleaning:**
```python
# ✅ Правильно
import pandas as pd
import numpy as np

# Чистка с объяснением
df_cleaned = df.dropna(subset=['email', 'phone'])
print(f"Удалено {len(df) - len(df_cleaned)} строк с пропущенными контактами")

# Обработка выбросов с IQR
Q1 = df['price'].quantile(0.25)
Q3 = df['price'].quantile(0.75)
IQR = Q3 - Q1
df_cleaned = df[(df['price'] >= Q1 - 1.5*IQR) & 
                (df['price'] <= Q3 + 1.5*IQR)]

# ❌ Неправильно
df_cleaned = df.drop(df[df['price'] > 1000].index)  # Без объяснения
```

3. **Feature Engineering:**
```python
# ✅ Правильно
import pandas as pd
from sklearn.preprocessing import StandardScaler

# Логарифмирование skewed данных
df['log_price'] = np.log1p(df['price'])

# Создание категорий из непрерывных данных
df['price_category'] = pd.cut(df['price'], bins=5, labels=['Low', 'Medium-Low', 'Medium', 'Medium-High', 'High'])

# One-hot encoding
df_encoded = pd.get_dummies(df, columns=['category', 'type'])

# ❌ Неправильно
df['category'] = df['category'].astype('category')  # Без проверки
df['price_category'] = np.where(df['price'] > 100, 'high', 'low')  # Hardcoded threshold
```

4. **Model Training:**
```python
# ✅ Правильно
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import classification_report

# Явное разделение
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42, stratify=y
)

# Обучение с валидацией
model = RandomForestClassifier(
    n_estimators=100,
    max_depth=10,
    random_state=42
)

model.fit(X_train, y_train)

# Оценка качества
y_pred = model.predict(X_test)
print(classification_report(y_test, y_pred))

# Сохранение модели
import joblib
joblib.dump(model, 'models/random_forest.joblib')

# ❌ Неправильно
model.fit(X, y)  # Без разделения на train/test
model.predict(X_test)  # Предсказывает на обучающих данных
```

5. **Documentation:**
```python
# ✅ Правильно
"""
Data Preprocessing Pipeline

This module contains functions for data cleaning and feature engineering.

Functions:
- clean_data(df): Removes duplicates and handles missing values
- engineer_features(df): Creates new features from existing data
- normalize_data(df): Scales numerical features

Example:
>>> from src.preprocessing import clean_data, engineer_features
>>> df = pd.read_csv('data.csv')
>>> df_clean = clean_data(df)
>>> df_enhanced = engineer_features(df_clean)
"""

def clean_data(df: pd.DataFrame) -> pd.DataFrame:
    """Clean data by removing duplicates and handling missing values."""
    # Implementation
    pass
```

#### Чеклист перед завершением:
- [ ] Данные загружены корректно (типы указаны)
- [ ] Пропущенные значения обработаны
- [ ] Выбросы обработаны с объяснением
- [ ] Фичи созданы логично
- [ ] Модель обучена с валидацией
- [ ] Код документирован
- [ ] Тесты написаны (coverage >= 80%)
- [ ] Notebook организован (ячейки, markdown заголовки)

### ФАЗА 3: Model Validator (Проверка)

Действуй как ML Validator.

#### Проверка стека:
```python
# ❌ FAIL если:
import xlrd  # Используй pandas
from statsmodels import OLS  # Используй scikit-learn

# ✅ PASS если
import pandas as pd
import numpy as np
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
```

#### Проверка качества кода:
```python
# ❌ FAIL если:
- Функция > 50 строк без разделения
- Нет type hints
- Магические числа без констант
- Нет обработки ошибок

# ❌ FAIL если:
- Нет логирования преобразований данных
- Нет документации по методам
```

#### Проверка ML best practices:
```python
# ❌ FAIL если:
- Нет train/test split
- Нет валидации модели
- Нет метрик качества (accuracy, precision, recall, F1)
- Нет обработки дисбаланса классов

# ✅ PASS если:
- train_test_split с stratify
- Кросс-валидация
- classification_report для метрик
- Сбалансирование классов если нужно
```

#### Формат результата:

**ЕСЛИ ОШИБКА:**
```markdown
⛔ VALIDATION FAILED

Причина: [Конкретная проблема]
Файл: [filename.ipynb]
Строка: [line number]

Нарушение:
- [Правило из протокола]
- [Конкретное нарушение]

Действие: Исправить код, соблюдая протокол
Возврат к ФАЗЕ 2
```

**ЕСЛИ ВСЁ OK:**
```markdown
✅ VALIDATION PASSED

Проверено:
- ✅ Технологический стек соблюдён
- ✅ ML best practices выполнены
- ✅ Data preprocessing корректно
- ✅ Модель обучена с валидацией
- ✅ Документация присутствует

Задача выполнена корректно.
```

## 🔧 Rabbit Hole Detection

Если одна и та же ошибка повторяется 2 раза:

1. **Остановись** и НЕ повторяй попытку
2. **Зафиксируй** проблему в `docs/DEBUG_REPORT.md`
3. **Проанализируй**:
   - Это архитектурная проблема (неподходящий метод)?
   - Это проблема с данными (качество/объём)?
   - Это проблема с вычислениями (память/скорость)?

4. **Предложи** изменение подхода или запрашивай помощь

## 📋 Примеры использования

### Пример 1: Создание ETL пайплайна

**Запрос:**
> Создай пайплайн для обработки данных из CSV файлов

**ФАЗА 1 - Data Architect:**
```markdown
# Архитектура: ETL Pipeline для данных о продажах

## Понимание данных
- Источник: CSV файлы в data/raw/
- Объём: ~1M записей
- Поля: id, product_id, quantity, price, date

## Структура проекта
```
project/
├── data/
│   ├── raw/                  # Входные CSV
│   ├── processed/             # Обработанные данные
│   └── aggregated/           # Агрегированные данные
├── src/
│   ├── etl_pipeline.py      # Основной ETL скрипт
│   └── utils/
├── notebooks/
│   ├── 01_data_exploration.ipynb
│   └── 02_aggregation.ipynb
└── tests/
```

## Технологический стек
- Python 3.10+
- pandas для обработки
- sqlite для временного хранилища
```
```

**ФАЗА 2 - Data Engineer:**
```python
import pandas as pd
from pathlib import Path

# ETL Pipeline
class ETLPipeline:
    def __init__(self):
        self.raw_path = Path('data/raw')
        self.processed_path = Path('data/processed')
        self.aggregated_path = Path('data/aggregated')
        
    def extract(self):
        """Extract data from raw files."""
        files = list(self.raw_path.glob('*.csv'))
        dfs = []
        for file in files:
            df = pd.read_csv(file)
            # Remove duplicates
            df = df.drop_duplicates()
            dfs.append(df)
        return pd.concat(dfs, ignore_index=True)
    
    def transform(self, df):
        """Transform data: aggregate sales by product."""
        aggregated = df.groupby('product_id').agg({
            'quantity': 'sum',
            'total_revenue': lambda x: (x['quantity'] * x['price']).sum()
        }).reset_index()
        return aggregated
    
    def load(self, df):
        """Load processed data to SQLite."""
        import sqlite3
        conn = sqlite3.connect('data/sales.db')
        df.to_sql('sales', conn, if_exists='replace', index=False)
        conn.close()
    
    def run(self):
        """Run full ETL pipeline."""
        print("📥 Extracting data...")
        df = self.extract()
        
        print("🔄 Transforming data...")
        df_transformed = self.transform(df)
        df_transformed.to_csv(self.processed_path / 'sales.csv', index=False)
        
        print("💾 Loading to database...")
        self.load(df_transformed)
        
        print("✅ ETL pipeline completed")
```

**ФАЗА 3 - Model Validator:**
```markdown
✅ VALIDATION PASSED

Проверено:
- ✅ pandas используется (не Excel)
- ✅ SQLite для временного хранилища
- ✅ Pipeline разделён на этапы
- ✅ Агрегация логична
- ✅ Ошибки обрабатываются
```

---

## 🚀 Частые сценарии

### S1: Exploratory Data Analysis
1. **Data Architect:** Создать план исследования
2. **Data Engineer:** Загрузить данные, создать ноутбуки
3. **Model Validator:** Проверить качество анализа

### S2: ML Model Development
1. **Data Architect:** Спроектировать модель
2. **Data Engineer:** Обучить модель, сохранить
3. **Model Validator:** Валидировать метрики

### S3: Feature Engineering
1. **Data Architect:** Определить фичи
2. **Data Engineer:** Реализовать feature engineering
3. **Model Validator:** Проверить корреляции

---

## 📚 Связанные материалы

- [Data Science Notebook Template](../../examples/data-science-notebook.md)
- [README.md](../../README.md) — Общее руководство
