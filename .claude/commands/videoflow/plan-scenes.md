---
name: videoflow:plan-scenes
description: Plan which AI models and prompts to use for each scene's assets
allowed-tools:
  - Read
  - Write
  - Task
  - AskUserQuestion
---

<objective>
Create a concrete asset generation plan for each scene. Decides which kie.ai model to use, crafts optimized prompts, and plans audio generation.

**Reads:** `.videoflow/BRIEF.md`, `.videoflow/SCENES.md`
**Creates:** `.videoflow/ASSET-PLAN.md`
**After this command:** Run `/videoflow:generate-assets` and `/videoflow:generate-audio`
</objective>

<process>

## Phase 1: Load Context

Read `.videoflow/BRIEF.md` and `.videoflow/SCENES.md`.

## Phase 2: Plan Assets

Spawn `videoflow-director` agent:

```
Task(
  subagent_type="videoflow-director",
  prompt="Read .videoflow/BRIEF.md and .videoflow/SCENES.md. Create .videoflow/ASSET-PLAN.md with the following for each scene:

  For each scene, specify:

  ### Visual Asset
  - **type**: 'image' or 'video_clip'
  - **model**: Best kie.ai model for this scene (see model selection guide below)
  - **prompt**: Optimized English prompt for the AI model (detailed, specific)
  - **aspect_ratio**: Match the video's target ratio
  - **output_file**: e.g., public/assets/images/scene-01.png or public/assets/clips/scene-01.mp4

  ### Audio Asset (if applicable)
  - **voiceover_text**: Text for TTS
  - **voice**: ElevenLabs voice name
  - **sound_effects**: Description for SFX generation
  - **output_file**: e.g., public/assets/audio/vo-01.mp3

  Model Selection Guide:
  - Static scenes with text overlay → Image (4o Image or Flux Kontext)
  - Scenes needing motion → Video clip (Veo 3.1 or Runway)
  - Character close-ups → Flux Kontext Max or 4o Image
  - Landscapes/cinematic → Veo 3.1 quality mode
  - Fast/cheap scenes → Veo 3.1 Fast or Flux Kontext Pro

  Format as structured markdown with clear sections per scene.",
  description="Plan scene assets"
)
```

## Phase 3: User Review

Present the asset plan summary to the user:
- How many images vs video clips
- Which models will be used
- Estimated credit cost (if possible)
- Ask for approval or adjustments

## Phase 4: Update State

Update `.videoflow/STATE.md` → Phase: Asset Plan Complete | Next: /videoflow:generate-assets

</process>
