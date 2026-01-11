/**
 * LLM Skill Example - Public API Version
 * 
 * This example demonstrates how to use LLM with public APIs (OpenAI, Anthropic)
 * instead of proprietary z-ai-web-dev-sdk.
 */

import dotenv from 'dotenv';

// Load environment variables
dotenv.config();

// Configuration
const PROVIDER = process.env.LLM_PROVIDER || 'openai';
const OPENAI_API_KEY = process.env.OPENAI_API_KEY;
const ANTHROPIC_API_KEY = process.env.ANTHROPIC_API_KEY;
const OPENAI_MODEL = process.env.OPENAI_MODEL || 'gpt-4o';
const ANTHROPIC_MODEL = process.env.ANTHROPIC_MODEL || 'claude-3-5-sonnet-20241022';

// Check if API keys are set
if (!OPENAI_API_KEY && !ANTHROPIC_API_KEY) {
  console.error('❌ Error: No API key found!');
  console.error('Please set either OPENAI_API_KEY or ANTHROPIC_API_KEY in your .env file.');
  console.log('\nExample .env file:');
  console.log('OPENAI_API_KEY=sk-...');
  console.log('# OR');
  console.log('ANTHROPIC_API_KEY=sk-ant-...');
  process.exit(1);
}

// Simple chat function using OpenAI
async function chatWithOpenAI(messages, systemPrompt = null) {
  try {
    const { default: OpenAI } = await import('openai');
    const openai = new OpenAI({
      apiKey: OPENAI_API_KEY
    });

    const openaiMessages = systemPrompt
      ? [{ role: 'system', content: systemPrompt }, ...messages]
      : messages;

    console.log(`\n🔵 Using OpenAI API (${OPENAI_MODEL})`);

    const completion = await openai.chat.completions.create({
      model: OPENAI_MODEL,
      messages: openaiMessages,
      temperature: 0.7,
      max_tokens: 1000
    });

    return completion.choices[0]?.message?.content;
  } catch (error) {
    console.error('❌ OpenAI Error:', error.message);
    throw error;
  }
}

// Simple chat function using Anthropic Claude
async function chatWithClaude(messages, systemPrompt = null) {
  try {
    const { default: Anthropic } = await import('@anthropic-ai/sdk');
    const anthropic = new Anthropic({
      apiKey: ANTHROPIC_API_KEY
    });

    console.log(`\n🟣 Using Anthropic API (${ANTHROPIC_MODEL})`);

    const completion = await anthropic.messages.create({
      model: ANTHROPIC_MODEL,
      max_tokens: 1000,
      system: systemPrompt || undefined,
      messages: messages
    });

    return completion.content[0]?.text;
  } catch (error) {
    console.error('❌ Anthropic Error:', error.message);
    throw error;
  }
}

// Multi-provider wrapper
async function chat(messages, systemPrompt = null) {
  if (PROVIDER === 'openai') {
    if (!OPENAI_API_KEY) {
      throw new Error('OPENAI_API_KEY not set in environment variables');
    }
    return await chatWithOpenAI(messages, systemPrompt);
  } else if (PROVIDER === 'anthropic') {
    if (!ANTHROPIC_API_KEY) {
      throw new Error('ANTHROPIC_API_KEY not set in environment variables');
    }
    return await chatWithClaude(messages, systemPrompt);
  } else {
    throw new Error(`Unsupported provider: ${PROVIDER}. Use 'openai' or 'anthropic'.`);
  }
}

// Example 1: Simple question
async function example1_SimpleQuestion() {
  console.log('\n=== Example 1: Simple Question ===');
  
  const messages = [
    {
      role: 'user',
      content: 'What is the capital of France?'
    }
  ];

  const response = await chat(messages);
  console.log('\n🤖 Response:', response);
}

// Example 2: With system prompt
async function example2_WithSystemPrompt() {
  console.log('\n=== Example 2: With System Prompt ===');
  
  const systemPrompt = 'You are a helpful programming tutor. Explain concepts clearly and concisely.';
  const messages = [
    {
      role: 'user',
      content: 'What is the difference between let and const in JavaScript?'
    }
  ];

  const response = await chat(messages, systemPrompt);
  console.log('\n🤖 Response:', response);
}

// Example 3: Multi-turn conversation
async function example3_MultiTurnConversation() {
  console.log('\n=== Example 3: Multi-turn Conversation ===');
  
  const systemPrompt = 'You are a helpful assistant.';
  let messages = [
    { role: 'system', content: systemPrompt }
  ];

  // Turn 1
  console.log('\n👤 User: Hi, my name is Alice.');
  messages.push({ role: 'user', content: 'Hi, my name is Alice.' });
  
  const response1 = await chat(messages);
  console.log('🤖 AI:', response1);
  messages.push({ role: 'assistant', content: response1 });

  // Turn 2
  console.log('\n👤 User: What is my name?');
  messages.push({ role: 'user', content: 'What is my name?' });
  
  const response2 = await chat(messages);
  console.log('🤖 AI:', response2);
}

// Example 4: Code generation
async function example4_CodeGeneration() {
  console.log('\n=== Example 4: Code Generation ===');
  
  const systemPrompt = 'You are an expert TypeScript programmer. Write clean, efficient, and well-commented code.';
  const messages = [
    {
      role: 'user',
      content: 'Write a TypeScript function that sorts an array of objects by a specified property.'
    }
  ];

  const response = await chat(messages, systemPrompt);
  console.log('\n🤖 Response:');
  console.log(response);
}

// Example 5: Streaming response (OpenAI only)
async function example5_Streaming() {
  console.log('\n=== Example 5: Streaming Response (OpenAI) ===');
  
  if (PROVIDER !== 'openai') {
    console.log('⚠️ Streaming is only implemented for OpenAI in this example.');
    return;
  }

  try {
    const { default: OpenAI } = await import('openai');
    const openai = new OpenAI({
      apiKey: OPENAI_API_KEY
    });

    const messages = [
      {
        role: 'user',
        content: 'Tell me a short story about a robot learning to paint.'
      }
    ];

    console.log('\n👤 User:', messages[0].content);
    console.log('\n🤖 AI (streaming): ');

    const stream = await openai.chat.completions.create({
      model: OPENAI_MODEL,
      messages: messages,
      stream: true,
      temperature: 0.7
    });

    for await (const chunk of stream) {
      const content = chunk.choices[0]?.delta?.content || '';
      process.stdout.write(content);
    }
    process.stdout.write('\n');
  } catch (error) {
    console.error('❌ Streaming Error:', error.message);
  }
}

// Run examples
async function runExamples() {
  console.log('='.repeat(60));
  console.log('🚀 LLM Skill - Public API Version');
  console.log('='.repeat(60));
  console.log(`\n📋 Provider: ${PROVIDER}`);
  
  try {
    await example1_SimpleQuestion();
    await example2_WithSystemPrompt();
    await example3_MultiTurnConversation();
    await example4_CodeGeneration();
    await example5_Streaming();
    
    console.log('\n' + '='.repeat(60));
    console.log('✅ All examples completed successfully!');
    console.log('='.repeat(60));
  } catch (error) {
    console.error('\n' + '='.repeat(60));
    console.error('❌ Example failed:', error.message);
    console.error('='.repeat(60));
    process.exit(1);
  }
}

// Run if executed directly
if (import.meta.url === `file://${process.argv[1]}`) {
  runExamples();
}

// Export for use in other modules
export { chat, chatWithOpenAI, chatWithClaude };