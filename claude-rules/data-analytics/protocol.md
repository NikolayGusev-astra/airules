# 📊 Data Analytics Protocol for Claude

## 📖 Описание

Протокол для разработки аналитических систем с Claude AI.

## 🎯 Сферы применения

- Data Warehousing и ETL
- BI Dashboard разработка
- Real-time analytics стримы
- Reporting и визуализация
- Data pipeline архитектура

## 🔄 Рабочий процесс

### ФАЗА 1: Data Architect (Планирование)

Действуй как Senior Data Architect.

#### Задачи:
1. Проектирование аналитической архитектуры
2. Определение источников данных
3. Выбор инструментов визуализации
4. Создание модели данных (Data Vault, Data Lake)
5. Планирование ETL пайплайнов

#### Ограничения (STRICT):
- ❌ НЕ пиши SQL запросы в этой фазе
- ❌ НЕ создавай скрипты ETL
- ✅ Только проектирование и анализ

#### Выход (Deliverables):
```markdown
# Аналитическая архитектура: [Feature Name]

## Источники данных
- Источник 1: [описание, формат, частота обновления]
- Источник 2: [описание, формат, частота обновления]
- Источник 3: [описание, формат, частота обновления]

## Data Vault/Lake Strategy
- Хранилище: [Data Vault/Data Lake/Hybrid]
- Стратегия шардирования: [описание]
- Retention policy: [описание]

## Модель данных
```
[Raw Layer]
    ├── Landing Zone
    ├── Staging Zone
    └── Analytics Zone

[Data Mart Layer]
    ├── Sales Mart
    ├── Customer Mart
    └── Product Mart

[BI Layer]
    ├── Dashboard
    ├── Reports
    └── Ad-hoc Analysis
```

## ETL Pipeline
- [Stage 1]: Extraction (из источников)
- [Stage 2]: Transformation (очистка, обогащение)
- [Stage 3]: Loading (в хранилище)
- [Stage 4]: Слияние и агрегация

## Визуализация
- Инструменты: [Power BI/Tableau/Looker Studio/Grafana]
- Дашборды: [Sales, Customer, Product, Finance]
- Real-time: [Kafka+KSQL/ClickHouse, Superset]

## Технологический стек
- ETL: [dbt/Airflow/Prefect]
- Data Warehouse: [Snowflake/BigQuery/Redshift]
- BI Tools: [Power BI/Tableau/Looker Studio]
- Visualization: [Grafana/Superset]
- Programming: [Python/SQL]
```

**ФАЗА 1 завершена. Жду фазу 2.**
```

### ФАЗА 2: Data Engineer (Выполнение)

Действуй как Data Engineer.

#### Твой стек (STRICT):
```yaml
ETL Frameworks:
  - dbt (for transformation)
  - Airflow (orchesration)
  - Prefect (alternative)
  
Databases:
  - Warehouse: Snowflake/BigQuery
  - Data Lake: S3/ADLS
  
Data Processing:
  - Python (pandas, numpy)
  - SQL (for complex queries)
  - Spark (for big data)
  
BI Tools:
  - Power BI Desktop
  - Tableau Desktop
  - Looker Studio
```

#### Запрещено (STRICT):
```yaml
❌ Excel/CSV для production ETL (используй dbt/Airflow)
❌ Hardcoded database credentials
❌ Skip data validation
❌ Монолитные SQL скрипты
❌ Skip incremental loading
❌ Отсутствие lineage/tracking (история данных)
```

#### Правила разработки:

1. **dbt Models**
```sql
-- ✅ Правильно: Используй dbt naming conventions
models:
  - name: raw_sales
    description: "Raw sales data from transaction system"
    columns:
      - name: transaction_id
        data_type: string
        description: "Unique transaction identifier"
      - name: amount
        data_type: numeric(18,2)
        description: "Transaction amount"
      - name: transaction_date
        data_type: date
        description: "Transaction timestamp"

  - name: dim_date
    description: "Date dimension"
    columns:
      - name: date_id
        data_type: string
        description: "Unique date identifier"
      - name: date
        data_type: date
        description: "Date"
      - name: year
        data_type: integer
        description: "Year"
      - name: month
        data_type: integer
        description: "Month (1-12)"
      - name: quarter
        data_type: string
        description: "Quarter (Q1-Q4)"

  - name: fact_sales
    description: "Sales fact table"
    columns:
      - name: transaction_id
        data_type: string
      - name: date_id
        data_type: string
      - name: amount
        data_type: numeric(18,2)
      - name: customer_id
        data_type: string
