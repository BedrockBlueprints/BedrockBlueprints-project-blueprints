# RESEARCH

## Zielbild
- Neue, dedizierte SharePoint Online Site für dauerhafte Bereitstellung von Produktmedien (Videos, Bilder) an externe Empfänger.
- **Single Source of Truth**: Jedes Video ist genau einmal in SharePoint gespeichert und wird nur referenziert/gefiltert geteilt (keine Datei-Duplikate pro Empfängergruppe).
- Zwei Freigabemodi:
  - **Massenfreigabe**: "Alles teilen" in einem Schritt.
  - **Selektive Freigabe**: Unterschiedliche Empfänger erhalten unterschiedliche Videomengen (z. B. Person A = 3 Videos, Person B = 4 Videos).
- Erweiterte Zielgruppe: Es gibt Empfänger, die dauerhaft **alle Videos und alle Bilder** erhalten sollen.

## Aktualisierte Anforderungen (überschreibt frühere Teilannahmen)
- Frühere Annahme "eine Linkstrategie für alle" reicht nicht aus.
- Stattdessen wird ein Modell mit wiederverwendbaren Freigabe-Sets benötigt:
  - Set `ALL_MEDIA` (alle Videos + alle Bilder)
  - Set `ALL_VIDEOS`
  - kundenspezifische Sets (z. B. `A_3_VIDEOS`, `B_4_VIDEOS`)
- Selektive Freigaben dürfen den Single-Source-of-Truth-Ansatz nicht brechen.
- Freigabe soll für Vertrieb mit minimalem Aufwand ausführbar sein (ohne Seitenentwicklung).

## Ausgangslage und Constraints
- Bestehende SharePoint-Seite ist für temporäre Zusammenarbeit ausgelegt; neuer Use Case ist "always-on" Medienbereitstellung.
- Inhalte:
  - Produktvideos
  - Produktbilder
- Nicht-funktional:
  - einfache Bedienung für Nicht-Admins
  - nachvollziehbare Berechtigungen/Freigaben
  - geringe Betriebslast trotz mehrerer Empfängergruppen

## Technische Bewertung: Datenmodell für Single Source of Truth
- Zentrale Bibliothek `Media` bleibt führend; dort liegt jede Datei genau einmal.
- Segmentierung erfolgt über Metadaten statt Kopien, z. B.:
  - `AssetType` (Video/Bild)
  - `Category`
  - `ShareSet` (Mehrfachauswahl, z. B. `ALL_MEDIA`, `A_3_VIDEOS`)
  - `AudiencePolicy` (z. B. `AlwaysAll`, `Selective`)
- Für "alles teilen" kann ein statischer Gesamtlink auf gefilterte Ansicht/Seite genutzt werden.
- Für selektive Freigaben werden gefilterte Ansichten oder Empfänger-spezifische Seiten verwendet, die auf derselben Bibliothek basieren.

## Technische Optionen für Freigabemodell
1. **Ansichtsbasierte Freigabe (empfohlen für Einfachheit)**
   - Pro Freigabe-Set eine gefilterte Bibliotheksansicht/Seite.
   - Vertrieb wählt nur das passende Set und sendet den zugehörigen Link.
2. **Ordnerbasierte Freigabe (nicht bevorzugt)**
   - Würde bei selektiver Freigabe schnell zu Kopierdruck führen.
   - Kollidiert mit Single Source of Truth.
3. **Automatisierte Linkbereitstellung via Power Automate (optional)**
   - Formular: Empfänger + gewünschtes Set.
   - Flow erzeugt/holt passenden View-Link und versendet.

## Sicherheits- und Governance-Aspekte
- Externe Freigabe muss tenant- und site-seitig erlaubt sein.
- `Anyone`-Links sind möglich, sollten aber klar geregelt sein (Ablaufdatum, periodischer Review).
- Alternativ für strengere Steuerung: "Specific people"-Links je Empfänger.
- Auditierbarkeit der Freigaben über M365 Unified Audit Log und Sharing Reports.

## Risiken
- Zu viele manuelle Empfängersets können Pflegeaufwand erhöhen.
- Falsch gepflegte Metadaten führen zu falschen Freigabeinhalten.
- Offene `Anyone`-Links erhöhen Weiterleitungsrisiko.

## Annahmen
- Vertrieb pflegt Metadaten/Freigabesets zuverlässig.
- Inhalte sind extern teilbar (rechtlich/vertraglich freigegeben).
- Für "Person XYZ" existiert ein dauerhaft nutzbares Vollzugriffs-Set (`ALL_MEDIA`) mit stabilem Link.
