/**
 * LLM Web Wrapper - Примеры использования
 * 
 * Демонстрирует использование LLM через browser automation (Playwright/Chrome DevTools)
 * Ключевое слово для активации скилла: "Заюшь" 🐰
 */

import LLMWebWrapper from './LLMWebWrapper.js';

// ================================
// КОНФИГУРАЦИЯ
// ================================

// Примечание: MCP инструменты (Playwright, Chrome DevTools) должны быть
// настроены и доступны в Cline перед использованием

// ================================
// ПРИМЕР 1: Простой вопрос
// ================================

async function example1_SimpleQuestion() {
  console.log('\n' + '='.repeat(60));
  console.log('📋 Пример 1: Простой вопрос');
  console.log('='.repeat(60));

  const llm = new LLMWebWrapper({
    provider: 'chat-zai',
    mcpTool: 'playwright', // или 'chrome-devtools'
    baseURL: 'https://chat.z.ai',
    timeout: 30000
  });

  try {
    // Инициализация
    await llm.init();

    // Отправка вопроса
    const response = await llm.sendMessage('Какая столица Франции?');

    console.log('\n🤖 Ответ от LLM:');
    console.log(response);

    // Статистика
    console.log('\n📊 Статистика:');
    console.log(JSON.stringify(llm.getStats(), null, 2));

    // Закрытие сессии
    await llm.close();
  } catch (error) {
    console.error('❌ Ошибка:', error.message);
  }
}

// ================================
// ПРИМЕР 2: С System Prompt
// ================================

async function example2_WithSystemPrompt() {
  console.log('\n' + '='.repeat(60));
  console.log('📋 Пример 2: С System Prompt');
  console.log('='.repeat(60));

  const llm = new LLMWebWrapper({
    provider: 'chat-zai',
    mcpTool: 'playwright'
  });

  try {
    await llm.init();

    const systemPrompt = 'Ты опытный программист на TypeScript. Объясняй концепции четко и лаконично.';
    const question = 'В чем разница между let и const в JavaScript?';

    const response = await llm.sendMessage(question, systemPrompt);

    console.log('\n🤖 Ответ с System Prompt:');
    console.log(response);

    await llm.close();
  } catch (error) {
    console.error('❌ Ошибка:', error.message);
  }
}

// ================================
// ПРИМЕР 3: Многошаговый разговор
// ================================

async function example3_MultiTurnConversation() {
  console.log('\n' + '='.repeat(60));
  console.log('📋 Пример 3: Многошаговый разговор');
  console.log('='.repeat(60));

  const llm = new LLMWebWrapper({
    provider: 'chat-zai',
    mcpTool: 'playwright'
  });

  try {
    await llm.init();

    console.log('\n👤 Пользователь: Привет, меня зовут Алиса.');
    const response1 = await llm.sendMessage('Привет, меня зовут Алиса.');
    console.log('🤖 LLM:', response1);

    console.log('\n👤 Пользователь: Как меня зовут?');
    const response2 = await llm.sendMessage('Как меня зовут?');
    console.log('🤖 LLM:', response2);

    console.log('\n👤 Пользователь: Напиши мне функцию сортировки массива.');
    const response3 = await llm.sendMessage('Напиши мне функцию сортировки массива объектов по свойству.');
    console.log('🤖 LLM:');
    console.log(response3);

    await llm.close();
  } catch (error) {
    console.error('❌ Ошибка:', error.message);
  }
}

// ================================
// ПРИМЕР 4: Генерация кода
// ================================

async function example4_CodeGeneration() {
  console.log('\n' + '='.repeat(60));
  console.log('📋 Пример 4: Генерация кода');
  console.log('='.repeat(60));

  const llm = new LLMWebWrapper({
    provider: 'chat-zai',
    mcpTool: 'playwright'
  });

  try {
    await llm.init();

    const systemPrompt = 'Ты эксперт-программист на TypeScript. Пиши чистый, эффективный и хорошо документированный код.';
    const request = 'Напиши TypeScript функцию для сортировки массива объектов по указанному свойству.';

    const response = await llm.sendMessage(request, systemPrompt);

    console.log('\n🤖 Сгенерированный код:');
    console.log(response);

    await llm.close();
  } catch (error) {
    console.error('❌ Ошибка:', error.message);
  }
}

// ================================
// ПРИМЕР 5: Обработка ошибок с повторными попытками
// ================================

async function example5_ErrorHandlingWithRetry() {
  console.log('\n' + '='.repeat(60));
  console.log('📋 Пример 5: Обработка ошибок с retry');
  console.log('='.repeat(60));

  const llm = new LLMWebWrapper({
    provider: 'chat-zai',
    mcpTool: 'playwright',
    timeout: 10000 // Короткий timeout для демонстрации
  });

  const maxRetries = 3;
  let retryCount = 0;

  while (retryCount < maxRetries) {
    try {
      await llm.init();

      const response = await llm.sendMessage('Напиши мне сложную математическую формулу.');
      
      console.log('\n✅ Успех! Ответ:');
      console.log(response);
      
      await llm.close();
      return; // Успех - выходим
      
    } catch (error) {
      retryCount++;
      console.error(`\n❌ Попытка ${retryCount}/${maxRetries} не удалась:`, error.message);
      
      if (retryCount < maxRetries) {
        console.log(`⏳ Повторная попытка через ${retryCount * 2} секунд...`);
        await new Promise(resolve => setTimeout(resolve, retryCount * 2000));
      } else {
        console.error('⛔ Все попытки исчерпаны.');
        await llm.close();
        throw error;
      }
    }
  }
}

