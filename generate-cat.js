import ZAI from 'z-ai-web-dev-sdk';
import fs from 'fs';

async function generateCuteCat() {
  console.log('Initializing image generation...');
  
  const zai = await ZAI.create();
  console.log('✓ ZAI SDK initialized');

  const prompt = 'A cute cartoon cat, big eyes, fluffy fur, friendly expression, colorful, cartoon style, high quality, detailed';
  const size = '1024x1024';
  
  console.log(`Generating image with prompt: "${prompt}"`);
  
  const response = await zai.images.generations.create({
    prompt: prompt,
    size: size
  });

  console.log('✓ Image generated successfully');

  const imageBase64 = response.data[0].base64;
  const buffer = Buffer.from(imageBase64, 'base64');
  
  const outputPath = './cute-cat.png';
  fs.writeFileSync(outputPath, buffer);
  
  console.log(`✓ Image saved to: ${outputPath}`);
  console.log(`✓ File size: ${buffer.length} bytes`);
  
  return outputPath;
}

generateCuteCat()
  .then(() => {
    console.log('\n✅ Image generation completed!');
  })
  .catch((error) => {
    console.error('\n❌ Error generating image:', error.message);
    process.exit(1);
  });