# PLAN

## 1) Site-Architektur
- Site-Typ: Kommunikationswebsite (Communication Site), da primär Publishing/Lesen für viele externe Empfänger.
- Site-Name (Beispiel): "Product Media Hub".
- Navigation:
  - Start
  - Videos
  - Bilder
  - Neueste Inhalte
  - Kontakt Vertrieb

## 2) Informationsarchitektur
- Eine zentrale Dokumentbibliothek `Media` mit klarer Top-Level-Struktur:
  - `/Media/Videos/<Kategorie>/`
  - `/Media/Bilder/<Kategorie>/`
- Kategorien initial als Ordner anlegen (z. B. Produktlinie A, Produktlinie B, Aktionen).
- Optional: Metadaten-Spalten statt tiefer Ordnerhierarchien:
  - `Medientyp` (Video/Bild)
  - `Kategorie`
  - `Sprache`
  - `Region`
  - `Freigabestatus`
- Empfehlung: Hybridansatz (1 Ebene Ordner + Metadaten) für einfache Bedienung und spätere Filterbarkeit.

## 3) Bedienkonzept für Vertrieb (ohne Webentwicklung)
- Vertrieb arbeitet ausschließlich in der Bibliothek `Media`.
- Upload-Regel:
  - Videos nur in `/Videos/<Kategorie>/`
  - Bilder nur in `/Bilder/<Kategorie>/`
- "Schnellstart"-Anleitung (1 Seite) bereitstellen:
  - Datei hochladen
  - Metadaten setzen (falls Pflichtfelder)
  - externen Freigabelink erzeugen
- Optional: Power Automate Erinnerungsflow bei fehlenden Pflichtmetadaten.

## 4) Externe Bereitstellung ohne Passwort
- Tenant/Site sharing setting: `Anyone` links erlaubt.
- Standardlinktyp für Bibliothek auf "Anzeigen" setzen (kein Bearbeiten).
- Sicherheitsleitplanken:
  - Ablaufdatum für Links
  - Download blockieren für sensible Assets (falls nötig)
  - Domain-Allowlist prüfen (falls später restriktiver Betrieb gewünscht)

## 5) Direkte Mediennutzung auf der Seite
- Videos werden über Dateivorschau/Player direkt im Browser abgespielt (kein Download zwingend notwendig).
- Bilder werden als Galerie und als Bibliotheksansicht mit Vorschaubildern bereitgestellt.
- Webparts:
  - `Highlighted Content` (gefiltert nach `Medientyp=Video` bzw. `Bild`)
  - `Image Gallery` für Bildkategorien
  - `Document Library` für vollständige Asset-Liste inkl. Filter/Sortierung
- Ziel: Kunden finden und konsumieren Assets auf der Seite, ohne SharePoint-Strukturwissen.

## 6) Berechtigungsmodell (Read for all, Write for few)
- Gruppen:
  - `MediaHub Owners` (IT/Admin, Vollzugriff)
  - `MediaHub Contributors` (wenige interne Accounts, Schreiben)
  - `MediaHub Readers` (alle internen Leser, nur Lesen)
- Externe Empfänger erhalten ausschließlich anonyme View-Links (`Anyone can view`), keine Schreibrechte.
- Bibliothek `Media` bleibt standardmäßig read-only für breite Nutzerbasis; Upload nur über `MediaHub Contributors`.
- Vererbungsbrüche minimieren; Berechtigungen möglichst auf Site/Bibliotheksebene.

## 7) Betriebsmodell
- Monatlicher Review:
  - neue Kategorien erforderlich?
  - alte Inhalte archivieren?
  - Freigabelinks prüfen
- Quartalsweise Governance-Check:
  - externe Zugriffseinstellungen
  - Audit-Events
  - Speicherverbrauch und große Videodateien

## 8) Erfolgskriterien
- Vertrieb kann neuen Content in <5 Minuten einstellen.
- Kunde kann gewünschtes Asset in <3 Klicks finden und direkt ansehen/abspielen.
- Keine ungeplanten Schreibrechte außerhalb definierter interner Gruppe.
