---
name: LLM
description: Implement LLM chat completions using standard APIs (OpenAI, Anthropic, etc.). This is a public API version that works without proprietary SDKs. Use for chatbots, AI assistants, or text generation.
license: MIT
---

# LLM Skill (Public API Version)

This skill guides implementation of LLM chat completions using public APIs (OpenAI, Anthropic Claude, etc.), enabling conversational AI and text generation capabilities.

## Skills Path

**Skill Location**: `{project_path}/.cline/skills/LLM-openai`

**Note**: This is an alternative version of the LLM skill that works with public APIs instead of the proprietary z-ai-web-dev-sdk.

## Overview

The LLM skill allows you to build applications that leverage large language models using public APIs. This version works with standard HTTP requests and can be used with any LLM provider.

**Supported Providers**:
- OpenAI (GPT-4, GPT-3.5-turbo)
- Anthropic (Claude 3, Claude 3.5 Sonnet)
- Any OpenAI-compatible API (local models, Azure OpenAI, etc.)

## Prerequisites

### Required Packages

```bash
npm install openai @anthropic-ai/sdk dotenv
```

### Environment Variables

```env
# OpenAI
OPENAI_API_KEY=sk-...
OPENAI_MODEL=gpt-4o

# Anthropic Claude
ANTHROPIC_API_KEY=sk-ant-...
ANTHROPIC_MODEL=claude-3-5-sonnet-20241022

# Optional: Custom base URL
OPENAI_BASE_URL=https://api.openai.com/v1
```

## Basic Chat Completions

### Using OpenAI

```javascript
import OpenAI from 'openai';
import dotenv from 'dotenv';

dotenv.config();

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY
});

async function chatWithOpenAI(messages) {
  const completion = await openai.chat.completions.create({
    model: process.env.OPENAI_MODEL || 'gpt-4o',
    messages: messages,
    temperature: 0.7,
    max_tokens: 1000
  });

  return completion.choices[0]?.message?.content;
}

// Usage
const response = await chatWithOpenAI([
  {
    role: 'user',
    content: 'What is the capital of France?'
  }
]);

console.log('Response:', response);
```

### Using Anthropic Claude

```javascript
import Anthropic from '@anthropic-ai/sdk';
import dotenv from 'dotenv';

dotenv.config();

const anthropic = new Anthropic({
  apiKey: process.env.ANTHROPIC_API_KEY
});

async function chatWithClaude(messages) {
  const completion = await anthropic.messages.create({
    model: process.env.ANTHROPIC_MODEL || 'claude-3-5-sonnet-20241022',
    max_tokens: 1000,
    messages: messages
  });

  return completion.content[0]?.text;
}

// Usage
const response = await chatWithClaude([
  {
    role: 'user',
    content: 'What is the capital of France?'
  }
]);

console.log('Response:', response);
```

### Multi-Provider Support

```javascript
class LLMProvider {
  constructor(provider = 'openai') {
    this.provider = provider;
    this.client = null;
    this.initialize();
  }

  initialize() {
    if (this.provider === 'openai') {
      const OpenAI = require('openai');
      this.client = new OpenAI({
        apiKey: process.env.OPENAI_API_KEY
      });
    } else if (this.provider === 'anthropic') {
      const Anthropic = require('@anthropic-ai/sdk');
      this.client = new Anthropic({
        apiKey: process.env.ANTHROPIC_API_KEY
      });
    } else {
      throw new Error(`Unsupported provider: ${this.provider}`);
    }
  }

  async chat(messages, systemPrompt = null) {
    if (this.provider === 'openai') {
      const openaiMessages = systemPrompt 
        ? [{ role: 'system', content: systemPrompt }, ...messages]
        : messages;

      const completion = await this.client.chat.completions.create({
        model: process.env.OPENAI_MODEL || 'gpt-4o',
        messages: openaiMessages,
        temperature: 0.7,
        max_tokens: 1000
      });

      return completion.choices[0]?.message?.content;
    } 
    else if (this.provider === 'anthropic') {
      const anthropicMessages = systemPrompt
        ? messages.map(m => ({ ...m, role: 'user' }))
        : messages;

      const completion = await this.client.messages.create({
        model: process.env.ANTHROPIC_MODEL || 'claude-3-5-sonnet-20241022',
        max_tokens: 1000,
        system: systemPrompt,
        messages: anthropicMessages
      });

      return completion.content[0]?.text;
    }
  }
}

// Usage
const openaiLLM = new LLMProvider('openai');
const claudeLLM = new LLMProvider('anthropic');

const openaiResponse = await openaiLLM.chat([
  { role: 'user', content: 'Hello!' }
]);

const claudeResponse = await claudeLLM.chat([
  { role: 'user', content: 'Hello!' }
]);
```

