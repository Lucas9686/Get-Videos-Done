# VideoFlow

KI-Videoproduktionssystem für Remotion mit kie.ai + ElevenLabs.

## Installation

### Schritt 1: Remotion-Projekt erstellen

```bash
npx create-video@latest
cd mein-video
npm install
```

### Schritt 2: VideoFlow installieren

**Windows (PowerShell):**
```powershell
irm https://raw.githubusercontent.com/Lucas9686/Get-Videos-Done/master/setup.ps1 | iex
```

**Mac/Linux:**
```bash
curl -sL https://raw.githubusercontent.com/Lucas9686/Get-Videos-Done/master/setup.sh | bash
```

### Schritt 3: API Key setzen

Bearbeite `.env`:
```
KIE_API_KEY=dein-api-key-von-kie.ai
```

Key holen: https://kie.ai/api-key

### Schritt 4: Video erstellen

```bash
claude
```

Dann im Chat:
```
/videoflow:new-video
```

## Commands

| Command | Beschreibung |
|---------|--------------|
| `/videoflow:new-video` | Video-Idee → Brief + Szenen |
| `/videoflow:plan-scenes` | Szenen anpassen |
| `/videoflow:generate-assets` | Bilder, Clips, Audio generieren |
| `/videoflow:generate-audio` | Nur Audio generieren |
| `/videoflow:compose` | Remotion-Komposition erstellen |
| `/videoflow:render` | MP4 rendern |
| `/videoflow:review` | Qualität prüfen |
| `/videoflow:progress` | Status anzeigen |
| `/videoflow:help` | Hilfe anzeigen |

## Projektstruktur (nach Installation)

```
mein-video/
├── .claude/              # VideoFlow Agenten, Commands, Skills
├── .videoflow/           # Projekt-State (BRIEF.md, SCENES.md, etc.)
├── public/
│   └── assets/           # Generierte Assets
│       ├── images/       # KI-generierte Bilder
│       ├── clips/        # KI-generierte Video-Clips
│       ├── audio/        # Voiceovers, Musik, SFX
│       └── manifest.json # Asset-Tracking
├── src/
│   ├── Root.tsx          # Remotion Composition
│   ├── Video.tsx         # Video-Komponente
│   ├── videoData.ts      # Szenen-Daten
│   └── components/
│       └── Scene.tsx     # Scene-Komponente
├── out/                  # Gerenderte Videos
├── CLAUDE.md             # Dokumentation für Claude
├── package.json
└── .env                  # API Keys (nicht committen!)
```

## NPM Scripts

```bash
npm start              # Remotion Studio (Preview)
npm run render         # 16:9 Video rendern
npm run render:shorts  # 9:16 Video rendern (Shorts/Reels/TikTok)
npm run render:square  # 1:1 Video rendern (Instagram)
```

## Unterstützte AI-Modelle

### Bilder
- 4o Image (GPT) – Höchste Qualität, Text in Bildern
- Flux Kontext Pro/Max – Schnell, konsistente Charaktere
- Imagen 4 – Google's Premium-Modell
- Seedream 4.5 – Kreative Styles

### Videos
- Veo 3.1 – Höchste Qualität, native Audio-Sync
- Veo 3.1 Fast – Schneller, günstiger
- Runway – Text/Image-to-Video
- Kling – Avatare, Motion Control
- Sora 2 – Charakter-Konsistenz

### Audio
- ElevenLabs TTS – Natürliche Stimmen
- ElevenLabs Sound Effects – KI-generierte SFX

## Lizenz

MIT