// ================================
// ПРИМЕР 6: Асинхронная обработка нескольких запросов
// ================================

async function example6_ConcurrentRequests() {
  console.log('\n' + '='.repeat(60));
  console.log('📋 Пример 6: Асинхронная обработка');
  console.log('='.repeat(60));

  const questions = [
    'Что такое React?',
    'Что такое TypeScript?',
    'Что такое Node.js?'
  ];

  // Создаем отдельные экземпляры для каждого запроса
  const instances = questions.map(() => 
    new LLMWebWrapper({
      provider: 'chat-zai',
      mcpTool: 'playwright'
    })
  );

  try {
    // Инициализируем все
    await Promise.all(instances.map(llm => llm.init()));

    // Отправляем все запросы параллельно
    console.log('\n📤 Отправка 3 запросов параллельно...');
    
    const responses = await Promise.all(
      instances.map((llm, index) => 
        llm.sendMessage(questions[index])
      )
    );

    // Выводим результаты
    responses.forEach((response, index) => {
      console.log(`\n📝 Вопрос ${index + 1}: ${questions[index]}`);
      console.log('🤖 Ответ:', response.substring(0, 100) + '...');
    });

    // Закрываем все
    await Promise.all(instances.map(llm => llm.close()));
    
    console.log('\n✅ Все запросы завершены успешно!');
    
  } catch (error) {
    console.error('❌ Ошибка при параллельной обработке:', error.message);
    // Закрываем все при ошибке
    await Promise.all(instances.map(llm => llm.close()));
  }
}

// ================================
// ПРИМЕР 7: Использование с Chrome DevTools
// ================================

async function example7_ChromeDevTools() {
  console.log('\n' + '='.repeat(60));
  console.log('📋 Пример 7: Chrome DevTools MCP');
  console.log('='.repeat(60));

  const llm = new LLMWebWrapper({
    provider: 'chat-zai',
    mcpTool: 'chrome-devtools', // Вместо playwright
    baseURL: 'https://chat.z.ai'
  });

  try {
    await llm.init();

    const response = await llm.sendMessage('Расскажи о преимуществах Chrome DevTools для веб-разработки.');

    console.log('\n🤖 Ответ (через Chrome DevTools):');
    console.log(response);

    await llm.close();
  } catch (error) {
    console.error('❌ Ошибка:', error.message);
  }
}

// ================================
// ЗАПУСК ВСЕХ ПРИМЕРОВ
// ================================

async function runAllExamples() {
  console.log('='.repeat(60));
  console.log('🚀 LLM Web Wrapper - Примеры использования');
  console.log('='.repeat(60));
  console.log('🐰 Ключевое слово: "Заюшь"');
  console.log('='.repeat(60));
  console.log('\n⚠️  ВАЖНО:');
  console.log('   MCP инструменты (Playwright или Chrome DevTools) должны быть');
  console.log('   настроены и доступны перед запуском этих примеров.');
  console.log('\n📝 Эти примеры используют демо-заглушки.');
  console.log('   Для реальной работы с chat.z.ai нужно:');
  console.log('   1. Настроить MCP инструменты в Cline');
  console.log('   2. Раскомментировать ПСЕВДОКОД в LLMWebWrapper.js');
  console.log('   3. Адаптировать селекторы под chat.z.ai UI');
  console.log('='.repeat(60));

  try {
    await example1_SimpleQuestion();
    await new Promise(resolve => setTimeout(resolve, 1000));
    
    await example2_WithSystemPrompt();
    await new Promise(resolve => setTimeout(resolve, 1000));
    
    await example3_MultiTurnConversation();
    await new Promise(resolve => setTimeout(resolve, 1000));
    
    await example4_CodeGeneration();
    await new Promise(resolve => setTimeout(resolve, 1000));
    
    await example5_ErrorHandlingWithRetry();
    await new Promise(resolve => setTimeout(resolve, 1000));
    
    await example6_ConcurrentRequests();
    await new Promise(resolve => setTimeout(resolve, 1000));
    
    await example7_ChromeDevTools();
    
    console.log('\n' + '='.repeat(60));
    console.log('✅ Все примеры завершены успешно!');
    console.log('='.repeat(60));
    
  } catch (error) {
    console.error('\n' + '='.repeat(60));
    console.error('❌ Ошибка при выполнении примеров:', error.message);
    console.error('='.repeat(60));
    process.exit(1);
  }
}

// ================================
// ЗАПУСК ОПРЕДЕЛЕННОГО ПРИМЕРА
// ================================

const args = process.argv.slice(2);
const exampleArg = args.find(arg => arg.startsWith('--example='));

if (exampleArg) {
  const exampleNumber = parseInt(exampleArg.split('=')[1]);
  
  switch (exampleNumber) {
    case 1: await example1_SimpleQuestion(); break;
    case 2: await example2_WithSystemPrompt(); break;
    case 3: await example3_MultiTurnConversation(); break;
    case 4: await example4_CodeGeneration(); break;
    case 5: await example5_ErrorHandlingWithRetry(); break;
    case 6: await example6_ConcurrentRequests(); break;
    case 7: await example7_ChromeDevTools(); break;
    default:
      console.log('❌ Пример не найден. Доступные: 1-7');
      process.exit(1);
  }
} else {
  // Запуск всех примеров
  runAllExamples();
}

// Экспорт для использования в других модулях
export { LLMWebWrapper };