---
name: elevenlabs
description: "Generate speech, dialogue, and sound effects via ElevenLabs through kie.ai API. Use when creating voiceovers, TTS, text-to-speech, narration, dialogue between characters, sound effects, audio isolation, speech-to-text. Keywords: voiceover, sprache, narration, TTS, sound effect, dialogue, stimme."
---

# ElevenLabs Audio Skill (via kie.ai)

Generate speech, dialogue, and sound effects using ElevenLabs models through the kie.ai API. Uses the unified Market endpoint.

**Endpoint for all:** `POST https://api.kie.ai/api/v1/jobs/createTask`

---

## Text-to-Speech (Multilingual v2)

Best for: Voiceovers, narration, single-speaker audio.

```bash
curl -X POST "https://api.kie.ai/api/v1/jobs/createTask" \
  -H "Authorization: Bearer $KIE_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "elevenlabs/text-to-speech-multilingual-v2",
    "input": {
      "text": "Welcome to our video. Today we explore the future of AI.",
      "voice": "Rachel",
      "stability": 0.5,
      "similarity_boost": 0.75,
      "style": 0.0,
      "speed": 1.0
    }
  }'
```

### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `model` | string | **Yes** | `elevenlabs/text-to-speech-multilingual-v2` |
| `input.text` | string | **Yes** | Speech content (max 5000 chars) |
| `input.voice` | string | **Yes** | Voice name (Rachel, Adam, etc.) or custom voice ID |
| `input.stability` | float | No | Voice consistency 0-1 (default: 0.5) |
| `input.similarity_boost` | float | No | Voice character strength 0-1 (default: 0.75) |
| `input.style` | float | No | Expression intensity 0-1 (default: 0) |
| `input.speed` | float | No | Playback rate 0.7-1.2 (default: 1.0) |
| `input.timestamps` | boolean | No | Get word-level timing data |
| `input.language_code` | string | No | ISO 639-1 code (e.g., "de", "en", "es") |
| `callBackUrl` | string | No | Webhook URL |

### Popular Voices
Rachel, Adam, Antoni, Bella, Brian, Callum, Charlie, Charlotte, Clyde, Daniel, Dave, Dorothy, Drew, Emily, Ethan, Fin, Freya, George, Gigi, Giovanni, Glinda, Grace, Harry, James, Jeremy, Jessie, Joseph, Josh, Liam, Lily, Matilda, Michael, Mimi, Nicole, Patrick, Sam, Sarah, Serena, Thomas

---

## Text-to-Dialogue (v3)

Best for: Conversations between multiple characters, podcast-style audio.

```bash
curl -X POST "https://api.kie.ai/api/v1/jobs/createTask" \
  -H "Authorization: Bearer $KIE_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "elevenlabs/text-to-dialogue-v3",
    "input": {
      "dialogue": [
        {"text": "Hey, have you seen the latest AI video tools?", "voice": "Adam"},
        {"text": "Yes! The quality is incredible now.", "voice": "Rachel"},
        {"text": "I know, right? Let me show you something.", "voice": "Adam"}
      ],
      "stability": 0.5
    }
  }'
```

### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `model` | string | **Yes** | `elevenlabs/text-to-dialogue-v3` |
| `input.dialogue` | array | **Yes** | Array of `{text, voice}` objects |
| `input.stability` | float | No | 0.0, 0.5, or 1.0 (default: 0.5) |
| `input.language_code` | string | No | Auto-detected if omitted |
| `callBackUrl` | string | No | Webhook URL |

**Constraint:** Combined text across all dialogue items max 5000 characters.

---

## Sound Effects (v2)

Best for: Background sounds, transitions, ambient audio.

```bash
curl -X POST "https://api.kie.ai/api/v1/jobs/createTask" \
  -H "Authorization: Bearer $KIE_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "elevenlabs/sound-effect-v2",
    "input": {
      "text": "Gentle ocean waves crashing on a beach with seagulls in the background",
      "duration_seconds": 10,
      "prompt_influence": 0.3
    }
  }'
```

### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `model` | string | **Yes** | `elevenlabs/sound-effect-v2` |
| `input.text` | string | **Yes** | Sound effect description (max 5000 chars) |
| `input.duration_seconds` | float | No | 0.5-22 seconds (auto if omitted) |
| `input.loop` | boolean | No | Create seamless loop |
| `input.prompt_influence` | float | No | 0-1, how closely to follow description (default: 0.3) |
| `input.output_format` | string | No | MP3, PCM, Opus, etc. |
| `callBackUrl` | string | No | Webhook URL |

---