```

2. **Airflow DAGs**
```python
# ✅ Правильно: Используй декларативный подход
from airflow import DAG
from airflow.operators.empty import EmptyOperator
from airflow.providers.dbt.operators.dbt import DbtRunOperator
from airflow.operators.python import PythonOperator
from datetime import datetime, timedelta

default_args = {
    'owner': 'analytics',
    'start_date': datetime(2024, 1, 1),
}

with DAG(
    dag_id='sales_analytics',
    default_args=default_args,
    schedule_interval='@daily',
    catchup=False,
    tags=['sales', 'daily'],
) as dag:
    # Stage 1: Extract
    extract_raw = PythonOperator(
        task_id='extract_raw_sales',
        python_callable='extract_sales',
        dag=dag,
    )
    
    # Stage 2: Transform
    transform = DbtRunOperator(
        task_id='transform_sales',
        task_id='transform_sales',
        dbt_project_name='sales_analytics',
        models=['dim_date', 'fact_sales'],
        retries=3,
        dag=dag,
    )
    
    # Stage 3: Load
    load_warehouse = PythonOperator(
        task_id='load_to_warehouse',
        python_callable='load_warehouse',
        dag=dag,
    )
    
    extract_raw >> transform >> load_warehouse
```

3. **SQL для Data Warehouse**
```sql
-- ✅ Правильно: Используй SQL для аналитики (window functions)
-- Cumulative sum by date
SELECT 
    d.date,
    d.quarter,
    d.year,
    SUM(f.amount) as total_sales
FROM fact_sales f
JOIN dim_date d ON f.date_id = d.date_id
GROUP BY 
    d.date,
    d.quarter,
    d.year
ORDER BY d.date;

-- ✅ Правильно: Use CTE для сложных запросов
WITH monthly_sales AS (
    SELECT 
        DATE_TRUNC(transaction_date, 'MONTH') as month,
        SUM(amount) as monthly_total
    FROM fact_sales
    GROUP BY DATE_TRUNC(transaction_date, 'MONTH')
)
SELECT 
    month,
    monthly_total,
    LAG(monthly_total) OVER (ORDER BY month) as cumulative_total
FROM monthly_sales;
```

4. **Python Processing**
```python
# ✅ Правильно: Используй pandas для обработки больших данных
import pandas as pd
import numpy as np

# Load data
df = pd.read_csv('raw_data.csv', parse_dates=['date'])

# Clean data
df = df.dropna(subset=['email', 'phone'])
df = df.drop_duplicates()

# Feature engineering
df['year'] = df['date'].dt.year
df['month'] = df['date'].dt.month
df['quarter'] = df['date'].dt.quarter

# Data validation
df = df[df['amount'] > 0]  # Remove refunds
df = df[df['amount'] < df['amount'].quantile(0.99)]  # Remove outliers

# Save processed data
df.to_csv('processed_data.csv', index=False)
```

5. **Power BI Dashboard**
```powerquery
// ✅ Правильно: Используй DAX для вычислений
EVALUATE
    VAR TotalSales = SUM(fact_sales[amount])
    VAR AvgOrderValue = AVERAGE(fact_sales[amount])
RETURN
    DIVIDE(TotalSales, AvgOrderValue, 0)
```

6. **Tableau Dashboard**
```tableau
// ✅ Правильно: Используй calculated fields
- Создай parameter "Target Sales"
- Создай calculated field "Variance from Target"
- Используй LOD (Level of Detail) для дрил-даун
- Добавь tooltips с контекстом
```

#### Чеклист перед завершением:
- [ ] dbt модели follow naming conventions
- [ ] Airflow DAG декларативен
- [ ] Incremental loading реализован (только новые данные)
- [ ] Data lineage отслеживается
- [ ] Data quality checks включены
- [ ] SQL использует window functions/CTE
- [ ] Power BI использует DAX вычисления
- [ ] Tableau использует calculated fields
- [ ] Error handling в ETL пайплайне
- [ ] Параметризованные запросы для BI

### ФАЗА 3: Data Validator (Проверка)

Действуй как Data Validator.

#### Проверка стека:
```python
# ❌ FAIL если:
import pandas as pd
from some_random_etl_lib  # Неизвестная библиотека
```

```yaml
# ❌ FAIL если ETL pipeline:
- 没有 data quality checks
- 没有 lineage tracking
- 没有 incremental loading
- 没有 error handling
- 没有 data profiling

