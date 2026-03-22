# PLAN

## Architektur
- Projektordner: `linux-server-user-bootstrap`
- Hauptartefakte:
  - `user.sh` für die Benutzer- und Zugangskonfiguration
  - `user.env` als feste Eingabevorlage
  - `RESEARCH.md`, `PLAN.md`, `TASKS.md`, `TESTS.md` für Projektdokumentation

## Moduldesign für `user.sh`
1. `showBuildInfo`
  - Gibt das geforderte BUILD-Banner aus.
2. `prepareLogFile`
  - Erstellt optional die Logdatei und stößt Rotation an.
3. `rotateLogs`
  - Behält die letzten 7 Logdateien.
4. `requireRoot`
  - Erzwingt root-Ausführung.
5. `loadEnv`
  - Lädt `user.env` aus dem Skriptverzeichnis.
6. `validateEnv`
  - Prüft Pflichtwerte und Benutzername.
7. `setPassword`
  - Setzt Passwörter über `chpasswd`.
8. `ensureAdminUser`
  - Legt den Admin-Benutzer an oder ergänzt sudo-Zugehörigkeit.
9. `ensureAuthorizedKey`
  - Erstellt `.ssh`, setzt Rechte und pflegt `authorized_keys`.
10. `configureRootAccess`
  - Setzt Root-Passwort und Root-Key.
11. `configureAdminAccess`
  - Richtet Admin-Benutzer, Passwort und Key ein.

## Logging- und Meldungssystem
- Globale Funktionen:
  - `logInfo`
  - `logError`
  - `logDebug`
- Scope-Format: `user.functionName`
- Dateilog standardmäßig im Projektordner unter `logs/`
- Dateiname: `LOG_user_YYYY-MM-DD_HH-MM-SS`
- Rotation: maximal 7 Dateien

## Bedienablauf
1. `user.env` im Projektordner mit Root-Passwort, Admin-Daten und Public Key
   füllen.
2. Skript als `root` starten, zum Beispiel mit `bash user.sh`.
3. Skript übernimmt Passwortänderungen, Benutzeranlage und Key-Verteilung.
4. Wiederholte Läufe bleiben beim SSH-Key idempotent.

## Fehlerstrategie
- Fatal bei:
  - fehlender `user.env`
  - leerer Pflichtvariable
  - ungültigem Admin-Namen
  - fehlender root-Ausführung
  - fehlender `sudo`- oder `wheel`-Gruppe
- Bei fatalen Fehlern erfolgt sofortiger Abbruch mit `ERROR`-Log.
