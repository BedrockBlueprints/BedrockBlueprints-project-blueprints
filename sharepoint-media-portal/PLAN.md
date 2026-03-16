# PLAN

## 1) Site-Architektur
- Site-Typ: Kommunikationswebsite (Communication Site).
- Zentraler Inhaltscontainer: eine Bibliothek `Media` als einzige Datenquelle.
- Seiten/Navigation:
  - Start
  - Alle Videos
  - Alle Bilder
  - Alles teilen (Videos + Bilder)
  - Selektive Freigabe

## 2) Informationsarchitektur (Single Source of Truth)
- Keine Medienkopien pro Kunde/Empfänger.
- Dateiablage nur einmal in `Media`.
- Metadatenmodell:
  - `AssetType` (Video/Bild)
  - `Category`
  - `ShareSet` (Mehrfachauswahl)
  - `AudiencePolicy` (`AlwaysAll`, `Selective`)
  - optional `Language`, `Region`, `ReleaseStatus`
- Governance-Regel: Selektive Bereitstellung erfolgt nur über Filter/Views auf Basis dieser Metadaten.

## 3) Freigabemodell
- Vordefinierte Freigabesets:
  - `ALL_MEDIA` → alle Videos + alle Bilder
  - `ALL_VIDEOS` → alle Videos
  - `A_3_VIDEOS` → genau die drei Videos für Person A
  - `B_4_VIDEOS` → genau die vier Videos für Person B
- Für jede Zielgruppe wird ein stabiler Share-Link auf die passende Ansicht/Seite bereitgestellt.
- "Alles auf einmal teilen" bedeutet: Vertrieb nutzt genau einen Link auf `ALL_MEDIA`.
- "Selektiv teilen" bedeutet: Vertrieb nutzt Link aus passendem ShareSet.

## 4) UX für Vertrieb
- Vertrieb arbeitet nur in 2 Schritten:
  1. Asset hochladen und Metadaten setzen (`AssetType`, `Category`, `ShareSet`).
  2. Empfänger wählen und passenden Set-Link teilen.
- Keine manuelle Mehrfachablage, keine Seitenbearbeitung nötig.
- Optional: kleine Referenztabelle "Empfänger → ShareSet-Link" direkt auf der Seite "Selektive Freigabe".

## 5) Umsetzung in SharePoint-Komponenten
- Bibliotheksansichten:
  - `View_ALL_MEDIA`
  - `View_ALL_VIDEOS`
  - `View_A_3_VIDEOS`
  - `View_B_4_VIDEOS`
- Startseite:
  - Quick Links: "Alles teilen", "Alle Videos", "Alle Bilder", "Selektive Sets"
  - Highlighted Content für "Neueste Medien"
- Optionaler Power-Automate-Flow:
  - Input: Empfänger + ShareSet
  - Output: automatischer E-Mail-Versand mit passendem Link

## 6) Berechtigungen und Sicherheit
- Interne Rollen:
  - `MediaHub Owners` (Admin)
  - `MediaHub Contributors` (Vertrieb/Content-Pflege)
  - `MediaHub Readers` (interne Leser)
- Externe Nutzung:
  - je nach Policy `Anyone` oder `Specific people` Links
  - grundsätzlich nur View-Berechtigung
- Zusätzliche Leitplanken:
  - Link-Expiry (falls policy-konform)
  - periodische Link-Reviews
  - Audit-Auswertung für externe Freigaben

## 7) Betriebsmodell
- Wöchentlicher Kurzcheck (Vertrieb):
  - Sind neue Assets korrekt getaggt?
  - Stimmen ShareSets?
- Monatlicher Governance-Check (IT/Admin):
  - Externe Links aktiv und korrekt?
  - Alte Sets/Empfänger bereinigen
  - Zugriffs- und Audit-Review

## 8) Erfolgskriterien
- Jedes Video ist physisch nur einmal vorhanden.
- "Alles teilen" dauert für Vertrieb <1 Minute (ein Link).
- Selektives Teilen für Person A/B erfolgt ohne Dateikopie.
- Dauerempfänger (XYZ) erhalten über `ALL_MEDIA` immer den vollständigen Bestand.
