# RESEARCH

## Zielbild
- Neue dedizierte SharePoint Online Site für dauerhafte Bereitstellung von Produktmedien an externe Empfänger.
- Vertrieb muss selektive Freigaben selbstständig durchführen können, ohne auf Admins oder spätere Seitenanlage zu warten.
- Jedes Medium bleibt genau einmal in SharePoint gespeichert; Freigaben sollen Referenzen, Filter oder Vorlagen nutzen statt Dateikopien.
- Neben Vollfreigaben (`ALL_MEDIA`) werden kundenspezifische Freigaben für Bilder und Videos benötigt.

## Aktualisierte Anforderungen
- Die bisher empfohlene Lösung mit vordefinierten Ansichten pro Freigabe-Set ist für stabile Standard-Sets geeignet, skaliert aber schlecht für viele spontane Kundenanfragen.
- Neu bevorzugt wird ein Muster mit **Kopiervorlage**:
  - eine vorbereitete Kunden-Seite bzw. Listenelement-Vorlage steht bereit,
  - Vertrieb erstellt daraus selbstständig einen neuen Kundenfall,
  - Vertrieb wählt die gewünschten Medien aus,
  - der Kunde erhält genau einen Link auf diesen Fall.
- Die Lösung muss sowohl Bilder als auch Videos unterstützen.
- Die operative Arbeit für den Vertrieb muss in wenigen, klaren Schritten möglich sein.

## Ausgangslage und Constraints
- Bestehende SharePoint-Seite ist eher für Zusammenarbeit als für dauerhaftes externes Teilen gedacht.
- Inhalte bestehen aus Produktbildern und Produktvideos.
- Vertrieb soll ohne Seitenentwicklung und ohne Admin-Wartezeit arbeiten können.
- Externe Freigaben müssen nachvollziehbar und mit reinen Leserechten möglich sein.

## Technische Bewertung der Optionen

### 1. Ansichtsbasierte Freigabe über ShareSets
- Zentrale Bibliothek `Media` bleibt die Single Source of Truth.
- Medien werden per Metadaten wie `AssetType`, `Category`, `ShareSet` und `AudiencePolicy` segmentiert.
- Pro Set existiert eine gefilterte Ansicht oder Seite.
- Vorteil: technisch einfach und sauber.
- Nachteil: für viele spontane Kundenfreigaben entsteht Pflegeaufwand, weil neue Sets und Links vorbereitet werden müssen.

### 2. Kopiervorlage für Kundenfälle
- Neben der Bibliothek `Media` gibt es eine zweite Struktur für Freigabefälle, z. B. eine Liste `Customer Shares` oder eine Seitenbibliothek mit einer Vorlage `Customer Share Template`.
- Vertrieb kopiert die Vorlage selbstständig und pflegt dort:
  - Kundenname,
  - Freigabename,
  - optionale Beschreibung,
  - selektierte Medienreferenzen.
- Die Medien selbst bleiben in `Media`; im Kundenfall werden nur Referenzen gespeichert.
- Vorteil: keine Admin-Abhängigkeit für jeden neuen Kundenfall.
- Vorteil: Vertrieb arbeitet mit einem wiederholbaren Muster.
- Nachteil: etwas mehr Initialaufwand für die Vorlage und klare Prozessdisziplin.

### 3. Ordnerbasierte Freigabe
- Für jeden Kunden ein Ordner oder eine Kopie der Dateien.
- Vorteil: intuitiv.
- Nachteil: bricht den Single-Source-of-Truth-Ansatz und erhöht Dublettenrisiko.
- Daher nicht bevorzugt.

## Empfohlene Richtung
- Für Standardfälle darf es weiterhin feste Ansichten wie `ALL_MEDIA` geben.
- Für selektive Kundenfreigaben wird eine **Kopiervorlage** als bevorzugter Arbeitsmodus empfohlen.
- Die Vorlage sollte so gestaltet sein, dass Vertrieb nur noch einen neuen Freigabefall anlegt, Medien referenziert und den erzeugten Link teilt.

## Operativer Ablauf für Vertrieb
1. Neuen Kundenfall aus der Kopiervorlage erstellen.
2. Kundenname und optional Laufzeit/Kommentar eintragen.
3. In der zentralen Bibliothek `Media` die gewünschten Bilder und Videos auswählen.
4. Diese Medien im Kundenfall als Referenzen hinterlegen.
5. Vorschau/Ansicht prüfen.
6. Freigabelink an den Kunden senden.

## Sicherheits- und Governance-Aspekte
- Externe Freigabe muss tenant- und site-seitig erlaubt sein.
- Standardmäßig nur View-Berechtigungen.
- Je nach Compliance `Anyone`-Links oder `Specific people`-Links.
- Für Kundenfälle sollten Ablaufdatum, Besitzer und letzter Review dokumentiert sein.

## Risiken
- Wenn Medienreferenzen statt Metadaten-Views genutzt werden, muss die Vorlage sauber gepflegt sein.
- Vertrieb benötigt eine sehr klare Eingabemaske, damit keine falschen Medien referenziert werden.
- Offene Freigabelinks erhöhen Weiterleitungsrisiko.

## Annahmen
- Eine initiale Vorlage wird einmalig eingerichtet.
- Vertrieb darf neue Freigabefälle selbst anlegen.
- Medien sind rechtlich für externe Freigabe freigegeben.
