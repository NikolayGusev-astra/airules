const ZAI = require("z-ai-web-dev-sdk");

async function main(prompt) {
  const startTime = Date.now();
  console.log(`[${new Date().toISOString()}] Sending prompt: "${prompt}"`);
  
  try {
    const zai = await ZAI.create();

    const messages = [
      {
        role: "assistant",
        content: "Hi, I'm a helpful assistant."
      },
      {
        role: "user",
        content: prompt,
      },
    ];

    const response = await zai.chat.completions.create({
      messages,
      stream: false,
      thinking: { type: "disabled" },
    });

    const reply = response.choices?.[0]?.message?.content;
    const endTime = Date.now();
    const duration = ((endTime - startTime) / 1000).toFixed(2);
    
    console.log(`\n[${new Date().toISOString()}] Response received in ${duration}s`);
    console.log("\n=== AI Response ===");
    console.log(reply || JSON.stringify(response, null, 2));
    console.log("====================\n");
    
    return reply;
  } catch (err) {
    const endTime = Date.now();
    const duration = ((endTime - startTime) / 1000).toFixed(2);
    console.error(`\n[${new Date().toISOString()}] Error after ${duration}s:`, err?.message || err);
  }
}

// Run with command line argument or default
const prompt = process.argv[2] || "напиши привет";
main(prompt);