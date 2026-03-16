# RESEARCH

## Ausgangslage
- Aktueller Workflow nutzt Sublime Text + Sublime Merge.
- Problem: häufiges Tool-Wechseln zwischen Editor und Git-Client.
- Ziel: ein integriertes Tool (VS Code) mit reproduzierbarer, installierbarer Umgebung.
- Zusatzanforderung: Konfiguration in Git versionieren.

## Anforderungen
1. VS Code soll als zentraler Editor + Git-Client nutzbar sein.
2. Extensions, Settings und Keybindings sollen reproduzierbar ausrollbar sein.
3. Lösung soll auf neuem System schnell installierbar sein.
4. Teamfähig: gemeinsame Basiskonfiguration im Repository.
5. Persönliche Präferenzen sollen optional getrennt bleiben.

## Technische Möglichkeiten

### A) VS Code Profiles (eingebaut)
- Profile kapseln:
  - Einstellungen
  - Tastenkürzel
  - Snippets
  - Erweiterungen
  - UI-State
- Profile können exportiert/importiert werden (`.code-profile`).
- Vorteil: schneller persönlicher Transfer.
- Nachteil: Binär-/JSON-Export ist weniger kollaborativ als klare Dateien im Repo.

### B) Workspace-basierte Konfiguration im Git-Repo (empfohlen)
- `.vscode/settings.json`: projektweite Defaults.
- `.vscode/extensions.json`: empfohlene/unerwünschte Extensions.
- `.vscode/tasks.json`: reproduzierbare Tasks.
- `.vscode/launch.json`: Debug-Defaults.
- Vorteil: versionierbar, reviewbar, teamfähig.
- Nachteil: nicht alle Nutzerpräferenzen gehören ins Projekt.

### C) Bootstrap-Skript + manifests
- Extensions-Liste exportieren:
  - `code --list-extensions > .vscode/extensions.list`
- Re-Install per Skript:
  - `cat .vscode/extensions.list | xargs -L 1 code --install-extension`
- Optional zusätzlich OS-Paketmanager (z. B. Homebrew/winget/apt) für VS Code Installation.
- Vorteil: automatisierbare Neuinstallation.
- Nachteil: CLI muss auf Zielsystem verfügbar sein.

### D) Settings Sync (Microsoft/GitHub Account)
- Synchronisiert persönliche Einstellungen cloudbasiert.
- Vorteil: schnell auf eigenem Gerätepark.
- Nachteil: nicht ideal für teamweite, repo-gebundene Reproduzierbarkeit.

## Constraints und Abgrenzung
- 100% identische Entwicklungsumgebung ist nur erreichbar, wenn zusätzlich Toolchain (Node, Python, SDKs, etc.) standardisiert wird.
- Für vollständige Reproduzierbarkeit sollten Dev Container oder Nix in Betracht gezogen werden.
- Für den beschriebenen Bedarf reicht primär eine VS-Code-Konfigurationsstrategie mit Git-Versionierung.

## Empfehlung (Research-Fazit)
Kombination aus:
1. **Repo-basierter `.vscode`-Baseline** für Team-/Projekt-Defaults.
2. **Extensions-Manifest + Bootstrap-Skript** für schnelle Neuinstallation.
3. Optional **VS Code Profile/Settings Sync** nur für persönliche Einstellungen.
