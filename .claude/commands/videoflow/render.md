---
name: videoflow:render
description: Render the final video as MP4 using Remotion
allowed-tools:
  - Read
  - Bash
  - Write
---

<objective>
Render the Remotion composition to a final MP4 file.

**After this command:** Review the output video.
</objective>

<process>

## Phase 1: Verify

Check composition exists and is valid:
```bash
npx remotion compositions src/index.ts
```

## Phase 2: Render

```bash
npx remotion render src/index.ts MyVideo out/video.mp4 --codec=h264
```

For multiple formats (if requested):
```bash
# YouTube (16:9)
npx remotion render src/index.ts MyVideo out/video-youtube.mp4
# Shorts/Reels (9:16)
npx remotion render src/index.ts MyVideoVertical out/video-shorts.mp4
# Instagram (1:1)
npx remotion render src/index.ts MyVideoSquare out/video-instagram.mp4
```

## Phase 3: Report

Show user:
- Output file path and size
- Duration
- Resolution
- Next steps: review, re-render with changes, or export

## Phase 4: Update State

Update `.videoflow/STATE.md` → Render complete.

</process>
