# TESTS

## Manuelle Verifikation

### 1. Standardfreigabe
- Öffne `View_ALL_MEDIA`.
- Prüfe, dass alle freigegebenen Bilder und Videos sichtbar sind.
- Erzeuge einen externen View-Link.
- Prüfe mit Testempfänger, dass nur Leserechte bestehen.

### 2. Selektiver Kundenfall ohne Admin
- Melde dich als Benutzer aus `MediaHub Contributors` an.
- Erstelle einen neuen Freigabefall aus `Customer Share Template` oder über `Customer Shares`.
- Trage `CustomerName` und `ShareTitle` ein.
- Wähle mindestens 2 Bilder und 1 Video aus `Media` aus.
- Hinterlege diese Medien in `SelectedAssets`.
- Öffne die Kundenfall-Ansicht.
- Prüfe, dass genau die selektierten Medien angezeigt werden.

### 3. Kein Medien-Duplikat
- Vergleiche die Dateipfade der im Kundenfall angezeigten Medien mit den Originalen in `Media`.
- Prüfe, dass keine zusätzliche Datei in einem Kundenordner angelegt wurde.

### 4. Linkprüfung extern
- Erzeuge einen Freigabelink für den Kundenfall.
- Öffne den Link mit einem Testempfänger.
- Prüfe, dass nur die selektierten Medien sichtbar sind.
- Prüfe, dass kein Bearbeiten möglich ist.

### 5. Governance
- Prüfe, dass `Owner` gesetzt ist.
- Prüfe, dass `ExpiryDate` bei zeitlich begrenzten Freigaben gefüllt ist.
- Prüfe, dass der Freigabefall in der Review-Liste oder Übersicht auffindbar ist.
