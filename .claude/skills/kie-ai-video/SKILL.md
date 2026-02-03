---
name: kie-ai-video
description: "Generate videos via kie.ai API. Use when creating video clips, animating images, text-to-video, image-to-video, video editing, video extension, video upscaling. Models: Veo 3.1, Runway, Kling, Sora 2, Hailuo, Wan, Bytedance Seedance. Keywords: video erstellen, clip generieren, animate, text-to-video, image-to-video."
---

# Kie.ai Video Generation Skill

Use this skill to generate videos via the kie.ai API. Requires the kie-ai-core skill for authentication and task management.

## Available Video Models

| Model | Best For | Endpoint |
|-------|----------|----------|
| **Veo 3.1** | Cinematic quality, audio sync, 1080p native | `/api/v1/veo/generate` |
| **Veo 3.1 Fast** | Faster/cheaper Veo rendering | `/api/v1/veo/generate` (model: `veo3_fast`) |
| **Runway AI Video** | Text/image-to-video, 720p/1080p, 5-10s | `/api/v1/runway/generate` |
| **Runway Aleph** | Multi-task editing, add/remove objects, restyle | `/api/v1/runway/aleph/generate` |
| **Kling 2.1-2.6** | Text/image-to-video, avatars, motion control | Market API |
| **Sora 2 / Sora 2 Pro** | OpenAI video generation, characters | Market API |
| **Hailuo 02/2.3** | Text/image-to-video, standard & pro tiers | Market API |
| **Bytedance Seedance** | Fast video generation | Market API |
| **Wan 2.2-2.6** | Text/image/video-to-video, speech-to-video | Market API |
| **Grok Imagine Video** | Text/image-to-video | Market API |

## Quick Model Selection Guide

- **Highest quality**: Veo 3.1 (quality mode) or Sora 2 Pro
- **Best value**: Veo 3.1 Fast or Hailuo Standard
- **With audio**: Veo 3.1 (native audio sync)
- **Image-to-video (animate an image)**: Runway, Kling, Wan 2.6
- **Video editing/restyling**: Runway Aleph
- **Video extension**: Runway Extend, Veo Extend
- **Video upscaling**: Topaz Video Upscale
- **Character consistency**: Sora 2 Characters
- **Fast turnaround**: Veo 3.1 Fast, Bytedance V1 Lite

---

## Veo 3.1 API

**Endpoint:** `POST https://api.kie.ai/api/v1/veo/generate`

### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `prompt` | string | **Yes** | Video content description |
| `model` | string | No | `veo3` (quality) or `veo3_fast` (default: veo3_fast) |
| `generationType` | string | No | `TEXT_2_VIDEO`, `FIRST_AND_LAST_FRAMES_2_VIDEO`, `REFERENCE_2_VIDEO` |
| `imageUrls` | array | No | 1-2 image URLs for image-to-video modes |
| `aspect_ratio` | string | No | `16:9`, `9:16`, `Auto` (default: 16:9) |
| `seeds` | integer | No | 10000-99999 for reproducible results |
| `callBackUrl` | string | No | Webhook URL |
| `enableTranslation` | boolean | No | Auto-translate to English (default: true) |
| `watermark` | string | No | Watermark text |

### Generation Types

- **TEXT_2_VIDEO**: Prompt only, no images needed
- **FIRST_AND_LAST_FRAMES_2_VIDEO**: Provide 2 images as first/last frames
- **REFERENCE_2_VIDEO**: Use 1 reference image as visual guide

### Example: Text-to-Video

```bash
curl -X POST "https://api.kie.ai/api/v1/veo/generate" \
  -H "Authorization: Bearer $KIE_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "A drone shot flying over a misty forest at sunrise, cinematic 4K quality, slow camera movement",
    "model": "veo3",
    "aspect_ratio": "16:9"
  }'
```

### Example: Image-to-Video

```bash
curl -X POST "https://api.kie.ai/api/v1/veo/generate" \
  -H "Authorization: Bearer $KIE_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "The person in the image slowly turns their head and smiles at the camera",
    "generationType": "REFERENCE_2_VIDEO",
    "imageUrls": ["https://example.com/portrait.jpg"],
    "model": "veo3",
    "aspect_ratio": "16:9"
  }'
```

