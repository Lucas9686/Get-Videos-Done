import React from "react";
import { Composition } from "remotion";
import { MainVideo } from "./Video";
import { videoData } from "./videoData";

const FPS = 30;

const totalFrames = videoData.scenes.reduce(
  (sum, s) => sum + Math.round(s.durationSeconds * FPS),
  0
) || 900; // Fallback to 30 seconds if no scenes

const compositions = [
  { id: "MainVideo", width: 1920, height: 1080 },         // 16:9 Landscape (YouTube)
  { id: "MainVideoVertical", width: 1080, height: 1920 }, // 9:16 Vertical (Shorts/Reels/TikTok)
  { id: "MainVideoSquare", width: 1080, height: 1080 },   // 1:1 Square (Instagram)
];

export const RemotionRoot: React.FC = () => {
  return (
    <>
      {compositions.map(({ id, width, height }) => (
        <Composition
          key={id}
          id={id}
          component={MainVideo}
          durationInFrames={totalFrames}
          fps={FPS}
          width={width}
          height={height}
        />
      ))}
    </>
  );
};
