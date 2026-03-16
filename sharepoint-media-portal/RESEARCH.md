# RESEARCH

## Zielbild
- Neue, dedizierte SharePoint Online Site für dauerhafte Bereitstellung von Produktmedien (Videos, Bilder) an externe Kunden.
- Zugriff ohne Passwort für Empfänger (anonyme/"Anyone"-Freigabelinks), soweit durch Tenant-Richtlinien erlaubt.
- Sehr einfache Pflege durch Vertrieb (Upload in vordefinierte Ordnerstruktur, keine Seitenentwicklung).
- Medien sollen direkt auf der SharePoint-Seite konsumierbar sein (Video-Streaming und Bildansicht als Galerie/Bibliothek).

## Ausgangslage und Anforderungen
- Bestehende SharePoint-Seite ist für temporäre externe Zusammenarbeit ausgelegt.
- Neuer Use Case ist "always-on" Produktbereitstellung statt zeitlich befristeter Projektaustausch.
- Content-Typen:
  - Produktvideos
  - Produktbilder
- Beide Content-Typen benötigen Kategorienstruktur.
- Nicht-funktionale Anforderung: Bedienbarkeit für Nicht-Admins/Nicht-Entwickler.
- Berechtigungsanforderung: Alle dürfen lesen, aber nur wenige interne Accounts dürfen schreiben.

## Technische Prüfung: Streaming und Bibliotheksansicht
- Videos können in SharePoint Online direkt im Browser abgespielt werden (Dateivorschau/Player über Stream on SharePoint).
- Bilder können direkt in SharePoint als Vorschaubilder betrachtet werden (Document Library mit Thumbnails und Image Gallery Webpart).
- Für externe Empfänger ist die direkte Anzeige möglich, wenn der Linktyp "Anyone can view" und die Dateitypen browserfähig sind.
- Für einen "Medienkatalog" auf der Seite eignen sich kombinierte Webparts:
  - `Highlighted Content` für gefilterte Video-/Bildlisten
  - `Image Gallery` für visuelle Bildbibliothek
  - `Document Library` für Dateiansicht mit Vorschau/Sortierung

## Technische Randbedingungen (Microsoft 365 / SharePoint Online)
- Externe Freigabe muss für Tenant und Site aktiviert sein.
- Anonymer Zugriff wird über "Anyone links" gesteuert; kann per Ablaufdatum und Download-Blockierung eingeschränkt werden.
- Für Videos ist Streaming über SharePoint/OneDrive möglich; bei sehr großem Volumen ist Stream on SharePoint weiterhin auf Dateibibliotheken aufsetzend.
- Berechtigungen sollten über Gruppen und Bibliotheksebene statt Dateiebene gemanagt werden, um Wartungsaufwand zu minimieren.

## Risiken und Governance
- Risiko Datenabfluss bei anonymen Links.
- Risiko unstrukturierter Ablage bei fehlenden Namens- und Upload-Standards.
- Risiko steigender Betriebsaufwand bei zu granularer Berechtigungsvergabe.

## Compliance- und Betriebsanforderungen
- Link-Ablaufzeiten für externe Freigaben definieren (z. B. 90/180 Tage), falls dauerhaft "ohne Passwort" gefordert ist zumindest regelmäßige Link-Reviews.
- Sensitivitätslabels/Conditional Access prüfen, damit nur freizugebende Produktmedien in diese Site gelangen.
- Auditierbarkeit sicherstellen (M365 Unified Audit Log, Sharing Reports).

## Annahmen
- Nur definierte interne Accounts erhalten Bearbeitungsrechte.
- Kunden und sonstige interne Nutzer sollen lesen/streamen, aber keine Inhalte ändern.
- Inhalte sind marketing-/vertriebsfreigegeben und dürfen extern veröffentlicht werden.
