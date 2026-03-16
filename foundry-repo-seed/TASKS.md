# TASKS

- [ ] Repository `repo-seed` initialisieren (nur Skript, Konfig, Doku).
- [ ] `repos.json` mit allen fachlichen Repository-Einträgen anlegen.
- [ ] Optional `settings.json` für globale Defaults und Logging ergänzen.
- [ ] `bootstrap.ps1` Grundgerüst inkl. Modul-Header und BUILD INFO erstellen.
- [ ] Logging-Funktionen gemäß Template umsetzen
  (`logInfo`, `logError`, `logDebug`).
- [ ] Prüfung des Ausführungsorts `Foundry/repo-seed` implementieren.
- [ ] Clone-Logik für fehlende Zielordner implementieren.
- [ ] Update-Logik für bestehende Ordner implementieren
  (`fetch`, optional `pull`).
- [ ] Prüfung von `origin/main` und `origin/dev` implementieren.
- [ ] Tracking-Branch-Erzeugung für lokale `main` und `dev` ergänzen.
- [ ] Checkout auf `preferredBranch` mit Fallback auf `defaultBranch` ergänzen.
- [ ] Statussammlung je Repository (`OK/SKIP/ERROR`) implementieren.
- [ ] Zusammenfassung und Exit-Code-Logik implementieren.
- [ ] Logdatei-Ausgabe mit Timestamp und 7er-Rotation implementieren.
- [ ] README für neuen Windows-Rechner erstellen.
- [ ] Test mit mindestens 3 Repositories (neu, vorhanden, update deaktiviert).
- [ ] Fehlerfälle testen (falscher Pfad, fehlende Berechtigung,
  fehlender Branch).
