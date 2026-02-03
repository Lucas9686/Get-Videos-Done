---
name: videoflow:compose
description: Generate Remotion React code to compose all assets into a video
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Task
---

<objective>
Generate the Remotion React composition that combines all visual and audio assets into the final video.

**Reads:** `.videoflow/SCENES.md`, `public/assets/` directory
**Creates/Modifies:** `src/` Remotion components
**After this command:** Run `/videoflow:render`
</objective>

<process>

## Phase 1: Verify Prerequisites

1. Check Remotion project exists: `[ -f package.json ] && grep -q remotion package.json`
2. Check assets exist: `ls public/assets/images/ public/assets/clips/ public/assets/audio/`
3. Read `.videoflow/SCENES.md` for timing and structure

## Phase 2: Compose

Spawn `videoflow-composer` agent:

```
Task(
  subagent_type="videoflow-composer",
  prompt="Read .videoflow/SCENES.md and the contents of public/assets/ directory.

  Generate Remotion React code that:
  1. Creates a main composition matching the video specs (fps, width, height, duration)
  2. For each scene, creates a Sequence with the correct timing
  3. Uses <Img> for image assets, <Video> for video clips
  4. Adds <Audio> for voiceovers synced to their scenes
  5. Adds background music with lower volume
  6. Includes transitions (crossfade) between scenes
  7. Adds text overlays where specified in SCENES.md

  Write the composition to src/Video.tsx (or update existing).
  Use the remotion skill for component patterns and best practices.

  The composition should be data-driven — read scene data from a config, not hardcoded.",
  description="Compose Remotion video"
)
```

## Phase 3: Preview

```bash
npm start
```

Tell user to check localhost:3000 for preview.

## Phase 4: Update State

Update `.videoflow/STATE.md` → Composition complete, ready for render.

</process>
