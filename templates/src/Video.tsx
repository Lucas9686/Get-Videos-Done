import React from "react";
import {
  useVideoConfig,
  Sequence,
  Audio,
  staticFile,
} from "remotion";
import { Scene } from "./components/Scene";
import { videoData, SceneData } from "./videoData";

export const MainVideo: React.FC = () => {
  const { fps } = useVideoConfig();
  const scenes = videoData.scenes;

  if (!scenes || scenes.length === 0) {
    throw new Error("No scenes defined. Run /videoflow:compose first.");
  }

  if (scenes.length === 1 && scenes[0].text === "Your video starts here") {
    throw new Error("Still using placeholder data. Run /videoflow:compose first.");
  }

  const sceneFrames = scenes.reduce<Array<{ from: number; duration: number }>>(
    (acc, scene) => {
      const duration = Math.round(scene.durationSeconds * fps);
      const from = acc.length > 0 ? acc[acc.length - 1].from + acc[acc.length - 1].duration : 0;
      return [...acc, { from, duration }];
    },
    []
  );

  return (
    <div style={{ flex: 1, backgroundColor: "black" }}>
      {scenes.map((scene: SceneData, i: number) => {
        const { from, duration: durationInFrames } = sceneFrames[i];

        return (
          <Sequence key={i} from={from} durationInFrames={durationInFrames}>
            <Scene scene={scene} durationInFrames={durationInFrames} />
            {scene.voiceover && (
              <Audio
                src={staticFile(scene.voiceover)}
                volume={scene.volume ?? 1.0}
              />
            )}
          </Sequence>
        );
      })}

      {/* Background music (loops automatically) */}
      {videoData.backgroundMusic && (
        <Audio
          src={staticFile(videoData.backgroundMusic.src)}
          volume={videoData.backgroundMusic.volume}
          loop
        />
      )}
    </div>
  );
};
