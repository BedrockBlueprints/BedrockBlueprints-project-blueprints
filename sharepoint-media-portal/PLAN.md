# PLAN

## 1) Site-Architektur
- Site-Typ: Kommunikationswebsite oder dedizierte Team-Site mit externer Freigabe.
- Zentrale Medienbibliothek: `Media` als einzige Dateiablage.
- Zusätzliche Struktur für Freigabefälle:
  - bevorzugt Liste `Customer Shares` für Freigabe-Metadaten,
  - optional Seitenbibliothek mit Vorlage `Customer Share Template`.
- Navigation:
  - Start
  - Media Library
  - Customer Shares
  - Alles teilen
  - Anleitung Vertrieb

## 2) Informationsarchitektur
- Dateien liegen physisch nur in `Media`.
- Metadaten in `Media`:
  - `AssetType` (Video/Bild)
  - `Category`
  - `Language` (optional)
  - `Region` (optional)
  - `ReleaseStatus` (optional)
- Metadaten im Freigabefall:
  - `CustomerName`
  - `ShareTitle`
  - `SelectedAssets` (Referenzen auf Medien)
  - `LinkType` (`Anyone`/`SpecificPeople`)
  - `ExpiryDate` (optional)
  - `Owner`

## 3) Freigabemodell
- Zwei Modi:
  - Standardfreigabe über feste Links wie `ALL_MEDIA`.
  - Selektive Freigabe über einen individuellen Kundenfall aus Kopiervorlage.
- Selektive Freigabe bedeutet:
  - Vertrieb erstellt selbst einen neuen Freigabefall,
  - referenziert nur die gewünschten Bilder/Videos,
  - teilt anschließend genau den Link dieses Kundenfalls.
- Keine Medienkopie pro Kunde.

## 4) UX für Vertrieb
- Ziel: Vertrieb arbeitet ohne Admin in maximal 6 Schritten.
- Empfohlener Ablauf:
  1. Vorlage `Customer Share Template` kopieren oder neuen Eintrag in `Customer Shares` anlegen.
  2. `CustomerName` und `ShareTitle` setzen.
  3. Gewünschte Bilder/Videos in `Media` auswählen.
  4. Auswahl in `SelectedAssets` hinterlegen.
  5. Freigabeansicht prüfen.
  6. Link kopieren und senden.
- Optional: Power-Automate-Schritt für automatische Linkerzeugung/E-Mail.

## 5) Umsetzung in SharePoint-Komponenten
- Bibliothek `Media`.
- Liste `Customer Shares` mit Formular für Freigabefälle.
- Vorlage `Customer Share Template` oder Listenvorlage für wiederholbare Kundenfälle.
- Standardansichten:
  - `View_ALL_MEDIA`
  - `View_ALL_VIDEOS`
  - `View_ALL_IMAGES`
- Kundenfall-Ansicht mit Webpart oder Liste, die `SelectedAssets` rendert.

## 6) Berechtigungen und Sicherheit
- Interne Rollen:
  - `MediaHub Owners`
  - `MediaHub Contributors`
  - `MediaHub Readers`
- Vertrieb (`Contributors`) darf neue Kundenfälle selbst erstellen.
- Externe Empfänger erhalten ausschließlich View-Berechtigung auf den jeweiligen Freigabelink.
- Zusätzliche Leitplanken:
  - Link-Expiry wenn policy-konform,
  - Review-Feld im Freigabefall,
  - Auditierbare Eigentümerschaft (`Owner`).

## 7) Betriebsmodell
- Einmalige Initialeinrichtung durch Admin/IT:
  - Bibliothek `Media`,
  - Liste oder Vorlage für `Customer Shares`,
  - Berechtigungen,
  - Basisnavigation.
- Danach laufender Betrieb durch Vertrieb:
  - neue Kundenfälle selbst anlegen,
  - Medien referenzieren,
  - Links teilen,
  - abgelaufene Fälle prüfen.

## 8) Erfolgskriterien
- Jedes Medium ist physisch nur einmal vorhanden.
- Vertrieb kann einen neuen selektiven Kundenfall ohne Admin-Unterstützung erstellen.
- Bilder und Videos können im selben Kundenfall kombiniert werden.
- Ein Kunde erhält genau die selektierten Medien über einen einzelnen Link.
