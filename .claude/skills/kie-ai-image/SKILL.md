---
name: kie-ai-image
description: "Generate and edit images via kie.ai API. Use when creating images, editing photos, generating AI art, text-to-image, image-to-image, upscaling, background removal. Models: 4o Image, Flux Kontext, Imagen 4, Seedream, Grok Imagine, Flux-2, Qwen, Ideogram. Keywords: bild erstellen, image generate, AI art, foto bearbeiten, upscale."
---

# Kie.ai Image Generation Skill

Use this skill to generate and edit images via the kie.ai API. Requires the kie-ai-core skill for authentication and task management.

## Available Image Models

| Model | Best For | Endpoint |
|-------|----------|----------|
| **4o Image (GPT)** | High-fidelity, accurate text in images, flexible style | `/api/v1/gpt4o-image/generate` |
| **Flux Kontext Pro/Max** | Vivid scenes, subject consistency, image editing | `/api/v1/flux/kontext/generate` |
| **Google Imagen 4** | High quality Google image generation | Market API |
| **Seedream 4.5** | Creative styling, text-to-image | Market API |
| **Grok Imagine** | Text-to-image, image-to-image, upscaling | Market API |
| **Flux-2** | Pro text/image-to-image | Market API |
| **Qwen** | Image generation and editing | Market API |
| **Ideogram** | Character generation, reframing | Market API |

## Quick Model Selection Guide

- **Best quality general purpose**: 4o Image or Flux Kontext Max
- **Need text in image**: 4o Image
- **Image editing/modification**: Flux Kontext (with `inputImage`) or 4o Image (with `filesUrl` + `maskUrl`)
- **Fast & cheap**: Flux Kontext Pro, Nano Banana
- **Upscaling**: Grok Imagine Upscale, Topaz Image Upscale, Recraft Crisp Upscale
- **Background removal**: Recraft Remove Background

---

## 4o Image API

**Endpoint:** `POST https://api.kie.ai/api/v1/gpt4o-image/generate`

### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `prompt` | string | No* | Text description of desired image |
| `size` | string | **Yes** | `1:1`, `3:2`, or `2:3` |
| `filesUrl` | array | No | Up to 5 reference image URLs (.jpg, .png, .webp) |
| `maskUrl` | string | No | Mask image URL (black=modify, white=preserve) |
| `callBackUrl` | string | No | Webhook URL |
| `isEnhance` | boolean | No | Enhance prompt automatically (default: false) |
| `enableFallback` | boolean | No | Fallback to backup model on failure (default: false) |
| `fallbackModel` | string | No | `GPT_IMAGE_1` or `FLUX_MAX` (default: FLUX_MAX) |

### Example: Text-to-Image

```bash
curl -X POST "https://api.kie.ai/api/v1/gpt4o-image/generate" \
  -H "Authorization: Bearer $KIE_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "A futuristic city skyline at sunset with flying cars, photorealistic style",
    "size": "3:2"
  }'
```

### Example: Image Editing with Mask

```bash
curl -X POST "https://api.kie.ai/api/v1/gpt4o-image/generate" \
  -H "Authorization: Bearer $KIE_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "filesUrl": ["https://example.com/photo.png"],
    "maskUrl": "https://example.com/mask.png",
    "prompt": "Replace the background with a tropical beach",
    "size": "3:2"
  }'
```

---

## Flux Kontext API

**Endpoint:** `POST https://api.kie.ai/api/v1/flux/kontext/generate`

### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `prompt` | string | **Yes** | English text describing image or edits |
| `inputImage` | string | No | URL of image to edit (editing mode) |
| `model` | string | No | `flux-kontext-pro` or `flux-kontext-max` |
| `aspectRatio` | string | No | `21:9`, `16:9`, `4:3`, `1:1`, `3:4`, `9:16` (default: 16:9) |
| `outputFormat` | string | No | `jpeg` or `png` (default: jpeg) |
| `enableTranslation` | boolean | No | Auto-translate to English (default: true) |
| `safetyTolerance` | integer | No | 0-6 for generation, 0-2 for editing (default: 2) |
| `promptUpsampling` | boolean | No | Enhance prompt detail |
| `callBackUrl` | string | No | Webhook URL |

### Example: Text-to-Image

