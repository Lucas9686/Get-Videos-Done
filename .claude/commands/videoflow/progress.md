---
name: videoflow:progress
description: Show current video project status and next recommended action
allowed-tools:
  - Read
  - Bash
---

<objective>
Display the current state of the video project and recommend the next action.
</objective>

<process>

## Read State

```bash
cat .videoflow/STATE.md 2>/dev/null || echo "No video project found. Run /videoflow:new-video to start."
```

## Check Assets

```bash
echo "=== Images ===" && ls assets/images/ 2>/dev/null || echo "None"
echo "=== Clips ===" && ls assets/clips/ 2>/dev/null || echo "None"
echo "=== Audio ===" && ls assets/audio/ 2>/dev/null || echo "None"
echo "=== Output ===" && ls out/ 2>/dev/null || echo "None"
```

## Present Status

Show:
1. Current phase (briefing, planning, generating, composing, rendering, done)
2. Asset counts (images, clips, audio files)
3. What's complete and what's pending
4. Recommended next command

</process>
