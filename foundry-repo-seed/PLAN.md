# PLAN

## Architektur
- Repositoryname: `repo-seed`.
- Sprache: PowerShell 7+.
- Hauptartefakte:
  - `bootstrap.ps1` (Orchestrierung)
  - `repos.json` (Repositoryliste)
  - `settings.json` (globale Optionen, optional)
  - `README.md` (Setup für neuen Rechner)

## Moduldesign für `bootstrap.ps1`
1. `showBuildInfo`
  - Gibt Build-Banner gemäß Vorgabe aus.
2. `loadConfig`
  - Liest JSON-Dateien und validiert Pflichtfelder.
3. `resolveFoundryRoot`
  - Prüft, ob Skript in `Foundry/repo-seed` liegt.
4. `ensureRepoPresent`
  - Führt Clone aus, falls Zielordner fehlt.
5. `updateRepo`
  - Führt `git fetch` oder optional `git pull` aus.
6. `ensureTrackingBranch`
  - Legt lokale Tracking-Branches für `main` und `dev` an, falls nötig.
7. `checkoutPreferredBranch`
  - Wechselt auf konfigurierten Zielbranch.
8. `printSummary`
  - Aggregiert Endstatus je Repository (`OK`, `SKIP`, `ERROR`).

## Logging- und Meldungssystem
- Globale Funktionen:
  - `logInfo`
  - `logError`
  - `logDebug`
- Scope-Format: `repoSeed.functionName`.
- Dateilog optional in konfigurierbarem Ordner.
- Dateiname: `LOG_repoSeed_YYYY-MM-DD_HH-MM-SS`.
- Rotation auf 7 Dateien.

## Git-Workflow pro Repository
1. Zielpfad aus `Foundry` + `folder` bilden.
2. Wenn nicht vorhanden:
  - `git clone <url> <folder>`
3. Wenn vorhanden und `updateEnabled=true`:
  - `git fetch --all --prune`
  - optional `git pull --ff-only` auf aktuellem Branch
4. Remote `origin/main` und `origin/dev` prüfen.
5. Lokal fehlende Branches anlegen:
  - `git branch --track main origin/main`
  - `git branch --track dev origin/dev`
6. Endbranch bestimmen:
  - zuerst `preferredBranch`
  - sonst `defaultBranch`
  - sonst `SKIP`
7. Auf Endbranch wechseln, wenn lokal verfügbar oder per Remote nachziehbar.

## Konfigurationsschema (JSON)
- `repos.json`:
  - Array `repositories` mit Objekten:
    - `name` (string)
    - `url` (string)
    - `folder` (string)
    - `preferredBranch` (string, optional)
    - `updateEnabled` (bool)
- `settings.json`:
  - `defaultBranch` (string)
  - `pullOnUpdate` (bool)
  - `logEnabled` (bool)
  - `logDir` (string)
  - `logLevels` (array, z. B. `INFO`, `ERROR`, `DEBUG`)

## Fehlerstrategie
- Fatal bei:
  - ungültiger Konfiguration
  - fehlendem `git`
  - ungültigem Ausführungsort
- Pro Repository isolierte Fehlerbehandlung:
  - bei Fehler Status `ERROR`, Verarbeitung anderer Repositories läuft weiter
- Exit-Code:
  - `0`, wenn kein `ERROR`
  - `1`, wenn mindestens ein `ERROR`

## Doku-Inhalt in `repo-seed` README
- Voraussetzungen (Git, PowerShell-Version, Berechtigungen)
- Einmaliger Setup auf neuem Rechner
- Konfigurationspflege für weitere Repositories
- Beispielausgabe mit `OK/SKIP/ERROR`
- Troubleshooting für Branch- und Auth-Probleme