## Multi-turn Conversations

### Conversation Manager

```javascript
class ConversationManager {
  constructor(provider = 'openai', systemPrompt = 'You are a helpful assistant.') {
    this.provider = provider;
    this.client = null;
    this.messages = [
      {
        role: 'system',
        content: systemPrompt
      }
    ];
    this.initialize();
  }

  initialize() {
    if (this.provider === 'openai') {
      const OpenAI = require('openai');
      this.client = new OpenAI({
        apiKey: process.env.OPENAI_API_KEY
      });
    } else if (this.provider === 'anthropic') {
      const Anthropic = require('@anthropic-ai/sdk');
      this.client = new Anthropic({
        apiKey: process.env.ANTHROPIC_API_KEY
      });
    }
  }

  async sendMessage(userMessage) {
    // Add user message to history
    this.messages.push({
      role: 'user',
      content: userMessage
    });

    let assistantResponse;

    if (this.provider === 'openai') {
      const completion = await this.client.chat.completions.create({
        model: process.env.OPENAI_MODEL || 'gpt-4o',
        messages: this.messages,
        temperature: 0.7,
        max_tokens: 1000
      });

      assistantResponse = completion.choices[0]?.message?.content;
    } 
    else if (this.provider === 'anthropic') {
      const completion = await this.client.messages.create({
        model: process.env.ANTHROPIC_MODEL || 'claude-3-5-sonnet-20241022',
        max_tokens: 1000,
        messages: this.messages.map(m => ({ role: m.role === 'assistant' ? 'assistant' : 'user', content: m.content }))
      });

      assistantResponse = completion.content[0]?.text;
    }

    // Add assistant response to history
    this.messages.push({
      role: 'assistant',
      content: assistantResponse
    });

    return assistantResponse;
  }

  getHistory() {
    return this.messages;
  }

  clearHistory(systemPrompt = 'You are a helpful assistant.') {
    this.messages = [
      {
        role: 'system',
        content: systemPrompt
      }
    ];
  }

  getMessageCount() {
    // Subtract 1 for system message
    return this.messages.length - 1;
  }
}

// Usage
const conversation = new ConversationManager('openai');

const response1 = await conversation.sendMessage('Hi, my name is John.');
console.log('AI:', response1);

const response2 = await conversation.sendMessage('What is my name?');
console.log('AI:', response2); // Should remember name is John

console.log('Total messages:', conversation.getMessageCount());
```

## Express.js Chatbot API

```javascript
import express from 'express';
import dotenv from 'dotenv';

dotenv.config();

const app = express();
app.use(express.json());

// Store conversations in memory (use database in production)
const conversations = new Map();

const provider = process.env.LLM_PROVIDER || 'openai';

async function initLLM() {
  if (provider === 'openai') {
    const OpenAI = require('openai');
    return new OpenAI({
      apiKey: process.env.OPENAI_API_KEY
    });
  } else if (provider === 'anthropic') {
    const Anthropic = require('@anthropic-ai/sdk');
    return new Anthropic({
      apiKey: process.env.ANTHROPIC_API_KEY
    });
  }
}

let llmClient;

initLLM().then(client => {
  llmClient = client;
});

app.post('/api/chat', async (req, res) => {
  try {
    const { sessionId, message, systemPrompt } = req.body;

    if (!message) {
      return res.status(400).json({ error: 'Message is required' });
    }

    // Get or create conversation history
    let history = conversations.get(sessionId) || [
      {
        role: 'system',
        content: systemPrompt || 'You are a helpful assistant.'
      }
    ];

    // Add user message
    history.push({
      role: 'user',
      content: message
    });

    let aiResponse;

    if (provider === 'openai') {
      const completion = await llmClient.chat.completions.create({
        model: process.env.OPENAI_MODEL || 'gpt-4o',
        messages: history,
        temperature: 0.7,
        max_tokens: 1000
      });

      aiResponse = completion.choices[0]?.message?.content;
    } 
    else if (provider === 'anthropic') {
      const completion = await llmClient.messages.create({
        model: process.env.ANTHROPIC_MODEL || 'claude-3-5-sonnet-20241022',
        max_tokens: 1000,
        system: history[0]?.content,
        messages: history.slice(1).map(m => ({ role: m.role === 'assistant' ? 'assistant' : 'user', content: m.content }))
      });

      aiResponse = completion.content[0]?.text;
    }

    // Add AI response to history
    history.push({
      role: 'assistant',
      content: aiResponse
    });

    // Save updated history
    conversations.set(sessionId, history);

    res.json({
      success: true,
      response: aiResponse,
      messageCount: history.length - 1,
      provider: provider
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
});

app.delete('/api/chat/:sessionId', (req, res) => {
  const { sessionId } = req.params;
  conversations.delete(sessionId);
  res.json({ success: true, message: 'Conversation cleared' });
});

initLLM().then(() => {
  app.listen(3000, () => {
    console.log(`Chatbot API running on port 3000 using ${provider}`);
  });
});
```

