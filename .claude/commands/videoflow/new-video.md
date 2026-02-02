---
name: videoflow:new-video
description: Start a new video project with creative briefing and scene planning
allowed-tools:
  - Read
  - Write
  - Bash
  - Task
  - AskUserQuestion
---

<objective>
Create a new video project through creative briefing and scene planning.

**Creates:**
- `.videoflow/BRIEF.md` — project vision, style, audience, format
- `.videoflow/SCENES.md` — scene-by-scene breakdown with timing
- `.videoflow/STATE.md` — project state tracker

**After this command:** Run `/videoflow:plan-scenes` to plan asset generation.
</objective>

<process>

## Phase 1: Setup

1. Check if project exists:
   ```bash
   [ -f .videoflow/BRIEF.md ] && echo "ERROR: Video project already exists. Use /videoflow:progress" && exit 1
   ```

2. Create directories:
   ```bash
   mkdir -p .videoflow assets/images assets/clips assets/audio
   ```

## Phase 2: Creative Briefing

Use AskUserQuestion to gather:

1. **Video Type**: Social media clip (15-60s), Explainer video (1-5min), AI art montage, or custom
2. **Topic/Content**: What is the video about?
3. **Visual Style**: Photorealistic, cinematic, anime, abstract, minimalist, etc.
4. **Aspect Ratio**: 16:9 (YouTube), 9:16 (Shorts/Reels/TikTok), 1:1 (Instagram)
5. **Audio**: Voiceover narration? Background music mood? Sound effects?
6. **Target Length**: How long should the final video be?
7. **Reference/Inspiration**: Any existing videos or styles to reference?

Ask conversationally, not as a checklist. Follow threads. Make abstract concrete.

## Phase 3: Brief Creation

Write `.videoflow/BRIEF.md`:

```markdown
# Video Brief

## Overview
- **Title**: [working title]
- **Type**: [social/explainer/ai-art/custom]
- **Duration**: [target length]
- **Aspect Ratio**: [16:9/9:16/1:1]
- **Style**: [visual style description]

## Creative Direction
[Detailed description of the video vision, mood, pacing]

## Audio Direction
- **Voiceover**: [yes/no, language, tone]
- **Music**: [mood, genre, tempo]
- **Sound Effects**: [key moments that need SFX]

## Target Audience
[Who is this for?]
```

## Phase 4: Scene Breakdown

Spawn a `videoflow-director` agent to create the scene breakdown:

```
Task(
  subagent_type="videoflow-director",
  prompt="Read .videoflow/BRIEF.md and create .videoflow/SCENES.md with a detailed scene-by-scene breakdown. Each scene needs: scene number, duration in seconds, visual description (detailed enough to generate with AI), camera movement, text overlay (if any), voiceover text (if any), audio notes. The total duration of all scenes must match the target video length from the brief.",
  description="Plan video scenes"
)
```

## Phase 5: State Initialization

Write `.videoflow/STATE.md`:

```markdown
# VideoFlow State

## Current Position
Phase: Briefing Complete | Next: /videoflow:plan-scenes

## Assets
- Images: 0 generated
- Clips: 0 generated
- Audio: 0 generated
- Composition: Not started
- Render: Not started

## Last Updated
[timestamp]
```

## Phase 6: Present Result

Show the user:
1. Summary of the brief
2. Scene count and total duration
3. Next step: `/videoflow:plan-scenes`

</process>
