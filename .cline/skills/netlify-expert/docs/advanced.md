# 🚀 Продвинутые паттерны для Netlify Expert Skill

---

## ⚡ Netlify Edge Functions

```javascript
// netlify/edge-functions/geo.ts
export default async (request, context) => {
  const country = request.geo?.country?.code || 'US';
  
  return new Response(JSON.stringify({ country }), {
    headers: { 'content-type': 'application/json' }
  });
}
```

## 🌍 Forms Handling

```html
<form name="contact" method="POST" data-netlify="true">
  <input type="text" name="name" />
  <input type="email" name="email" />
  <button type="submit">Send</button>
</form>
```

## 📦 Split Testing

```yaml
[[context.deploy-preview]]
  command = "echo 'Deploy Preview'"