---
paths:
  - "src/**/*.ts"
  - "src/**/*.tsx"
---

# Remotion Code-Regeln

## Asset-Loading
- IMMER `staticFile(pfad)` für Asset-Pfade
- NIEMALS `require()` oder ES-Imports für Bilder/Audio/Video
- Pfade relativ zu `public/`: `staticFile("assets/images/scene-01.png")`

## Komponenten
- `<Img>` statt `<img>` (Remotion preloaded)
- `<Video>` statt `<video>`
- `<Audio>` für Audio-Tracks
- `<Sequence from={frame} durationInFrames={n}>` für Timing

## Animationen
- `useCurrentFrame()` für aktuellen Frame
- `interpolate()` für Werte-Interpolation
- `spring()` für smooth Easing
- Alle Animationen über Frame-Berechnungen, nicht CSS transitions

## TypeScript
- Strict mode, kein `any`
- Alle Props als Interface
- Komponenten als React.FC
