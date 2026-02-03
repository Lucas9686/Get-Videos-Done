---
name: videoflow:generate-assets
description: Generate all visual assets (images and video clips) via kie.ai API
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Task
---

<objective>
Generate all images and video clips defined in ASSET-PLAN.md using the kie.ai API. Runs generations in parallel where possible.

**Reads:** `.videoflow/ASSET-PLAN.md`
**Creates:** Files in `public/assets/images/` and `public/assets/clips/`
**After this command:** Run `/videoflow:generate-audio` then `/videoflow:compose`
</objective>

<process>

## Phase 1: Load Plan

Read `.videoflow/ASSET-PLAN.md` and `.videoflow/STATE.md`.

## Phase 2: Check Credits

```bash
curl -s -X GET "https://api.kie.ai/api/v1/chat/credit" \
  -H "Authorization: Bearer $KIE_API_KEY" | jq .
```

If insufficient credits, warn user and stop.

## Phase 3: Generate Assets

Spawn `videoflow-asset-generator` agent(s) — one per scene or batch:

For each scene in the asset plan:

```
Task(
  subagent_type="videoflow-asset-generator",
  prompt="Generate the visual asset for scene N.

  Model: [from plan]
  Prompt: [from plan]
  Output: [from plan]

  Steps:
  1. Submit the generation request to the appropriate kie.ai endpoint
  2. Poll for completion using GET https://api.kie.ai/api/v1/jobs/recordInfo?taskId=TASK_ID
  3. When success, extract the result URL from resultJson
  4. Download the file to the specified output path
  5. Report completion

  Use the kie-ai-core, kie-ai-image, and kie-ai-video skills for API details.",
  description="Generate scene N assets"
)
```

Launch multiple agents in parallel for independent scenes.

## Phase 4: Verify Assets

Check all expected files exist:
```bash
ls -la public/assets/images/ public/assets/clips/
```

Compare against ASSET-PLAN.md. For each missing asset:
1. Identify which scene(s) failed
2. Check STATE.md for error details (402, 422, 429, 501)
3. Present the user with options:
   - **Retry failed scenes** — re-run generation for missing assets only
   - **Use alternative model** — try a different AI model for failed scenes
   - **Skip and continue** — proceed with available assets

If user chooses retry, re-run only the failed scenes (don't regenerate successful ones).

## Phase 5: Error Handling

Handle API errors per asset:
- **402 (Insufficient Credits):** Stop all pending generations, warn user.
- **422 (Content Policy):** Log which prompt was rejected, suggest rephrasing.
- **429 (Rate Limit):** Wait with exponential backoff (3s, 6s, 12s, max 30s). Max 3 retries.
- **501 (Generation Failed):** Log failure, suggest alternative model.

## Phase 6: Update State

Update `.videoflow/STATE.md` with per-scene status (completed, failed, skipped).

Present results: which assets succeeded, which failed, next steps.

</process>
