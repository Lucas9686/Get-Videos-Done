#!/bin/bash
# VideoFlow Setup Script für Mac/Linux

set -e

echo "🎬 VideoFlow Setup"

# Prüfe ob package.json existiert
if [ ! -f "package.json" ]; then
    echo "❌ Kein package.json gefunden. Bitte zuerst: npx create-video@latest"
    exit 1
fi

# Prüfe ob remotion installiert ist
if ! grep -q '"remotion"' package.json; then
    echo "❌ Kein Remotion-Projekt. Bitte zuerst: npx create-video@latest"
    exit 1
fi

echo "✓ Remotion-Projekt erkannt"

# Download und entpacken
echo "📥 Lade VideoFlow herunter..."
curl -sL https://github.com/Lucas9686/Get-Videos-Done/archive/refs/heads/master.zip -o /tmp/videoflow.zip
unzip -qo /tmp/videoflow.zip -d /tmp/

VFDIR="/tmp/Get-Videos-Done-master"

# Kopiere Dateien
echo "📁 Kopiere Dateien..."
cp -r "$VFDIR/.claude" .
cp -r "$VFDIR/templates/src/"* ./src/
mkdir -p ./public
cp -r "$VFDIR/public/assets" ./public/
mkdir -p .videoflow
cp "$VFDIR/CLAUDE.md" .

# Patch package.json - füge VideoFlow render Scripts hinzu
echo "📝 Patche package.json..."

# Verwende node um JSON zu patchen (zuverlässiger als sed/jq)
node -e "
const fs = require('fs');
const pkg = JSON.parse(fs.readFileSync('package.json', 'utf8'));
pkg.scripts = pkg.scripts || {};
pkg.scripts.start = 'remotion studio';
pkg.scripts.render = 'remotion render src/index.ts MainVideo out/video.mp4';
pkg.scripts['render:shorts'] = 'remotion render src/index.ts MainVideoVertical out/video-shorts.mp4';
pkg.scripts['render:square'] = 'remotion render src/index.ts MainVideoSquare out/video-square.mp4';
fs.writeFileSync('package.json', JSON.stringify(pkg, null, 2));
"

# .env erstellen
if [ ! -f ".env" ]; then
    echo "📝 Erstelle .env..."
    echo "KIE_API_KEY=dein-api-key-hier" > .env
fi

# .gitignore updaten
if [ -f ".gitignore" ] && ! grep -q "^\.env$" .gitignore; then
    echo ".env" >> .gitignore
fi

# Aufräumen
rm -rf /tmp/videoflow.zip /tmp/Get-Videos-Done-master

echo ""
echo "✅ VideoFlow installiert!"
echo ""
echo "Nächste Schritte:"
echo "1. Setze deinen API Key in .env (KIE_API_KEY)"
echo "2. Starte Claude Code: claude"
echo "3. Erstelle dein erstes Video: /videoflow:new-video"