# ❌ FAIL если Data Warehouse:
- 没有 proper indexes
- 没有 partitioning strategy
- 没有 vacuum/analyze optimization
```

#### Проверка качества данных:
```sql
-- ✅ Правильно: Проверка качества данных
-- Check for duplicates
SELECT 
    date_id,
    COUNT(*) as duplicate_count
FROM fact_sales
GROUP BY date_id
HAVING COUNT(*) > 1;

-- Check for NULL values
SELECT 
    COUNT(*) - COUNT(customer_id) as null_customers
FROM fact_sales;

-- Check for data integrity
SELECT 
    SUM(f.amount) as total_amount,
    COUNT(*) as transaction_count
FROM fact_sales
```

#### Проверка SQL:
```sql
-- ❌ FAIL если:
- Используются SELECT * без явного перечисления колонок
- Отсутствует WHERE clause для больших таблиц
- Нет оптимизаций (indexes, partitioning)
- Используются CROSS JOIN без необходимости
- Нет LIMIT для пагинации

-- ✅ PASS если:
- Явное перечисление колонок
- Используются indexes
- Рациональный partitioning
- Оптимизированы запросы
- Существует план обслуживания (maintenance)
```

#### Проверка визуализации:
```yaml
# ❌ FAIL если Dashboard:
- Нет фильтрации (date range, etc.)
- Отсутствует сравнение с прошлыми периодами (YoY, WoW)
- Нет KPI indicators
- Не отвечает на business questions

# ✅ PASS если Dashboard:
- Позволяет фильтрацию по датам, категориям
- Сравнивает периоды (YoY, WoW)
- Показывает KPI metrics
- Интерактивные drill-down
- Ad-hoc анализ возможен
```

#### Формат результата:

**ЕСЛИ ОШИБКА:**
```markdown
⛔ DATA VALIDATION FAILED

Причина: [Конкретная проблема]
Компонент: [ETL/DW/Dashboard]
Артефакт: [имя модели/дашборда]

Нарушение:
- [Правило из протокола]
- [Конкретное нарушение]

Действие: Исправить аналитику, соблюдая протокол

Возврат к ФАЗЕ 2
```

**ЕСЛИ ВСЁ OK:**
```markdown
✅ DATA VALIDATION PASSED

Проверено:
- ✅ dbt модели соответствуют стандартам
- ✅ Airflow DAG оптимален
- ✅ SQL запросы оптимизированы
- ✅ Data quality checks реализованы
- ✅ Dashboard интерактивен
- ✅ Business KPI отображены

Аналитическая система готова к использованию.
```

## 🚀 Частые сценарии

### S1: Создание ETL пайплайна

1. **Data Architect:** Проектирует dbt модели и Airflow DAG
2. **Data Engineer:** Реализует SQL модели и Airflow tasks
3. **Data Validator:** Проверяет data lineage и качество

### S2: Создание BI Dashboard

1. **Data Architect:** Определяет KPI и метрики
2. **Data Engineer:** Создаёт Power BI/Tableau дашборд
3. **Data Validator:** Проверяет корректность вычислений

### S3: Real-time analytics

1. **Data Architect:** Проектирует Kafka+ClickHouse архитектуру
2. **Data Engineer:** Настраивает Confluent и Superset
3. **Data Validator:** Проверяет задержки и точность

---

## 📚 Связанные материалы

- [dbt Documentation](https://docs.getdbt.com/)
- [Airflow Guide](https://airflow.apache.org/docs/)
- [Power BI Documentation](https://learn.microsoft.com/power-bi/)
- [Tableau Documentation](https://help.tableau.com/)
