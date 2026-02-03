import React from "react";
import {
  useCurrentFrame,
  useVideoConfig,
  Img,
  Video,
  interpolate,
  staticFile,
} from "remotion";
import { SceneData, DEFAULTS } from "../videoData";

interface SceneProps {
  scene: SceneData;
  durationInFrames: number;
}

export const Scene: React.FC<SceneProps> = ({ scene, durationInFrames }) => {
  const frame = useCurrentFrame();
  const { width, height } = useVideoConfig();

  const fadeFrames =
    scene.transition === "fade-to-black"
      ? DEFAULTS.fadeToBlackFrames
      : DEFAULTS.fadeFrames;

  // Fade in
  const fadeIn = interpolate(frame, [0, fadeFrames], [0, 1], {
    extrapolateRight: "clamp",
  });

  // Fade out (for crossfade and fade-to-black transitions)
  const fadeOut =
    scene.transition === "crossfade" || scene.transition === "fade-to-black"
      ? interpolate(
          frame,
          [durationInFrames - fadeFrames, durationInFrames],
          [1, 0],
          { extrapolateLeft: "clamp" }
        )
      : 1;

  const opacity = Math.min(fadeIn, fadeOut);

  // Ken Burns subtle zoom effect (configurable per scene)
  const enableKenBurns = scene.kenBurns !== false;
  const scale = enableKenBurns
    ? interpolate(frame, [0, durationInFrames], [1, DEFAULTS.kenBurnsScale])
    : 1;

  const fontSize = scene.fontSize || DEFAULTS.fontSize;

  const textPositionStyle = {
    top: { top: DEFAULTS.textPositionTop },
    center: { top: "50%", transform: "translateY(-50%)" },
    bottom: { bottom: DEFAULTS.textPositionBottom },
  }[scene.textPosition || "bottom"];

  return (
    <div
      style={{
        width,
        height,
        backgroundColor: "black",
        overflow: "hidden",
        position: "relative",
      }}
    >
      {/* Visual: Image or Video Clip */}
      {scene.type === "image" ? (
        <Img
          src={staticFile(scene.src)}
          style={{
            width: "100%",
            height: "100%",
            objectFit: "cover",
            opacity,
            transform: `scale(${scale})`,
          }}
        />
      ) : (
        <Video
          src={staticFile(scene.src)}
          style={{
            width: "100%",
            height: "100%",
            objectFit: "cover",
            opacity,
            transform: `scale(${scale})`,
          }}
        />
      )}

      {/* Text Overlay */}
      {scene.text && (
        <div
          style={{
            position: "absolute",
            left: 0,
            right: 0,
            textAlign: "center",
            padding: `0 ${DEFAULTS.textPadding}px`,
            opacity: fadeIn,
            ...textPositionStyle,
          }}
        >
          <span
            style={{
              color: "white",
              fontSize,
              fontWeight: "bold",
              fontFamily: "Arial, sans-serif",
              textShadow: DEFAULTS.textShadow,
              background: "rgba(0,0,0,0.4)",
              borderRadius: 8,
              padding: "12px 24px",
              display: "inline-block",
            }}
          >
            {scene.text}
          </span>
        </div>
      )}
    </div>
  );
};
