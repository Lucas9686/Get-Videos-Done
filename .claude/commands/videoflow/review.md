---
name: videoflow:review
description: Review generated video against the brief for quality, consistency, and completeness
allowed-tools:
  - Read
  - Write
  - Bash
  - Glob
  - Grep
  - Task
---

<objective>
Review all generated assets and composition against the original brief. Produces a quality report with actionable feedback.

**Reads:** `.videoflow/BRIEF.md`, `.videoflow/SCENES.md`, `.videoflow/ASSET-PLAN.md`, `src/videoData.ts`
**Creates:** `.videoflow/REVIEW.md`
**When to run:** After `/videoflow:compose`, before or after `/videoflow:render`
</objective>

<process>

## Phase 1: Spawn Reviewer

```
Task(
  subagent_type="videoflow-reviewer",
  prompt="Review the current VideoFlow project.

  1. Read .videoflow/BRIEF.md for the original vision
  2. Read .videoflow/SCENES.md for expected scenes
  3. Read .videoflow/ASSET-PLAN.md for expected assets
  4. Check all files in assets/images/, assets/clips/, assets/audio/
  5. Review src/videoData.ts and src/Video.tsx for composition correctness
  6. Compare everything against the brief
  7. Write .videoflow/REVIEW.md with findings

  Check: completeness, timing, style alignment, missing assets, audio sync.",
  description="Review video quality"
)
```

## Phase 2: Present Review

Read `.videoflow/REVIEW.md` and present the findings to the user.

If issues found, suggest which command to re-run:
- Missing assets → `/videoflow:generate-assets`
- Missing audio → `/videoflow:generate-audio`
- Composition issues → `/videoflow:compose`
- Brief misalignment → `/videoflow:plan-scenes`

</process>