## Text-to-Speech Turbo 2.5

Best for: Fast, low-latency voiceovers when speed matters more than maximum quality.

```bash
curl -X POST "https://api.kie.ai/api/v1/jobs/createTask" \
  -H "Authorization: Bearer $KIE_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "elevenlabs/text-to-speech-turbo-2-5",
    "input": {
      "text": "Quick narration for a fast-paced video segment.",
      "voice": "Daniel",
      "stability": 0.5,
      "similarity_boost": 0.75
    }
  }'
```

### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `model` | string | **Yes** | `elevenlabs/text-to-speech-turbo-2-5` |
| `input.text` | string | **Yes** | Speech content (max 5000 chars) |
| `input.voice` | string | **Yes** | Voice name or custom voice ID |
| `input.stability` | float | No | Voice consistency 0-1 (default: 0.5) |
| `input.similarity_boost` | float | No | Voice character strength 0-1 (default: 0.75) |
| `input.speed` | float | No | Playback rate 0.7-1.2 (default: 1.0) |
| `input.language_code` | string | No | ISO 639-1 code |
| `callBackUrl` | string | No | Webhook URL |

Same voices as Multilingual v2. Lower latency, slightly less expressive.

---

## Audio Isolation

Best for: Cleaning up audio — removing background noise, music, or other speakers from a recording.

```bash
curl -X POST "https://api.kie.ai/api/v1/jobs/createTask" \
  -H "Authorization: Bearer $KIE_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "elevenlabs/audio-isolation",
    "input": {
      "audio_url": "https://example.com/noisy-recording.mp3"
    }
  }'
```

### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `model` | string | **Yes** | `elevenlabs/audio-isolation` |
| `input.audio_url` | string | **Yes** | URL of audio file to clean |
| `callBackUrl` | string | No | Webhook URL |

Returns cleaned audio with background noise removed.

---

## Speech-to-Text

Best for: Transcribing audio to text — useful for generating subtitles from voiceovers.

```bash
curl -X POST "https://api.kie.ai/api/v1/jobs/createTask" \
  -H "Authorization: Bearer $KIE_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "elevenlabs/speech-to-text",
    "input": {
      "audio_url": "https://example.com/voiceover.mp3",
      "language_code": "en"
    }
  }'
```

### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `model` | string | **Yes** | `elevenlabs/speech-to-text` |
| `input.audio_url` | string | **Yes** | URL of audio file to transcribe |
| `input.language_code` | string | No | ISO 639-1 code (auto-detected if omitted) |
| `callBackUrl` | string | No | Webhook URL |

Returns transcribed text with timestamps.

---

## Optimal Parameter Settings by Use Case

| Use Case | Stability | Similarity Boost | Style | Speed |
|----------|-----------|-----------------|-------|-------|
| Documentary narration | 0.65-0.80 | 0.80-0.90 | 0.10-0.20 | 1.0 |
| Calm explainer | 0.60-0.75 | 0.80 | 0.00-0.10 | 1.0 |
| Character dialogue | 0.25-0.40 | 0.75 | 0.30-0.50 | 1.0 |
| Energetic social media | 0.30-0.45 | 0.75 | 0.40-0.60 | 1.0-1.1 |
| Emotional/dramatic | 0.20-0.35 | 0.75 | 0.30-0.50 | 0.9-1.0 |

**What the parameters do:**
- **Stability**: Randomness control. Low = more emotional variation (can sound erratic if too low). High = monotone but consistent.
- **Similarity Boost**: How closely output matches the original voice. High values with poor source audio reproduce artifacts.
- **Style**: Amplifies the voice's personality. Keep at 0 for neutral narration; raise for character work.
- **Speed**: 0.7 (minimum) to 1.2 (maximum). Values beyond 1.1 can sound unnatural.

---

## Pacing and Pause Control

### Punctuation-Based (works with all models)

| Technique | Effect | Example |
|-----------|--------|---------|
| `...` | Hesitant pause, adds weight | `The answer is... 42` |
| `--` | Brief break mid-sentence | `He passed -- despite the odds` |
| `---` or `-- --` | Longer pause | `And then -- -- silence` |
| `.` | Full stop pause | Normal sentence break |
| `;` | Short mid-sentence pause | `He ran; she followed` |
| ALL CAPS | Emphasis / intensity | `This is IMPORTANT` |

### Audio Tags (Eleven v3 only)

