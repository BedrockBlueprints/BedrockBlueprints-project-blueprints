# PLAN

## Zielbild
Ein Git-versionierter VS-Code-Setup, der auf neuen Systemen mit minimalem Aufwand reproduzierbar installiert wird und Sublime Text + Sublime Merge funktional ersetzt.

## Lösungsdesign

### 1) Repository-Baseline definieren
Im Projekt-Repo wird ein `.vscode`-Ordner geführt mit:
- `settings.json` (projektrelevante Standards)
- `extensions.json` (Pflicht-/Empfehlungs-Extensions)
- optional `tasks.json` und `launch.json`

Design-Regel:
- Nur team- und projektrelevante Settings committen.
- Nutzerindividuelle Settings bleiben im User-Scope.

### 2) Erweiterungen reproduzierbar machen
- Eine maschinenlesbare Liste aller benötigten Extensions führen.
- Installationsskript bereitstellen, das diese Liste installiert.
- Skript idempotent gestalten (mehrfache Ausführung ohne Schaden).

### 3) VS Code Installation standardisieren
- Pro OS ein klarer Installationsweg dokumentieren:
  - Windows: winget
  - macOS: Homebrew
  - Linux: apt/dnf/pacman (je nach Distribution)
- `code` CLI aktivieren und als Voraussetzung prüfen.

### 4) Git-Workflow integrieren
- Konfigurationsänderungen via PR reviewen.
- Änderungen an `.vscode` und Extension-Manifest versionieren.
- Changelog/Commit-Historie liefert Nachvollziehbarkeit.

### 5) Optionaler Komfortlayer
- Persönliche Profile via VS Code Profile Export oder Settings Sync.
- Nicht im Projekt erzwingen, um Teamkonflikte zu vermeiden.

## Implementierungsreihenfolge
1. `.vscode` Baseline anlegen.
2. Extension-Manifest erzeugen.
3. Bootstrap-Skript erstellen.
4. Dokumentation „Setup auf neuem Rechner“ ergänzen.
5. Team-Abnahme und laufende Pflege im PR-Prozess.

## Erfolgskriterien
- Neuer Rechner kann VS Code + benötigte Extensions in wenigen Minuten aufsetzen.
- Projekt öffnet sich mit konsistenten Empfehlungen/Tasks/Debug-Konfiguration.
- Setup-Änderungen sind in Git historisiert und reviewbar.