### Veo 3 Extras

- **Get 1080p version:** `POST https://api.kie.ai/api/v1/veo/1080p` with `{"taskId": "..."}`
- **Get 4K version:** `POST https://api.kie.ai/api/v1/veo/4k` with `{"taskId": "..."}`

### Veo Extend

**Endpoint:** `POST https://api.kie.ai/api/v1/veo/extend`

Extend an existing Veo-generated video by continuing the scene.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `taskId` | string | **Yes** | Task ID of the original Veo generation |
| `prompt` | string | No | Optional guidance for the extension |
| `callBackUrl` | string | No | Webhook URL |

```bash
curl -X POST "https://api.kie.ai/api/v1/veo/extend" \
  -H "Authorization: Bearer $KIE_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "taskId": "abc123",
    "prompt": "The camera continues panning right to reveal the ocean"
  }'
```

---

## Runway AI Video API

**Endpoint:** `POST https://api.kie.ai/api/v1/runway/generate`

### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `prompt` | string | **Yes** | Video description (max 1800 chars) |
| `duration` | integer | **Yes** | `5` or `10` seconds |
| `quality` | string | **Yes** | `720p` or `1080p` |
| `callBackUrl` | string | **Yes** | Webhook URL |
| `imageUrl` | string | No | Reference image to animate |
| `aspectRatio` | string | No | `16:9`, `4:3`, `1:1`, `3:4`, `9:16` (required for text-only) |
| `waterMark` | string | No | Watermark text (empty = none) |

**Constraint:** 10-second videos cannot use 1080p. 1080p is limited to 5-second videos.

### Example: Text-to-Video

```bash
curl -X POST "https://api.kie.ai/api/v1/runway/generate" \
  -H "Authorization: Bearer $KIE_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "A cat playing piano in a jazz bar, cinematic lighting, smooth camera pan",
    "duration": 5,
    "quality": "1080p",
    "aspectRatio": "16:9",
    "callBackUrl": "",
    "waterMark": ""
  }'
```

### Runway Aleph (Advanced Editing)

**Endpoint:** `POST https://api.kie.ai/api/v1/runway/aleph/generate`

Supports multi-task editing: add/remove objects, relight footage, change angles or styles via text prompts.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `prompt` | string | **Yes** | Edit instruction (what to change) |
| `imageUrl` | string | **Yes** | Source image or video frame URL |
| `duration` | integer | No | `5` or `10` seconds (default: 5) |
| `quality` | string | No | `720p` or `1080p` (default: 720p) |
| `callBackUrl` | string | No | Webhook URL |

```bash
curl -X POST "https://api.kie.ai/api/v1/runway/aleph/generate" \
  -H "Authorization: Bearer $KIE_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "Remove the person in the background and add gentle rain",
    "imageUrl": "https://example.com/scene.jpg",
    "duration": 5,
    "quality": "720p"
  }'
```

---

## Market API (Unified Endpoint)

For Kling, Sora, Hailuo, Bytedance, Wan, and Grok Imagine video models:

**Endpoint:** `POST https://api.kie.ai/api/v1/jobs/createTask`

### Quick Examples (Top Models)

**Kling 2.1 Text-to-Video:**
```bash
curl -X POST "https://api.kie.ai/api/v1/jobs/createTask" \
  -H "Authorization: Bearer $KIE_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "kling/text-to-video-2-1",
    "input": {
      "prompt": "A dancer performing in a spotlight, cinematic slow motion",
      "duration": 5,
      "aspect_ratio": "16:9",
      "mode": "pro"
    }
  }'
```

**Sora 2 Text-to-Video:**
```bash
curl -X POST "https://api.kie.ai/api/v1/jobs/createTask" \
  -H "Authorization: Bearer $KIE_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "sora2/text-to-video",
    "input": {
      "prompt": "A golden retriever running through autumn leaves in slow motion",
      "aspect_ratio": "16:9",
      "resolution": "1080p"
    }
  }'
```

**Hailuo 02 Text-to-Video:**
```bash
curl -X POST "https://api.kie.ai/api/v1/jobs/createTask" \
  -H "Authorization: Bearer $KIE_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "hailuo/02-text-to-video-pro",
    "input": {
      "prompt": "Timelapse of a city at night with car light trails",
      "aspect_ratio": "16:9"
    }
  }'
```

