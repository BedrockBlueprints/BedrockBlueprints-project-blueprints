# RESEARCH

## Ziel
- Ein zentrales Bootstrap-Repository `repo-seed` setzt auf einem neuen
  Windows-Rechner die komplette Foundry-Arbeitsumgebung reproduzierbar auf.
- Nach genau einem `git clone` von `repo-seed` werden alle übrigen Repositories
  als direkte Nachbarn in `Foundry` bereitgestellt.

## Zielstruktur
- Flache Struktur ohne verschachtelte Fach-Repositories:
  - `Foundry/repo-seed`
  - `Foundry/repo-a`
  - `Foundry/repo-b`
  - `Foundry/repo-c`
- `repo-seed` enthält nur:
  - Skriptlogik
  - Konfigurationsdateien
  - Dokumentation

## Technische Leitentscheidung
- Laufzeitumgebung: PowerShell (Windows-nativ, JSON-Verarbeitung nativ,
  bessere Wartbarkeit als Batch).
- Git-Aufrufe erfolgen über lokale `git` CLI.
- Repository-URLs liegen ausschließlich in Konfiguration, nicht im Skript.

## Konfigurationsmodell
Pro Repository werden nur fachliche Metadaten gepflegt:
- `name`: Anzeigename
- `url`: Clone-URL
- `folder`: Zielordnername unter `Foundry`
- `preferredBranch`: gewünschter End-Branch (z. B. `dev`)
- `updateEnabled`: Update aktiv/inaktiv

Zusätzliche globale Optionen:
- `defaultBranch`: Fallback-Branch, falls `preferredBranch` leer
- `pullOnUpdate`: optionaler Schalter für `git pull` statt nur `git fetch`
- `logEnabled` und `logDir`: optionale Logdatei-Steuerung

## Ablaufanforderungen
1. Ausführungsort prüfen: Skript muss in `Foundry/repo-seed` laufen.
2. Konfiguration laden und validieren.
3. Pro Eintrag den Zielpfad `Foundry/<folder>` auflösen.
4. Fehlt Ordner: `git clone`.
5. Existiert Ordner:
  - bei `updateEnabled=true` mindestens `git fetch`
  - optional `git pull`.
6. Für `main` und `dev` prüfen, ob Remote-Branches existieren.
7. Falls lokal nicht vorhanden: Tracking-Branches für `main`/`dev` anlegen.
8. Auf gewünschten End-Branch wechseln (pro Repo konfigurierbar).
9. Ergebnisübersicht mit `OK`, `SKIP`, `ERROR` ausgeben.

## Wichtige Korrektur
- Ein `git clone` enthält bereits die relevanten Remote-Informationen.
- `main` und `dev` werden nicht separat heruntergeladen.
- Das Skript muss nur lokale Tracking-Branches sauber herstellen.

## Logging und Betriebsanforderungen
- Konsolenausgabe mit drei Levels: `INFO`, `ERROR`, `DEBUG`.
- `INFO`-Ergebnisse ausschließlich `OK` oder `SKIP`.
- Optional parallele Logdatei mit Timestamp pro Zeile.
- Rotationsregel: letzte 7 Logdateien behalten, ältere löschen.

## Risiken
- Falscher Ausführungsort erzeugt unerwartete Zielpfade.
- Divergierende lokale Branches können Checkout blockieren.
- Fehlende Git-Berechtigung/SSH-Key verhindert Clone oder Fetch.

## Abgrenzung
- Kein automatisches Erzeugen neuer Remote-Repositories.
- Kein Credential-Management im Skript.
- Kein erzwungenes Rebase/Reset lokaler Arbeitsstände ohne explizite Option.
