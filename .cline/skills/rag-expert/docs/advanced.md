# 🚀 Продвинутые паттерны для RAG Expert Skill

## 🧠 Hybrid Retrieval (Гибридный поиск)

**Сочетание плотного и разрежённого поиска:**

```javascript
async function hybridSearch(query) {
  const [denseResults, sparseResults] = await Promise.all([
    vectorStore.search(query, { type: "dense" }),  // Semantic search
    bm25Search(query, { type: "sparse" })  // Keyword search
  ]);
  
  return rerank([...denseResults, ...sparseResults]);
}
```

**Преимущества:**
- ✅ Semantic понимание + точные ключевые слова
- ✅ Лучшее качество результатов
- ✅ Robust к разным типам запросов

## 🎯 Reranking Strategies

**Двухэтапное ранжирование:**

```javascript
// Stage 1: Retrieve candidate documents
const candidates = await vectorStore.search(query, { topK: 100 });

// Stage 2: Rerank with cross-encoder
const reranked = await reranker.rerank(query, candidates, { topK: 10 });
```

**Cross-encoder реранкеры:**
- `BAAI/bge-reranker-v2-m3` - отличный для общих задач
- `cohere/rerank-multilingual-v3.0` - многоязычный
- `ms-marco-MiniLM-L-12-v2` - быстрый и лёгкий

## 🔄 Recursive Retrieval (Рекурсивный поиск)

**Иерархический поиск по документам:**

```javascript
async function recursiveSearch(query) {
  const chunks = [];
  let currentDepth = 0;
  const maxDepth = 3;
  
  while (currentDepth < maxDepth) {
    const results = await searchAtDepth(query, currentDepth);
    
    if (results.satisfactory) {
      chunks.push(...results.chunks);
      break;
    }
    
    currentDepth++;
  }
  
  return chunks;
}
```

**Применение:**
- Документы с иерархической структурой
- Когда нужен контекст разных уровней детализации

## 📊 Metadata Filtering

**Фильтрация результатов по метаданным:**

```javascript
const results = await vectorStore.search(query, {
  filter: {
    domain: "Accounting",
    language: "en",
    year: { $gte: 2024 }
  }
});
```

**Виды фильтров:**
- Equality: `domain: "Accounting"`
- Range: `year: { $gte: 2024 }`
- Set: `category: { $in: ["finance", "reports"] }`
- Logical: `AND: [{ domain: "Accounting" }, { language: "en" }]`

## 🧪 Multi-Query Retrieval

**Генерация нескольких запросов:**

```javascript
async function multiQuerySearch(originalQuery) {
  const queries = await llm.generate(`
    Generate 3 diverse search queries for: "${originalQuery}"
  `);
  
  const allResults = await Promise.all(
    queries.map(q => vectorStore.search(q, { topK: 5 }))
  );
  
  return rerank([].concat(...allResults));
}
```

**Преимущества:**
- ✅ Поймает разные аспекты вопроса
- ✅ Более полное покрытие контекста
- ✅ Улучшает качество ответов

## 🎯 Query Decomposition

**Разделение сложных запросов:**

```javascript
async function decomposeQuery(query) {
  const subQueries = await llm.generate(`
    Decompose this query into sub-questions: "${query}"
  `);
  
  const answers = await Promise.all(
    subQueries.map(q => ragAnswer(q))
  );
  
  return combineAnswers(answers);
}
```

**Пример:**
```
Query: "Compare RAG and Fine-tuning for documentation"

Sub-queries:
1. "What is RAG for documentation?"
2. "What is Fine-tuning for documentation?"
3. "Compare RAG vs Fine-tuning approaches"