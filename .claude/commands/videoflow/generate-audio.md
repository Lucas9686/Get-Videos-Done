---
name: videoflow:generate-audio
description: Generate voiceovers and sound effects via ElevenLabs through kie.ai
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Task
---

<objective>
Generate all audio assets (voiceovers, sound effects) defined in the asset plan.

**Reads:** `.videoflow/ASSET-PLAN.md`, `.videoflow/SCENES.md`
**Creates:** Files in `assets/audio/`
**After this command:** Run `/videoflow:compose`
</objective>

<process>

## Phase 1: Load Plan

Read `.videoflow/ASSET-PLAN.md` for audio specifications per scene.

## Phase 2: Generate Audio

Spawn `videoflow-audio-producer` agent:

```
Task(
  subagent_type="videoflow-audio-producer",
  prompt="Generate all audio assets from .videoflow/ASSET-PLAN.md.

  For each scene with voiceover:
  1. Use ElevenLabs TTS via kie.ai Market API
  2. Model: elevenlabs/text-to-speech-multilingual-v2
  3. Submit via POST https://api.kie.ai/api/v1/jobs/createTask
  4. Poll for completion
  5. Download to assets/audio/vo-NN.mp3

  For each sound effect needed:
  1. Use elevenlabs/sound-effect-v2
  2. Submit and poll
  3. Download to assets/audio/sfx-NN.mp3

  Use the elevenlabs skill for API details and parameters.",
  description="Generate audio assets"
)
```

## Phase 3: Verify Audio

Check all expected audio files exist.

If any audio files are missing, identify which scenes failed and offer to retry those specific scenes.

## Phase 4: Error Handling

Handle API errors:
- **402 (Insufficient Credits):** Warn user, show credit balance, stop generation.
- **422 (Content Policy):** Report which text was rejected, suggest rephrasing.
- **429 (Rate Limit):** Wait 10 seconds, then retry. Max 3 retries per asset.
- **501 (Generation Failed):** Log the failure, try with a different voice or reduced text length.

For any failed audio, update STATE.md with the failure details so the user can retry with `/videoflow:generate-audio`.

## Phase 5: Update State

Update `.videoflow/STATE.md` with audio asset status (completed, failed, skipped).

</process>
