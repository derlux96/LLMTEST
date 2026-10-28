# Test 1: MorphDemo

Jedes Modell baut in **einem einzigen Lauf** drei native audiovisuelle
Echtzeit-Programme (Demos) zum Thema **FROM NOISE TO ORDER**, mit exakt
65.536, 16.384 und 4.096 Byte Dateigröße.

## Quelle

- Benchmark: [TheMorpheus407/morphdemo-benchmark](https://github.com/TheMorpheus407/morphdemo-benchmark)
  von Cedric Mössner (The Morpheus), MIT-Lizenz
- Übernommener Stand: Commit `60fc91c` vom 2026-10-27, Spezifikation v1.1 (2026-09-23)
- Die Original-Inputs liegen unverändert in [`inputs/original/`](inputs/original/),
  mit Lizenz. Für unseren Test sind `SPEC.md` und `ENVIRONMENT.json` an den
  Mac angepasst (siehe [Anpassung an den Mac](#anpassung-an-den-mac)). Unsere Ergebnisse
  sind deshalb nicht 1:1 mit den Läufen im Original-Repo vergleichbar.
- Im Original-Repo liegen fertige Läufe von Claude Opus 5.5, GPT-6 Astra,
  Claude Sonnet 5.5, GPT-6.1 Sol, Mistral Large 4, Gemini 4 Argon und
  Kimi K3.1 Pro. Die eignen sich als Vergleich für unsere Ergebnisse.

## Inputs

Jedes Modell bekommt genau diese drei Dateien in einen leeren Arbeitsordner:

| Datei | Inhalt |
|---|---|
| [`inputs/prompt.txt`](inputs/prompt.txt) | Der Start-Prompt des Laufs, unverändert (siehe unten) |
| [`inputs/SPEC.md`](inputs/SPEC.md) | Die Aufgabe (englisch), an macOS angepasst |
| [`inputs/ENVIRONMENT.json`](inputs/ENVIRONMENT.json) | Daten des Test-Macs: OS, GPU, Grafik-, Audio- und Build-Werkzeuge |

Die Sprache der Aufgabe bleibt Englisch wie im Original, damit Prompt und SPEC für
alle Modelle gleich sind.

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

- ein natives macOS-arm64-Programm sein (Mach-O, signiert, kein `.app`-Bundle, kein Shell-Skript,
  kein Interpreter, kein Archiv, kein Launcher); selbst entpackender Code ist erlaubt, wenn das
  Entpacken im Programm selbst und im Speicher passiert
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

0. `inputs/ENVIRONMENT.json` ist am 2026-10-28 auf dem Test-Mac gemessen. Nach einem
   macOS- oder Werkzeug-Update `./tools/umgebung-messen.sh` neu ausführen und committen,
   damit alle Modelle dieselbe Datei bekommen.
1. Leeren Arbeitsordner anlegen und `prompt.txt`, `SPEC.md` und `ENVIRONMENT.json`
   aus `inputs/` hineinkopieren (nicht aus `inputs/original/`).
2. Harness im Arbeitsordner starten und `prompt.txt` als einzigen Prompt schicken.
3. Keine Hilfe und keine Rückfragen beantworten, das Modell arbeitet, bis es selbst fertig ist.
4. Startzeit, Endzeit und, soweit der Harness sie liefert, Tokens und Durchsatz notieren.
5. Den Arbeitsordner am Ende ohne Build-Ausgaben, Caches und Harness-Konfiguration
   (`.claude/`, `.codex/`, `.mcp.json`, ...) nach `ergebnisse/<Modellname>/workspace/` kopieren.
6. Die drei Programme auf dem Mac prüfen und `ergebnisse/<Modellname>/ERGEBNIS.md` ausfüllen.

## Anpassung an den Mac

Das Original verlangt native Linux-x86-64-Programme für einen NixOS-Rechner mit
RTX 5090. Unser Testsystem ist ein Mac M3 Max mit 96 GB. Deshalb ist die Aufgabe auf
macOS umgestellt (Spezifikation `v1.1-mac`). Geändert sind nur die Teile, die von der
Plattform abhängen. Thema, Größen, Laufzeit, Phasen, MORPH und alle anderen
Anforderungen sind gleich.

| Punkt | Original | Unser Test |
|---|---|---|
| Zielsystem | NixOS x86-64, RTX 5090 | macOS arm64, Apple M3 Max, 96 GB |
| Programmformat | Linux-ELF | Mach-O arm64, mindestens ad-hoc signiert, kein `.app`-Bundle, kein Rosetta |
| Grafik | OpenGL 4.6, Vulkan, CUDA | Metal, OpenGL 4.1 |
| Fenster | X11, Wayland, SDL, GLFW | Cocoa / AppKit |
| Audio | PipeWire, ALSA, SDL | Core Audio, AudioToolbox |
| Selbst entpacken | im Speicher oder anonyme In-Memory-Datei | nur im Speicher (z. B. `MAP_JIT`), nichts auf die Platte schreiben |
| Anzeige | 1920×1080 | Rendern in 1920×1080 Pixeln, Vollbild skaliert oder als Fenster |
| Build-Werkzeuge | gcc, Nix | Apple clang 21 (Xcode Command Line Tools), Python 3.9, Make 3.81; Homebrew ist da, darf aber nicht genutzt werden |

Zwei Regeln sind ausdrücklicher als im Original, weil es auf dem Mac nahe liegt, sie zu umgehen:
Systemfonts (Core Text, `NSString`-Zeichnen) gelten als Inhalt, MORPH muss also selbst
erzeugt werden, und Systemprogramme wie `afplay`, `say`, `open` oder `osascript` dürfen
nicht gestartet werden.

Die Signatur zählt zur Dateigröße. Wer auf exakte Größe auffüllt, muss das also vor dem
Signieren tun oder die Signatur einrechnen. Das ist Teil der Aufgabe.

## Bewertung

Das Original-Repo legt die Rohläufe offen, aber kein Punkteschema fest. Bis wir eins
festlegen, gilt dieser Vorschlag, abgeleitet aus den Pflichtpunkten unserer `SPEC.md`:

**Pflichtpunkte (je Programm, bestanden oder nicht):**

| Nr. | Prüfung |
|---|---|
| P1 | Datei existiert und hat exakt die verlangte Größe |
| P2 | Natives Mach-O arm64, signiert, startet ohne Rosetta, kein Skript, kein Wrapper, kein externer Entpacker |
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

Prüfhilfen auf dem Mac: `stat -f %z <datei>` (Größe), `file <datei>` und
`codesign -dv <datei>` (Format, Signatur), `/usr/bin/time -p ./<datei>` (Laufzeit),
`otool -L <datei>` (genutzte Bibliotheken).

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
