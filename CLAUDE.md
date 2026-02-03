# Get Videos Done – VideoFlow

KI-Videoproduktionssystem mit kie.ai + ElevenLabs + Remotion.

## Workflow

Verwende die `/videoflow:*` Slash-Commands:

1. `/videoflow:new-video` – Video-Idee → Brief + Szenen-Plan
2. `/videoflow:plan-scenes` – Szenen-Plan überarbeiten
3. `/videoflow:generate-assets` – Bilder, Clips, Audio generieren
4. `/videoflow:generate-audio` – Nur Audio generieren
5. `/videoflow:compose` – Remotion-Komposition erstellen
6. `/videoflow:render` – MP4 rendern
7. `/videoflow:review` – Qualität prüfen
8. `/videoflow:progress` – Status anzeigen
9. `/videoflow:help` – Hilfe anzeigen

## API Keys

- `KIE_API_KEY` – kie.ai API (inkl. ElevenLabs) – https://kie.ai/api-key

## Projektstruktur

- `src/` – Remotion React-Komponenten
- `src/videoData.ts` – Szenen-Daten (generiert von /videoflow:compose)
- `assets/images/` – KI-generierte Bilder
- `assets/clips/` – KI-generierte Video-Clips
- `assets/audio/` – Voiceovers, Sound-Effekte, Musik
- `assets/manifest.json` – Asset-Versionierung und Tracking
- `.videoflow/` – Projektstatus (BRIEF.md, SCENES.md, ASSET-PLAN.md)
- `out/` – Gerenderte Videos

## NPM Commands

- `npm start` – Remotion Studio (Preview)
- `npm run render` – 16:9 Video rendern
- `npm run render:shorts` – 9:16 Video rendern
- `npm run render:square` – 1:1 Video rendern

## Code-Regeln

- TypeScript strict, kein `any`
- `staticFile()` für alle Asset-Pfade, NIE `require()`
- `<Img>` statt `<img>`, `<Video>` statt `<video>`
- Remotion 4 Patterns: `useCurrentFrame()`, `interpolate()`, `spring()`
