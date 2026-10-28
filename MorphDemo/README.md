# Test 1: MorphDemo

Jedes Modell baut in **einem einzigen Lauf** drei native audiovisuelle
Echtzeit-Programme (Demos) zum Thema **FROM NOISE TO ORDER**, mit exakt
65.536, 16.384 und 4.096 Byte Dateigröße.

## Quelle

- Benchmark: [TheMorpheus407/morphdemo-benchmark](https://github.com/TheMorpheus407/morphdemo-benchmark)
  von Cedric Mössner (The Morpheus), MIT-Lizenz
- Übernommener Stand: Commit `60fc91c` vom 2026-10-27, Spezifikation v1.1 (2026-09-23)
- Die Inputs liegen unverändert in [`inputs/`](inputs/), die Lizenz in
  [`inputs/LICENSE-morphdemo-benchmark`](inputs/LICENSE-morphdemo-benchmark).
- Im Original-Repo liegen fertige Läufe von Claude Opus 5.5, GPT-6 Astra,
  Claude Sonnet 5.5, GPT-6.1 Sol, Mistral Large 4, Gemini 4 Argon und
  Kimi K3.1 Pro. Die eignen sich als Vergleich für unsere Ergebnisse.

## Inputs

Jedes Modell bekommt genau diese drei Dateien in einen leeren Arbeitsordner:

| Datei | Inhalt |
|---|---|
| [`inputs/prompt.txt`](inputs/prompt.txt) | Der Start-Prompt des Laufs (siehe unten) |
| [`inputs/SPEC.md`](inputs/SPEC.md) | Die eigentliche Aufgabe (englisch) |
| [`inputs/ENVIRONMENT.json`](inputs/ENVIRONMENT.json) | Gemessene Daten des Referenzrechners: OS, GPU, Grafik-, Audio- und Build-Werkzeuge |

### Prompt

Der Prompt ist absichtlich kurz, alles Weitere steht in `SPEC.md`:

```
Follow the instructions in SPEC.md completely. ENVIRONMENT.json describes this machine. Keep all your work inside this folder.
```

### Aufgabe (Zusammenfassung von `SPEC.md`)

**Abzugeben:**

1. `morphdemo-64k`, exakt 65.536 Byte
2. `morphdemo-16k`, exakt 16.384 Byte
3. `morphdemo-4k`, exakt 4.096 Byte
4. vollständiger Quellcode aller drei Programme
5. alles, was zum Neubau aus dem Quellcode nötig ist
6. eine kurze `README.md` mit den exakten Build-Befehlen und einer Beschreibung der Umsetzung

Die Größen sind exakte Dateigrößen, keine Obergrenzen. Auffüllen (Padding) ist erlaubt.

**Jedes der drei Programme muss für sich allein:**

- ein natives Linux-Programm sein (kein Shell-Skript, kein Interpreter, kein Archiv, kein Launcher);
  selbst entpackender Code ist erlaubt, wenn das Entpacken im Programm selbst passiert
- in Echtzeit rendern, mit durchgehender Animation
- Audio oder Musik zur Laufzeit erzeugen, bewusst synchron zum Bild
- eine erkennbare Entwicklung zeigen: **Entstehung** (chaotisch, verrauscht, minimal),
  **Verwandlung** (zunehmend strukturiert), **Auflösung** (Höhepunkt oder Schlussform)
- mindestens drei sichtbar unterscheidbare Phasen mit sinnvollen Übergängen haben
- mindestens einmal das Wort **MORPH** zeigen
- zwischen **50 und 70 Sekunden** laufen, dann von selbst enden, und mit Escape sauber beendbar sein
- ohne Konfiguration und ohne Eingabe starten, sichtbar und hörbar sein
- keine externen Inhalte nutzen (keine Texturen, Bilder, Meshes, Fonts als Inhalt,
  aufgenommene Musik oder Samples, Videos, externen Shader- oder Szenendateien, kein Netzwerk)
- keinen anderen Renderer, Player, Browser, Interpreter oder Demo-Prozess starten

Die Demos dürfen Code und Ideen teilen, kein bestehendes Werk nachbauen, und jede
soll eine eigene visuelle Identität haben.

**Arbeitsbedingungen:** keine Grenze für Zeit, Tokens, Kosten oder Iterationen.
Vor dem Abschluss soll das Modell alle drei bauen, Größen prüfen, alle drei laufen lassen
und die Laufzeit prüfen. Nur ein oder zwei der drei Größen abzugeben gilt als unvollständig.

## Ablauf eines Laufs

1. Leeren Arbeitsordner anlegen und die drei Dateien aus `inputs/` hineinkopieren.
2. Harness im Arbeitsordner starten und `prompt.txt` als einzigen Prompt schicken.
3. Keine Hilfe und keine Rückfragen beantworten, das Modell arbeitet, bis es selbst fertig ist.
4. Startzeit, Endzeit und, soweit der Harness sie liefert, Tokens und Durchsatz notieren.
5. Den Arbeitsordner am Ende ohne Build-Ausgaben, Caches und Harness-Konfiguration
   (`.claude/`, `.codex/`, `.mcp.json`, ...) nach `ergebnisse/<Modellname>/workspace/` kopieren.
6. Die drei Programme auf dem Zielsystem prüfen und `ergebnisse/<Modellname>/ERGEBNIS.md` ausfüllen.

### Wichtig: Zielsystem

Die Aufgabe verlangt **native Linux-x86-64-Programme**, `ENVIRONMENT.json` beschreibt
einen NixOS-Rechner mit RTX 5090. Unser Testsystem ist ein Mac M3 Max (ARM, macOS).
Dort laufen die Programme nicht direkt. Für vergleichbare Ergebnisse muss der Lauf
und die Prüfung auf einem Linux-x86-64-Rechner (oder einer passenden VM) passieren.
Wer stattdessen auf dem Mac bauen lässt, ändert die Aufgabe und muss das in
`ERGEBNIS.md` vermerken. **Diese Entscheidung ist noch offen.**

## Bewertung

Das Original-Repo legt die Rohläufe offen, aber kein Punkteschema fest. Bis wir eins
festlegen, gilt dieser Vorschlag, abgeleitet aus den Pflichtpunkten von `SPEC.md`:

**Pflichtpunkte (je Programm, bestanden oder nicht):**

| Nr. | Prüfung |
|---|---|
| P1 | Datei existiert und hat exakt die verlangte Größe |
| P2 | Natives ELF, kein Skript, kein Wrapper, kein externer Entpacker |
| P3 | Startet ohne Eingabe, zeigt Bild und gibt Ton aus |
| P4 | Laufzeit 50 bis 70 Sekunden, endet von selbst mit Exit-Code 0 |
| P5 | Escape beendet sauber |
| P6 | Wort MORPH ist sichtbar |
| P7 | Mindestens drei unterscheidbare Phasen mit Übergängen (Entstehung, Verwandlung, Auflösung) |
| P8 | Ton ist erkennbar mit dem Bild synchron |
| P9 | Keine externen Inhalte und kein Netzwerk zur Laufzeit |
| P10 | Neubau aus dem Quellcode mit den Befehlen aus der Modell-README klappt und ergibt die abgegebene Größe |

**Qualität (je Programm, 0 bis 5):** Gesamteindruck, visuelle Qualität, Musik,
Umsetzung des Themas, eigene Identität gegenüber den anderen beiden Größen.

**Tempo und Aufwand (je Lauf):** Gesamtdauer, Tokens, Durchsatz (Token/s), Anzahl
Iterationen oder Build-Versuche, ob das Modell selbst geprüft hat.

Ein Lauf gilt als vollständig, wenn alle drei Programme alle Pflichtpunkte bestehen.

## Ergebnisse

Pro Modell gibt es einen Ordner unter [`ergebnisse/`](ergebnisse/), benannt nach dem
Modell (Schreibweise wie im Original-Repo: Bindestriche statt Leerzeichen,
z. B. `GLM-5.3`). Läuft dasselbe Modell in mehreren Harnesses, kommt der Harness
dazu, z. B. `GLM-5.3-Flash-zcode` und `GLM-5.3-Flash-pi`.

```
ergebnisse/
  _vorlage/ERGEBNIS.md      Vorlage, für jedes neue Modell kopieren
  <Modellname>/
    ERGEBNIS.md             Laufdaten, Pflichtpunkte, Qualität, Notizen
    workspace/              Arbeitsordner des Modells am Ende des Laufs
    aufnahmen/              optional: Screenshots oder Videos der Demos
```

| Modell | Harness | Ordner | Status |
|---|---|---|---|
| GLM 5.3 | zcode | [`ergebnisse/GLM-5.3/`](ergebnisse/GLM-5.3/) | offen |
| GLM 5.3 Flash | zcode | [`ergebnisse/GLM-5.3-Flash/`](ergebnisse/GLM-5.3-Flash/) | offen |
| Qwen 3.8 Flash (lokal, quantisiert) | pi | [`ergebnisse/Qwen-3.8-Flash/`](ergebnisse/Qwen-3.8-Flash/) | offen |