**Wan 2.6 Text-to-Video:**
```bash
curl -X POST "https://api.kie.ai/api/v1/jobs/createTask" \
  -H "Authorization: Bearer $KIE_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "wan/2-6-text-to-video",
    "input": {
      "prompt": "Ocean waves crashing on rocks at sunset, drone view",
      "aspect_ratio": "16:9"
    }
  }'
```

**Bytedance Seedance 1.5 Pro:**
```bash
curl -X POST "https://api.kie.ai/api/v1/jobs/createTask" \
  -H "Authorization: Bearer $KIE_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "bytedance/seedance-1.5-pro",
    "input": {
      "prompt": "A butterfly landing on a flower, macro lens, shallow depth of field"
    }
  }'
```

Full parameter details in model-specific docs:
- Kling: `https://docs.kie.ai/market/kling/text-to-video.md`
- Sora 2: `https://docs.kie.ai/market/sora2/sora-2-text-to-video.md`
- Hailuo: `https://docs.kie.ai/market/hailuo/02-text-to-video-pro.md`
- Wan 2.6: `https://docs.kie.ai/market/wan/2-6-text-to-video.md`
- Bytedance: `https://docs.kie.ai/market/bytedance/seedance-1.5-pro.md`

---

## Video Prompt Structure

### Universal Formula
```
[Shot Type + Camera Movement] of [Subject with Details] [Action/Motion] in [Environment].
[Lighting/Mood]. [Style]. [Audio cues (Veo 3.1 only)].
```

### Model-Specific Prompt Styles

**Veo 3.1:** Long paragraph-style prompts. Dialogue uses colon format: `A man says: Where are we going?`. Add `(no subtitles)` to suppress text overlays. Supports audio descriptions (SFX, ambient, music, dialogue -- see Audio section below).

**Runway Gen-4/4.5:** Concise, visual-language prompts. Gen-4.5 supports timestamp prompting: `[0:00] She stands still. [0:03] She turns to face the camera.`

**Kling 2.6:** Subject + Action + Context (3-5 elements) + Style. Always specify camera movement or you get static shots. Supports delimiters: `VISUAL:`, `AUDIO:`, `MUSIC:`, `VOICE:`.

**Sora 2:** Storyboard-style descriptions. 5-part formula: Subject + Camera + Setting + Lighting + Style. Supports timing markers.

---

## Camera Movement Reference

Pick ONE camera movement per clip:

| Movement | Effect | Use For |
|----------|--------|---------|
| Pan left/right | Reveals scene horizontally | Establishing, landscapes |
| Tilt up/down | Reveals height/scale | Buildings, reveals |
| Dolly in/out | Camera physically moves closer/farther | Intimacy, context |
| Tracking shot | Camera follows subject parallel | Chase, walking scenes |
| Crane/boom | Camera rises or descends | Establishing, drama |
| Handheld | Natural camera shake | Documentary, urgency |
| Push-in | Slow dolly toward subject | Building tension |
| Pull-out/reveal | Dolly away from subject | Surprise, context reveal |
| Orbit/arc | Camera circles subject | Dramatic emphasis |

### Motion Description Rules
- Use spatial anchors: "walks from left to right", "moves toward camera"
- Specify start AND end states: "sitting at desk, then stands and walks to window"
- Use specific verbs: "sprints" not "moves fast", "tiptoes" not "walks quietly"
- Describe physics: "her scarf trails behind in the wind"
- Combine camera and subject motion in one sentence: "Slow dolly push-in on a woman as she lifts her gaze"

---

## Audio-Aware Prompting (Veo 3.1)

Veo 3.1 generates native synchronized audio. Structure audio in your prompt using these categories:

1. **Dialogue**: `[Character] says: [line]` (max ~8 words per 8s clip, keep it short)
2. **SFX**: Anchor to visible actions: `SFX: glass shatters as ball hits window`
3. **Ambient**: Background soundscape: `Ambient: quiet forest, distant birdsong`
4. **Music**: Mood/genre: `Soft piano melody plays in the background`

