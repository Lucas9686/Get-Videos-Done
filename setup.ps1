# VideoFlow Setup Script für Windows
# Verwendung: Im Remotion-Projektordner ausführen

param(
    [string]$VideoFlowPath = "https://github.com/Lucas9686/Get-Videos-Done/archive/refs/heads/master.zip"
)

Write-Host "🎬 VideoFlow Setup" -ForegroundColor Cyan

# Prüfe ob package.json existiert (= Remotion-Projekt)
if (-not (Test-Path "package.json")) {
    Write-Host "❌ Kein package.json gefunden. Bitte zuerst: npx create-video@latest" -ForegroundColor Red
    exit 1
}

# Prüfe ob remotion installiert ist
$pkg = Get-Content "package.json" | ConvertFrom-Json
if (-not $pkg.dependencies.remotion) {
    Write-Host "❌ Kein Remotion-Projekt. Bitte zuerst: npx create-video@latest" -ForegroundColor Red
    exit 1
}

Write-Host "✓ Remotion-Projekt erkannt" -ForegroundColor Green

# Temp-Ordner für Download
$tempDir = Join-Path $env:TEMP "videoflow-setup"
$zipPath = Join-Path $tempDir "videoflow.zip"

# Download
Write-Host "📥 Lade VideoFlow herunter..."
New-Item -ItemType Directory -Force -Path $tempDir | Out-Null
Invoke-WebRequest -Uri $VideoFlowPath -OutFile $zipPath

# Entpacken
Write-Host "📦 Entpacke..."
Expand-Archive -Path $zipPath -DestinationPath $tempDir -Force
$extractedDir = Get-ChildItem $tempDir -Directory | Select-Object -First 1

# Kopiere .claude/
Write-Host "📁 Kopiere .claude/..."
Copy-Item -Path "$($extractedDir.FullName)\.claude" -Destination ".\.claude" -Recurse -Force

# Kopiere templates/src/ nach src/
Write-Host "📁 Kopiere VideoFlow-Komponenten..."
Copy-Item -Path "$($extractedDir.FullName)\templates\src\*" -Destination ".\src" -Recurse -Force

# Kopiere public/assets/ (staticFile() sucht hier!)
Write-Host "📁 Kopiere public/assets/..."
New-Item -ItemType Directory -Force -Path ".\public" | Out-Null
Copy-Item -Path "$($extractedDir.FullName)\public\assets" -Destination ".\public\assets" -Recurse -Force

# Erstelle .videoflow/
Write-Host "📁 Erstelle .videoflow/..."
New-Item -ItemType Directory -Force -Path ".\.videoflow" | Out-Null

# Kopiere CLAUDE.md
Copy-Item -Path "$($extractedDir.FullName)\CLAUDE.md" -Destination ".\CLAUDE.md" -Force

# Patch package.json - füge VideoFlow render Scripts hinzu
Write-Host "📝 Patche package.json..."
$pkg = Get-Content "package.json" -Raw | ConvertFrom-Json

# Füge/überschreibe Scripts
$pkg.scripts | Add-Member -NotePropertyName "start" -NotePropertyValue "remotion studio" -Force
$pkg.scripts | Add-Member -NotePropertyName "render" -NotePropertyValue "remotion render src/index.ts MainVideo out/video.mp4" -Force
$pkg.scripts | Add-Member -NotePropertyName "render:shorts" -NotePropertyValue "remotion render src/index.ts MainVideoVertical out/video-shorts.mp4" -Force
$pkg.scripts | Add-Member -NotePropertyName "render:square" -NotePropertyValue "remotion render src/index.ts MainVideoSquare out/video-square.mp4" -Force

$pkg | ConvertTo-Json -Depth 10 | Set-Content "package.json" -Encoding UTF8

# Erstelle .env falls nicht vorhanden
if (-not (Test-Path ".env")) {
    Write-Host "📝 Erstelle .env..."
    "KIE_API_KEY=dein-api-key-hier" | Out-File ".env" -Encoding UTF8
}

# Füge .env zu .gitignore hinzu
if (Test-Path ".gitignore") {
    $gitignore = Get-Content ".gitignore"
    if ($gitignore -notcontains ".env") {
        Add-Content ".gitignore" "`n.env"
    }
}

# Aufräumen
Remove-Item -Path $tempDir -Recurse -Force

Write-Host ""
Write-Host "✅ VideoFlow installiert!" -ForegroundColor Green
Write-Host ""
Write-Host "Nächste Schritte:" -ForegroundColor Yellow
Write-Host "1. Setze deinen API Key in .env (KIE_API_KEY)"
Write-Host "2. Starte Claude Code: claude"
Write-Host "3. Erstelle dein erstes Video: /videoflow:new-video"