| Tag | Effect |
|-----|--------|
| `[pause]` | Standard pause |
| `[short pause]` | Brief pause |
| `[long pause]` | Extended pause |
| `[laughs]` | Laughter |
| `[whispers]` | Whispered delivery |
| `[sighs]` | Sigh |
| `[sarcastic]` | Sarcastic tone |
| `[excited]` | Excited delivery |
| `[interrupting]` | Natural overlap/cutoff (dialogue) |

Audio tags only work well when the voice naturally fits the delivery style.

---

## Sound Effect Prompt Formula

Structure SFX prompts using this formula:
```
[Source] + [Environment/Context] + [Acoustic Qualities] + [Temporal Description]
```

**Good examples:**
- `"Heavy rain on a metal roof with deep reverb, building from light drizzle to downpour"`
- `"Vintage typewriter keys clicking rhythmically in a quiet office"`
- `"Distant thunder rumbling across a vast open plain, gradually building in intensity"`

**Bad examples:**
- `"A cool sound"` (too vague)
- `"Something scary"` (no acoustic specificity)
- `"Music"` (no genre, tempo, or instrumentation)

### prompt_influence Settings
- **High (0.7-1.0):** Literal interpretation. Use for specific, well-defined sounds.
- **Low (0.0-0.3):** Creative interpretation, model adds variations. Use for ambient/experimental.
- **Default (0.3):** Good balance for most use cases.

### Useful Audio Terms
Use industry terms for better results: impact, whoosh, ambience, one-shot, loop, stem, braam, glitch, drone, swell, stinger, riser, hit

---

## Tips for Video Production

1. **Voiceovers:** Use Multilingual v2 with stability 0.65-0.80 for consistent narration
2. **Dialogue scenes:** Use Dialogue v3 with different voices per character
3. **Ambient audio:** Use Sound Effects v2 with `loop: true` for background
4. **Pacing:** Use `speed` parameter to match video timing (stay within 0.9-1.1 for natural sound)
5. **Word timing:** Always use `timestamps: true` to enable subtitle synchronization in Remotion
6. **Voice consistency:** Use identical stability/similarity_boost values for the same narrator across all scenes
7. **Text length:** Calculate words needed: `target_seconds * 2.5` (calm) to `* 3.0` (energetic) for English, `* 2.0` to `* 2.5` for German

---

## Asset Manifest Tracking

**MANDATORY:** After every successful audio download, register the asset in `public/assets/manifest.json`.

Run this command after each successful download, replacing the UPPERCASE placeholders with actual values:

```bash
node -e "
const fs = require('fs');
const p = 'public/assets/manifest.json';
const m = JSON.parse(fs.readFileSync(p, 'utf8'));
const entry = {
  id: 'aud-' + String(m.assets.filter(a=>a.type==='audio').length+1).padStart(3,'0'),
  type: 'audio',
  filename: 'FILENAME',
  prompt: PROMPT_JSON_STRING,
  model: 'MODEL_NAME',
  parameters: { voice: 'VOICE', stability: STABILITY, similarity_boost: SIMILARITY, style: STYLE, speed: SPEED },
  created_at: new Date().toISOString(),
  scene_id: SCENE_NUMBER,
  version: 1
};
const existing = m.assets.filter(a => a.prompt === entry.prompt && a.model === entry.model && !a.superseded_by);
if (existing.length > 0) {
  const prev = existing[existing.length - 1];
  entry.version = prev.version + 1;
  entry.id = 'aud-' + String(m.assets.filter(a=>a.type==='audio').length+1).padStart(3,'0');
  prev.superseded_by = entry.id;
}
m.assets.push(entry);
fs.writeFileSync(p, JSON.stringify(m, null, 2));
console.log('Manifest updated: ' + entry.id + ' (v' + entry.version + ')');
"
```

**Placeholder guide:**
- `FILENAME`: Relative path for videoData.ts (without public/), e.g. `assets/audio/vo-01.mp3`
- `PROMPT_JSON_STRING`: The text/dialogue content as a JSON string
- `MODEL_NAME`: e.g. `elevenlabs/text-to-speech-multilingual-v2`, `elevenlabs/text-to-dialogue-v3`, `elevenlabs/sound-effect-v2`
- `VOICE`: Voice name (e.g. `Rachel`, `Adam`) or `null` for sound effects
- `STABILITY`: Float 0-1 or `null`
- `SIMILARITY`: Float 0-1 or `null`
- `STYLE`: Float 0-1 or `null`
- `SPEED`: Float 0.7-1.2 or `null`
- `SCENE_NUMBER`: Integer scene ID from SCENES.md

**For sound effects**, set voice/stability/similarity/style/speed to `null` and add `duration_seconds` and `prompt_influence` to parameters instead.