## Streaming Responses

### Streaming with OpenAI

```javascript
import OpenAI from 'openai';

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY
});

async function streamChat(messages) {
  const stream = await openai.chat.completions.create({
    model: process.env.OPENAI_MODEL || 'gpt-4o',
    messages: messages,
    stream: true,
    temperature: 0.7
  });

  for await (const chunk of stream) {
    const content = chunk.choices[0]?.delta?.content || '';
    process.stdout.write(content);
  }

  process.stdout.write('\n');
}

// Usage
streamChat([
  {
    role: 'user',
    content: 'Tell me a short story about a robot'
  }
]);
```

### Streaming with Anthropic

```javascript
import Anthropic from '@anthropic-ai/sdk';

const anthropic = new Anthropic({
  apiKey: process.env.ANTHROPIC_API_KEY
});

async function streamChatWithClaude(messages) {
  const stream = await anthropic.messages.create({
    model: process.env.ANTHROPIC_MODEL || 'claude-3-5-sonnet-20241022',
    max_tokens: 1000,
    messages: messages,
    stream: true
  });

  for await (const event of stream) {
    if (event.type === 'content_block_delta' && event.delta?.text) {
      process.stdout.write(event.delta.text);
    }
  }

  process.stdout.write('\n');
}

// Usage
streamChatWithClaude([
  {
    role: 'user',
    content: 'Tell me a short story about a robot'
  }
]);
```

## Advanced Use Cases

### Content Generator

```javascript
class ContentGenerator {
  constructor(provider = 'openai') {
    this.provider = provider;
    this.client = null;
    this.initialize();
  }

  initialize() {
    if (this.provider === 'openai') {
      const OpenAI = require('openai');
      this.client = new OpenAI({
        apiKey: process.env.OPENAI_KEY
      });
    } else if (this.provider === 'anthropic') {
      const Anthropic = require('@anthropic-ai/sdk');
      this.client = new Anthropic({
        apiKey: process.env.ANTHROPIC_KEY
      });
    }
  }

  async generateBlogPost(topic, tone = 'professional') {
    const prompt = `You are a professional content writer. Write in a ${tone} tone. Write a blog post about: ${topic}. Include an introduction, main points, and conclusion.`;

    if (this.provider === 'openai') {
      const completion = await this.client.chat.completions.create({
        model: process.env.OPENAI_MODEL || 'gpt-4o',
        messages: [{ role: 'user', content: prompt }],
        temperature: 0.7,
        max_tokens: 1000
      });

      return completion.choices[0]?.message?.content;
    } 
    else if (this.provider === 'anthropic') {
      const completion = await this.client.messages.create({
        model: process.env.ANTHROPIC_MODEL || 'claude-3-5-sonnet-20241022',
        max_tokens: 1000,
        messages: [{ role: 'user', content: prompt }]
      });

      return completion.content[0]?.text;
    }
  }
}

// Usage
const generator = new ContentGenerator('openai');
const blogPost = await generator.generateBlogPost(
  'The Future of Artificial Intelligence',
  'informative'
);
console.log('Blog Post:', blogPost);
```

## Best Practices

### 1. Error Handling

```javascript
async function safeChat(messages, provider = 'openai', retries = 3) {
  let lastError;

  for (let attempt = 1; attempt <= retries; attempt++) {
    try {
      let response;

      if (provider === 'openai') {
        const OpenAI = require('openai');
        const openai = new OpenAI({
          apiKey: process.env.OPENAI_API_KEY
        });

        const completion = await openai.chat.completions.create({
          model: process.env.OPENAI_MODEL || 'gpt-4o',
          messages: messages
        });

        response = completion.choices[0]?.message?.content;
      } 
      else if (provider === 'anthropic') {
        const Anthropic = require('@anthropic-ai/sdk');
        const anthropic = new Anthropic({
          apiKey: process.env.ANTHROPIC_API_KEY
        });

        const completion = await anthropic.messages.create({
          model: process.env.ANTHROPIC_MODEL || 'claude-3-5-sonnet-20241022',
          max_tokens: 1000,
          messages: messages
        });

        response = completion.content[0]?.text;
      }

      if (!response || response.trim().length === 0) {
        throw new Error('Empty response from AI');
      }

      return {
        success: true,
        content: response,
        attempts: attempt
      };
    } catch (error) {
      lastError = error;
      console.error(`Attempt ${attempt} failed:`, error.message);

      if (attempt < retries) {
        await new Promise(resolve => setTimeout(resolve, 1000 * attempt));
      }
    }
  }

  return {
    success: false,
    error: lastError.message,
    attempts: retries
  };
}
```

