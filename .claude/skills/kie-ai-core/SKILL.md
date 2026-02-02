---
name: kie-ai-core
description: "Core kie.ai API skill for authentication, async task polling, credits, file upload, and download. Use when making any kie.ai API call, checking task status, polling for results, uploading files, or checking credits. Keywords: kie.ai, API, task status, poll, credits, upload, download."
---

# Kie.ai Core API Skill

Use this skill for all kie.ai API interactions. It covers authentication, task management, file uploads, credits, and the async workflow pattern that all kie.ai services share.

## Authentication

All requests require a Bearer token:

```
Authorization: Bearer YOUR_API_KEY
Content-Type: application/json
```

API keys are managed at https://kie.ai/api-key

**IMPORTANT:** Never expose the API key in client-side code. Store it in environment variables (e.g., `KIE_API_KEY`).

## Async Task Workflow

All kie.ai generation tasks are **asynchronous**. The pattern is always:

1. **Submit task** -> receive `taskId`
2. **Poll for result** OR **receive webhook callback**
3. **Download generated files** before they expire (14 days for media, download URLs expire in 20 minutes)

### Rate Limits
- 20 new requests per 10 seconds
- 100+ concurrent tasks supported
- HTTP 429 when limits exceeded

## Check Task Status

```bash
curl -X GET "https://api.kie.ai/api/v1/jobs/recordInfo?taskId=TASK_ID" \
  -H "Authorization: Bearer $KIE_API_KEY"
```

### Task States

| State | Meaning |
|-------|---------|
| `waiting` | Queued |
| `queuing` | In processing queue |
| `generating` | Being processed |
| `success` | Done - results in `resultJson` field |
| `fail` | Error - check `failCode` and `failMsg` |

### Extracting Results

When status is `success`, parse the `resultJson` string to get `resultUrls` array containing download URLs.

### Polling Strategy

- Start polling at 2-3 second intervals
- After 2 minutes, increase to 15-30 second intervals (exponential backoff)
- Prefer using `callBackUrl` parameter when creating tasks to avoid polling

## Check Account Credits

```bash
curl -X GET "https://api.kie.ai/api/v1/chat/credit" \
  -H "Authorization: Bearer $KIE_API_KEY"
```

Always check credits before large batch operations.

## Get Download URL

Convert kie.ai file URLs into temporary download links (valid 20 minutes):

```bash
curl -X POST "https://api.kie.ai/api/v1/common/download-url" \
  -H "Authorization: Bearer $KIE_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"url": "https://tempfile.kie.ai/..."}'
```

Only works for kie.ai-generated URLs. External URLs return 422.

## Upload File via URL

```bash
curl -X POST "https://kieai.redpandaai.co/api/file-url-upload" \
  -H "Authorization: Bearer $KIE_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "fileUrl": "https://example.com/image.png",
    "uploadPath": "my-uploads",
    "fileName": "reference.png"
  }'
```

- Max 100MB, timeout 30s
- Uploaded files auto-delete after 3 days
- Returns download URL, file size, MIME type

## Standard Response Codes

| Code | Meaning |
|------|---------|
| 200 | Success |
| 402 | Insufficient credits |
| 422 | Validation error / content policy violation |
| 429 | Rate limit exceeded |
| 501 | Generation failed |

## Recommended Workflow in Claude Code

When the user wants to generate content via kie.ai:

1. Check credits first (`GET /api/v1/chat/credit`)
2. Submit the generation task with appropriate endpoint
3. Poll for results using `GET /api/v1/jobs/recordInfo?taskId=...`
4. When `success`, extract URLs from `resultJson`
5. Download files or present URLs to the user

Use `curl` via Bash tool for all API calls. Parse JSON responses with `jq` or PowerShell `ConvertFrom-Json` where needed.
