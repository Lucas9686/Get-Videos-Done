---
name: remotion
description: "Create videos programmatically with React using Remotion. Use when composing video from assets, building video templates, rendering MP4, combining images/clips/audio into final video, creating social media content, explainer videos. Keywords: remotion, video composition, render, MP4, React video, timeline, animation."
---

# Remotion Video Composition Skill

Create videos programmatically using React components. Remotion turns React code into MP4 videos.

## Core Concepts

- **Composition**: A video definition with width, height, fps, and duration
- **Component**: A React component that receives `frame` (current frame number) as context
- **useCurrentFrame()**: Hook to get current frame for animations
- **useVideoConfig()**: Hook to get fps, width, height, durationInFrames
- **Sequence**: Place components at specific times on the timeline
- **Audio/Video**: `<Audio>` and `<Video>` components for media
- **Img**: `<Img>` component for images (preloads before rendering)
- **spring()**: Animation helper for smooth easing

## Project Setup

```bash
npx create-video@latest my-video
cd my-video
npm start          # Preview in browser at localhost:3000
npx remotion render src/index.ts MyComposition out/video.mp4
```

## Basic Video Structure

```tsx
// src/Root.tsx
import { Composition } from "remotion";
import { MyVideo } from "./MyVideo";

export const RemotionRoot: React.FC = () => {
  return (
    <Composition
      id="MyVideo"
      component={MyVideo}
      durationInFrames={30 * 30}  // 30 seconds at 30fps
      fps={30}
      width={1920}
      height={1080}
    />
  );
};
```

## Scene Component Pattern

```tsx
import { useCurrentFrame, useVideoConfig, Img, Audio, Sequence, spring, interpolate } from "remotion";

export const Scene: React.FC<{
  imageSrc: string;
  audioSrc?: string;
  text?: string;
  durationInFrames: number;
}> = ({ imageSrc, audioSrc, text, durationInFrames }) => {
  const frame = useCurrentFrame();
  const { fps } = useVideoConfig();

  // Fade in
  const opacity = interpolate(frame, [0, 15], [0, 1], {
    extrapolateRight: "clamp",
  });

  // Ken Burns zoom effect
  const scale = interpolate(frame, [0, durationInFrames], [1, 1.1]);

  return (
    <div style={{ flex: 1, backgroundColor: "black" }}>
      <Img
        src={imageSrc}
        style={{
          width: "100%",
          height: "100%",
          objectFit: "cover",
          opacity,
          transform: `scale(${scale})`,
        }}
      />
      {text && (
        <div style={{
          position: "absolute",
          bottom: 100,
          left: 0,
          right: 0,
          textAlign: "center",
          color: "white",
          fontSize: 48,
          fontWeight: "bold",
          textShadow: "2px 2px 8px rgba(0,0,0,0.8)",
          opacity,
        }}>
          {text}
        </div>
      )}
      {audioSrc && <Audio src={audioSrc} />}
    </div>
  );
};
```

## Composing Multiple Scenes

```tsx
import { Sequence, Audio } from "remotion";
import { Scene } from "./Scene";

export const MyVideo: React.FC = () => {
  const scenes = [
    { image: "/assets/images/scene-01.png", text: "Welcome", duration: 90 },
    { image: "/assets/images/scene-02.png", text: "Chapter 1", duration: 150 },
    { image: "/assets/images/scene-03.png", duration: 120 },
  ];

  let currentFrame = 0;

  return (
    <div style={{ flex: 1, backgroundColor: "black" }}>
      {scenes.map((scene, i) => {
        const from = currentFrame;
        currentFrame += scene.duration;
        return (
          <Sequence key={i} from={from} durationInFrames={scene.duration}>
            <Scene
              imageSrc={scene.image}
              text={scene.text}
              durationInFrames={scene.duration}
            />
          </Sequence>
        );
      })}
      {/* Background music */}
      <Audio src="/assets/audio/background.mp3" volume={0.3} />
      {/* Voiceover */}
      <Audio src="/assets/audio/voiceover.mp3" volume={1.0} />
    </div>
  );
};
```

## Using Video Clips (from kie.ai)

```tsx
import { Video, Sequence } from "remotion";

// Use AI-generated video clips
<Sequence from={0} durationInFrames={150}>
  <Video src="/assets/clips/scene-01.mp4" />
</Sequence>
```

## Transitions

```tsx
// Crossfade between scenes
const CrossFade: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const frame = useCurrentFrame();
  const { durationInFrames } = useVideoConfig();

  const fadeIn = interpolate(frame, [0, 15], [0, 1], { extrapolateRight: "clamp" });
  const fadeOut = interpolate(frame, [durationInFrames - 15, durationInFrames], [1, 0], { extrapolateLeft: "clamp" });

  return <div style={{ opacity: Math.min(fadeIn, fadeOut) }}>{children}</div>;
};
```

## Rendering Commands

```bash
# Render single composition
npx remotion render src/index.ts MyVideo out/video.mp4

# Render with custom props
npx remotion render src/index.ts MyVideo out/video.mp4 --props='{"title":"My Video"}'

# Render different formats
npx remotion render src/index.ts MyVideo out/video.mp4 --codec=h264
npx remotion render src/index.ts MyVideo out/video.webm --codec=vp8

# Render specific frames (for preview)
npx remotion still src/index.ts MyVideo out/thumbnail.png --frame=0

# Multiple aspect ratios
# 16:9 (YouTube): width=1920 height=1080
# 9:16 (Shorts/Reels): width=1080 height=1920
# 1:1 (Instagram): width=1080 height=1080
```

## Common Patterns for VideoFlow

### Data-Driven Video from SCENES.md

The composer agent should read SCENES.md and generate a data structure like:

```tsx
const videoData = {
  fps: 30,
  width: 1920,
  height: 1080,
  scenes: [
    {
      type: "image",
      src: "assets/images/scene-01.png",
      audio: "assets/audio/voiceover-01.mp3",
      text: "Opening narration text",
      durationSeconds: 5,
    },
    {
      type: "clip",
      src: "assets/clips/scene-02.mp4",
      durationSeconds: 8,
    },
  ],
  backgroundMusic: "assets/audio/music.mp3",
  backgroundMusicVolume: 0.2,
};
```

Then the Remotion composition renders this data structure into a video.

### Installing Dependencies

```bash
npm install remotion @remotion/cli @remotion/player
```