### 2. Context Management

```javascript
class ManagedConversation {
  constructor(provider = 'openai', maxMessages = 20) {
    this.provider = provider;
    this.maxMessages = maxMessages;
    this.systemPrompt = '';
    this.messages = [];
    this.client = null;
    this.initialize();
  }

  initialize() {
    if (this.provider === 'openai') {
      const OpenAI = require('openai');
      this.client = new OpenAI({
        apiKey: process.env.OPENAI_API_KEY
      });
    } else if (this.provider === 'anthropic') {
      const Anthropic = require('@anthropic-ai/sdk');
      this.client = new Anthropic({
        apiKey: process.env.ANTHROPIC_API_KEY
      });
    }
  }

  async initialize(systemPrompt) {
    this.systemPrompt = systemPrompt;
    this.messages = [
      {
        role: 'system',
        content: systemPrompt
      }
    ];
  }

  async chat(userMessage) {
    this.messages.push({
      role: 'user',
      content: userMessage
    });

    // Trim old messages if exceeding limit
    if (this.messages.length > this.maxMessages) {
      this.messages = [
        this.messages[0],
        ...this.messages.slice(-(this.maxMessages - 1))
      ];
    }

    let response;

    if (this.provider === 'openai') {
      const completion = await this.client.chat.completions.create({
        model: process.env.OPENAI_MODEL || 'gpt-4o',
        messages: this.messages
      });

      response = completion.choices[0]?.message?.content;
    } 
    else if (this.provider === 'anthropic') {
      const completion = await this.client.messages.create({
        model: process.env.ANTHROPIC_MODEL || 'claude-3-5-sonnet-20241022',
        max_tokens: 1000,
        system: this.messages[0]?.content,
        messages: this.messages.slice(1).map(m => ({ role: m.role === 'assistant' ? 'assistant' : 'user', content: m.content }))
      });

      response = completion.content[0]?.text;
    }

    this.messages.push({
      role: 'assistant',
      content: response
    });

    return response;
  }
}
```

## Common Use Cases

1. **Chatbots & Virtual Assistants**: Build conversational interfaces
2. **Content Generation**: Articles, product descriptions, marketing copy
3. **Code Assistance**: Generate, explain, and debug code
4. **Data Analysis**: Analyze and summarize complex data
5. **Translation**: Translate text between languages
6. **Email Automation**: Generate professional email responses
7. **Creative Writing**: Stories, poetry, creative content

## Troubleshooting

**Issue**: API key not found
- **Solution**: Ensure OPENAI_API_KEY or ANTHROPIC_API_KEY is set in environment variables

**Issue**: Rate limiting errors
- **Solution**: Implement retry logic with exponential backoff

**Issue**: Context getting too long
- **Solution**: Trim old messages or use context window management

**Issue**: Model not found
- **Solution**: Check that model name is correct and available

## Security Considerations

1. **API Key Protection**: Never expose API keys in client-side code
2. **Input Validation**: Validate and sanitize user input
3. **Rate Limiting**: Implement rate limits to prevent abuse
4. **Content Filtering**: Filter sensitive or inappropriate content
5. **Session Management**: Implement proper session handling and cleanup

## Comparison: z-ai-web-dev-sdk vs Public APIs

| Feature | z-ai-web-dev-sdk | Public APIs |
|----------|-------------------|---------------|
| Availability | Proprietary, internal | Public, accessible to all |
| Installation | Pre-installed in AIRules | `npm install openai @anthropic-ai/sdk` |
| API Keys | Managed internally | User manages own keys |
| Providers | Fixed | Multiple (OpenAI, Anthropic, etc.) |
| Flexibility | Limited | High (any OpenAI-compatible API) |
| Cost | Internal pricing | User pays provider directly |

## Migration from z-ai-web-dev-sdk

### Quick Migration Guide

```javascript
// OLD (z-ai-web-dev-sdk)
import ZAI from 'z-ai-web-dev-sdk';
const zai = await ZAI.create();
const completion = await zai.chat.completions.create({
  messages: messages,
  thinking: { type: 'disabled' }
});

// NEW (OpenAI)
import OpenAI from 'openai';
const openai = new OpenAI({ apiKey: process.env.OPENAI_API_KEY });
const completion = await openai.chat.completions.create({
  model: 'gpt-4o',
  messages: messages
});
```

## Remember

- Use public APIs (OpenAI, Anthropic) instead of proprietary SDK
- Install required packages: `npm install openai @anthropic-ai/sdk dotenv`
- Set API keys in environment variables
- Implement proper error handling and retries
- Manage conversation history to avoid token limits
- Choose provider based on your needs and budget