```bash
curl -X POST "https://api.kie.ai/api/v1/flux/kontext/generate" \
  -H "Authorization: Bearer $KIE_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "A serene Japanese garden with cherry blossoms and a koi pond",
    "model": "flux-kontext-max",
    "aspectRatio": "16:9",
    "outputFormat": "png"
  }'
```

### Example: Image Editing

```bash
curl -X POST "https://api.kie.ai/api/v1/flux/kontext/generate" \
  -H "Authorization: Bearer $KIE_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "Change the sky to a dramatic stormy sky with lightning",
    "inputImage": "https://example.com/landscape.jpg",
    "model": "flux-kontext-pro"
  }'
```

---

## Market API (Unified Endpoint)

For models accessed via the Market, use the unified task creation endpoint:

**Endpoint:** `POST https://api.kie.ai/api/v1/jobs/createTask`

Covers: Imagen 4, Seedream, Grok Imagine, Flux-2, Qwen, Ideogram, Recraft, Topaz, Z-Image, Nano Banana, GPT Image 1.5.

### Quick Examples (Top Models)

**Google Imagen 4:**
```bash
curl -X POST "https://api.kie.ai/api/v1/jobs/createTask" \
  -H "Authorization: Bearer $KIE_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "google/imagen-4",
    "input": {
      "prompt": "A cozy cabin in snowy mountains, warm light from windows, photorealistic",
      "aspect_ratio": "16:9"
    }
  }'
```

**Seedream 4.5:**
```bash
curl -X POST "https://api.kie.ai/api/v1/jobs/createTask" \
  -H "Authorization: Bearer $KIE_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "seedream/4.5-text-to-image",
    "input": {
      "prompt": "Abstract digital art with flowing neon colors, futuristic style",
      "aspect_ratio": "16:9"
    }
  }'
```

**Grok Imagine:**
```bash
curl -X POST "https://api.kie.ai/api/v1/jobs/createTask" \
  -H "Authorization: Bearer $KIE_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "grok-imagine/text-to-image",
    "input": {
      "prompt": "A medieval castle on a cliff at sunset, epic fantasy landscape"
    }
  }'
```

**Flux-2 Pro:**
```bash
curl -X POST "https://api.kie.ai/api/v1/jobs/createTask" \
  -H "Authorization: Bearer $KIE_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "flux2/pro-text-to-image",
    "input": {
      "prompt": "Professional product photo of a luxury watch on marble surface",
      "aspect_ratio": "1:1"
    }
  }'
```

**Qwen:**
```bash
curl -X POST "https://api.kie.ai/api/v1/jobs/createTask" \
  -H "Authorization: Bearer $KIE_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "qwen/text-to-image",
    "input": {
      "prompt": "Watercolor painting of a Venice canal with gondolas"
    }
  }'
```

Full parameter details in model-specific docs:
- Imagen 4: `https://docs.kie.ai/market/google/imagen4.md`
- Flux-2: `https://docs.kie.ai/market/flux2/pro-text-to-image.md`
- Grok Imagine: `https://docs.kie.ai/market/grok-imagine/text-to-image.md`
- Seedream: `https://docs.kie.ai/market/seedream/4.5-text-to-image.md`
- Qwen: `https://docs.kie.ai/market/qwen/text-to-image.md`

---

## Model-Specific Prompting Guide

Each model responds differently to prompts. Use the right style for the right model:

### 4o Image
- **Prompt style:** Rich, conversational natural language. Full sentences, not keyword lists.
- **Strength:** Complex multi-object compositions, text rendering (put text in quotes), flexible styles.
- **Sweet spot:** "Create from scratch" generation; concept art, logos, infographics.
- **Aspect ratios:** Only 1:1, 3:2, 2:3. For 16:9 video: use 3:2 and prompt with extra side space for cropping.
- **Tip:** Supports conversational refinement. Can iterate via follow-up prompts.
- **Weakness:** Image editing can introduce unwanted color shifts and background changes.

### Flux Kontext
- **Prompt style:** Short, surgical edit instructions. 1-3 specific changes per prompt.
- **Strength:** Preserving identity/context during edits, typography, character consistency.
- **Sweet spot:** Iterative editing, product photography, style transfer, 16:9 natively.
- **Tip:** Upload a reference and describe only what to change: "Change the background to beach sunset. Keep everything else identical."
- **Weakness:** Complex multi-object scenes from scratch. Use 4o Image or Imagen 4 for that.

