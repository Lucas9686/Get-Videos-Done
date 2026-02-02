---
name: videoflow:help
description: Show available VideoFlow commands and usage guide
allowed-tools: []
---

<objective>
Display all VideoFlow commands and the recommended workflow.
</objective>

<process>

Display the following:

# VideoFlow - AI Video Production System

## Workflow

```
/videoflow:new-video      -> Create brief + scene plan
/videoflow:plan-scenes    -> Plan which AI models & prompts to use
/videoflow:generate-assets -> Generate images & video clips via kie.ai
/videoflow:generate-audio  -> Generate voiceovers & SFX via ElevenLabs
/videoflow:compose         -> Build Remotion composition from all assets
/videoflow:render          -> Render final MP4 video
/videoflow:review          -> Review quality against brief
/videoflow:progress        -> Check project status
```

## Quick Start

1. `/videoflow:new-video` -- Describe your video idea
2. `/videoflow:plan-scenes` -- Review the asset plan
3. `/videoflow:generate-assets` -- Generate visuals (parallel)
4. `/videoflow:generate-audio` -- Generate audio (parallel with step 3)
5. `/videoflow:compose` -- Combine everything into Remotion code
6. `/videoflow:render` -- Export final MP4
7. `/videoflow:review` -- Check quality against brief (optional)

## Requirements

- `KIE_API_KEY` environment variable set (get at https://kie.ai/api-key)
- Node.js installed (for Remotion)
- Remotion project initialized (done automatically on first use)

## Skills Used

- `kie-ai-core` -- API authentication & task management
- `kie-ai-image` -- Image generation endpoints
- `kie-ai-video` -- Video generation endpoints
- `elevenlabs` -- Text-to-speech & sound effects
- `remotion` -- Video composition & rendering

</process>