### Audio Rules
- Max 2-3 concurrent audio layers
- Add "no background music" when prioritizing dialogue/lip-sync
- For lip-sync: specify "speaking on camera", keep dialogue under 8 words
- Carry signature ambient sounds across scene cuts for continuity
- Use `(no subtitles)` to suppress auto-generated text overlays

### Example with Audio
```
Medium shot of a blacksmith hammering glowing iron on an anvil. Sparks fly.
Warm orange firelight, dark workshop. Cinematic, 35mm.
SFX: rhythmic clang of hammer on metal, hiss of steam.
Ambient: crackling fire, distant wind outside.
No background music. The blacksmith mutters: Almost there.
(no subtitles)
```

---

## Duration-Aware Prompting

| Clip Duration | Max Actions | Camera Moves | Dialogue |
|---------------|------------|--------------|----------|
| 4-5 seconds   | 1          | 1 or static  | None     |
| 6-8 seconds   | 1-2        | 1            | 1 line   |
| 10 seconds    | 2-3        | 1-2          | 2-3 lines |

Rules:
- 1 action per 3-5 seconds maximum
- 1 camera movement change per clip maximum
- Dialogue: ~1 word per second of clip length
- Shorter clips need simpler prompts -- do not pack multiple actions into 5s

---

## Video Prompt Tips

1. Always include temporal information: camera movement direction, subject motion endpoints, pace language
2. Specify camera style: "drone shot", "tracking shot", "static wide angle", "handheld"
3. Include lighting: "golden hour", "neon-lit", "overcast", "studio lighting"
4. Mention pacing: "slow motion", "time-lapse", "smooth pan"
5. Keep prompts focused -- one clear scene per generation
6. For image-to-video: describe ONLY the motion, never re-describe the image content
7. For character consistency: use the same reference image across clips via I2V
8. End prompts on clean, stable frames when planning to use Video Extend

---

## Asset Manifest Tracking

**MANDATORY:** After every successful video download, register the asset in `public/assets/manifest.json`.

Run this command after each successful download, replacing the UPPERCASE placeholders with actual values:

```bash
node -e "
const fs = require('fs');
const p = 'public/assets/manifest.json';
const m = JSON.parse(fs.readFileSync(p, 'utf8'));
const entry = {
  id: 'vid-' + String(m.assets.filter(a=>a.type==='video').length+1).padStart(3,'0'),
  type: 'video',
  filename: 'FILENAME',
  prompt: PROMPT_JSON_STRING,
  model: 'MODEL_NAME',
  parameters: { duration: DURATION, quality: 'QUALITY', aspect_ratio: 'ASPECT_RATIO', generationType: 'GEN_TYPE', endpoint: 'ENDPOINT_USED' },
  created_at: new Date().toISOString(),
  scene_id: SCENE_NUMBER,
  version: 1
};
const existing = m.assets.filter(a => a.prompt === entry.prompt && a.model === entry.model && !a.superseded_by);
if (existing.length > 0) {
  const prev = existing[existing.length - 1];
  entry.version = prev.version + 1;
  entry.id = 'vid-' + String(m.assets.filter(a=>a.type==='video').length+1).padStart(3,'0');
  prev.superseded_by = entry.id;
}
m.assets.push(entry);
fs.writeFileSync(p, JSON.stringify(m, null, 2));
console.log('Manifest updated: ' + entry.id + ' (v' + entry.version + ')');
"
```

**Placeholder guide:**
- `FILENAME`: Relative path for videoData.ts (without public/), e.g. `assets/clips/scene-01.mp4`
- `PROMPT_JSON_STRING`: The prompt as a JSON string
- `MODEL_NAME`: e.g. `Veo 3.1`, `Veo 3.1 Fast`, `Runway`, `Kling 2.1`, `Sora 2`
- `DURATION`: Clip duration in seconds (integer)
- `QUALITY`: e.g. `720p`, `1080p`
- `ASPECT_RATIO`: e.g. `16:9`, `9:16`
- `GEN_TYPE`: e.g. `TEXT_2_VIDEO`, `REFERENCE_2_VIDEO`
- `ENDPOINT_USED`: The API endpoint that was called
- `SCENE_NUMBER`: Integer scene ID from SCENES.md