### Imagen 4
- **Prompt style:** Detailed descriptive prompts. Photography terminology works exceptionally well.
- **Strength:** Photorealism, fine detail (fabric texture, water droplets, fur), text-in-image (max 25 chars, 2-3 phrases).
- **Tip:** Include camera specs: "shot with 85mm lens, f/1.4, shallow depth of field, golden hour."
- **Negative prompts:** Keep to 5-10 plain words. No "no" or "avoid" -- just list unwanted elements.

### Seedream 4.5
- **Prompt style:** Concise natural language. Subject + action + environment, then short-phrase aesthetics.
- **Strength:** Strong prompt comprehension with less description needed.
- **Tip:** Front-load important concepts (weights earlier tokens more). Use quotes "" for text rendering.
- **Weakness:** Overly complex prompts degrade output quality. Keep it concise.

---

## Negative Prompt Guide

Use negative prompts to exclude unwanted elements (where the model supports them).

### Universal Starter
```
blurry, pixelated, low resolution, grainy, distorted, watermark, text, logo,
signature, compression artifacts, jpeg artifacts
```

### For Human Figures
```
extra digits, extra arms, extra hands, fused fingers, malformed limbs,
mutated hands, deformed face, asymmetric eyes, cross-eyed, extra limbs
```

### For Photorealism (exclude illustration styles)
```
cartoon, illustration, drawing, painting, CGI, 3D render, anime,
sketch, digital art, flat colors
```

### Negative Prompt Rules
1. Be specific, not vague: "blurred face" works, "bad quality" does not
2. Stack synonyms for emphasis: "blurry, out of focus, soft focus, unfocused"
3. Maximum 10-15 focused terms (too many washes out the image)
4. Never contradict the positive prompt
5. For Imagen 4: describe plainly without "no" or "avoid", just list the elements

---

## Prompt Tips for Best Results

1. Use the structured formula: [Subject + Action] + [Environment] + [Lighting] + [Camera] + [Style] + [Color Palette] + [Mood] + [Quality]
2. 50-100 words consistently outperform 10-20 words for complex scenes
3. Specify camera angle with film terminology: "low angle shot", "bird's eye view", "medium close-up"
4. For text in images, use 4o Image and put the text in quotes within the prompt
5. For editing, describe what to change, not what to keep
6. For video frames: imply motion ("mid-stride"), add film grain, use off-center framing
7. Avoid vague adjectives: use "atmospheric", "gritty" instead of "beautiful", "nice"

---

## Asset Manifest Tracking

**MANDATORY:** After every successful image download, register the asset in `assets/manifest.json`.

Run this command after each successful download, replacing the UPPERCASE placeholders with actual values:

```bash
node -e "
const fs = require('fs');
const p = 'assets/manifest.json';
const m = JSON.parse(fs.readFileSync(p, 'utf8'));
const entry = {
  id: 'img-' + String(m.assets.filter(a=>a.type==='image').length+1).padStart(3,'0'),
  type: 'image',
  filename: 'FILENAME',
  prompt: PROMPT_JSON_STRING,
  model: 'MODEL_NAME',
  parameters: { size: 'SIZE_OR_RATIO', endpoint: 'ENDPOINT_USED' },
  created_at: new Date().toISOString(),
  scene_id: SCENE_NUMBER,
  version: 1
};
const existing = m.assets.filter(a => a.prompt === entry.prompt && a.model === entry.model && !a.superseded_by);
if (existing.length > 0) {
  const prev = existing[existing.length - 1];
  entry.version = prev.version + 1;
  entry.id = 'img-' + String(m.assets.filter(a=>a.type==='image').length+1).padStart(3,'0');
  prev.superseded_by = entry.id;
}
m.assets.push(entry);
fs.writeFileSync(p, JSON.stringify(m, null, 2));
console.log('Manifest updated: ' + entry.id + ' (v' + entry.version + ')');
"
```

**Placeholder guide:**
- `FILENAME`: Relative path, e.g. `assets/images/scene-01.png`
- `PROMPT_JSON_STRING`: The prompt as a JSON string (use `JSON.stringify()` if it contains quotes)
- `MODEL_NAME`: e.g. `4o Image`, `Flux Kontext Max`, `Imagen 4`, `Seedream 4.5`
- `SIZE_OR_RATIO`: e.g. `3:2`, `16:9`, `1:1`
- `ENDPOINT_USED`: The API endpoint that was called
- `SCENE_NUMBER`: Integer scene ID from SCENES.md
