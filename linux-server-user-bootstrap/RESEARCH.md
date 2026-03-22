# RESEARCH

## Zielbild
- Ein einzelnes Shell-Skript soll die Benutzer- und Zugangsbasis für einen
  frisch installierten Linux-Server umsetzen.
- Alle Eingaben erfolgen ausschließlich über eine gleichnamige
  Umgebungsdatei `user.env`.
- Das Muster soll für weitere Initialisierungsmodule wiederverwendbar sein.

## Randbedingungen
- Startzustand: Remote-SSH als `root` mit Passwort auf einem frischen Server.
- Das Skript muss als `root` laufen, da Passwortänderungen, Benutzeranlage und
  Dateirechte sonst nicht konsistent möglich sind.
- Public Keys sollen für `root` und den konfigurierbaren Admin-Benutzer in den
  jeweiligen `authorized_keys` hinterlegt werden.

## Technische Annahmen
- Zielsysteme sind klassische Linux-Distributionen mit `bash`, `chpasswd`,
  `useradd`, `usermod`, `install`, `getent` und `id`.
- Für sudo-fähige Distributionen werden primär die Gruppen `sudo` oder
  `wheel` verwendet.
- Wiederholte Ausführung soll keine doppelten Schlüssel in
  `authorized_keys` erzeugen.

## Sicherheitsaspekte
- `user.env` bleibt bewusst im Repository, enthält initial aber nur leere
  Variablen als Vorlage.
- Nach dem Befüllen enthält `user.env` Klartext-Passwörter und muss daher vom
  Betreiber verantwortungsvoll behandelt werden.
- Das Skript validiert Pflichtwerte frühzeitig und bricht bei fatalen Fehlern
  sofort ab.
