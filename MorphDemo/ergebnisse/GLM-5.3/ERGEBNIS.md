# MorphDemo: GLM-5.3

## Lauf

| Feld | Wert |
|---|---|
| Modell | GLM-5.3 (zai-coding-plan, Cloud) |
| Quantisierung / Variante | – |
| Harness | ZCode 0.17.0, Modus yolo |
| Thinking | high (ausdrücklich gesetzt) |
| Rechner, auf dem das Modell lief | z.ai-Cloud, Werkzeuge auf dem Test-Mac |
| Rechner, auf dem gebaut und geprüft wurde | Test-Mac (M3 Max, macOS 27.0.1) |
| Datum | 2026-10-28/29 (Lauf 2) |
| Start / Ende | 22:19 UTC / 04:19 UTC |
| Gesamtdauer | 6 h 00 min, **abgebrochen am festen Zeitlimit von zcode (6 h)**, das Modell arbeitete bis zuletzt |
| Tokens (Eingabe / Ausgabe) | noch nicht ausgelesen |
| Durchsatz (Token/s) | noch nicht ausgelesen |
| Iterationen / Build-Versuche | viele (build/ mit 46 Einträgen, spike/ mit 49 Experimenten) |
| Abweichungen vom Ablauf | Lief parallel zu Qwen 3.8 Flash (pi). Torben hat entschieden, den Stand nach 6 h zu werten. |

## Abgabe (Stand beim Abbruch)

| Datei | Größe | Format | Bibliotheken |
|---|---|---|---|
| `build/morphdemo-64k` | 65.536 B | Mach-O 64-bit arm64, ad-hoc signiert | nur libSystem.B.dylib |
| `build/morphdemo-16k` | 16.384 B | Mach-O 64-bit arm64, ad-hoc signiert (Identifier `md16`), selbst gebauter Header | nur libSystem.B.dylib |
| `morphdemo-4k` | fehlt | – | – |

Quellen liegen in `src/` (d64.c, d16.c, d4.c, loader4.c, md_core*, md_synth*), dazu 25 Hilfsskripte in `tools/`, u. a. ein eigener Mach-O-Builder und ein ad-hoc-Signierer. Es gibt keine README und kein Makefile.

Auffällig: Bei der 64k-Datei wurde die exakte Größe offenbar über einen sehr langen Signatur-Identifier („AAAA…“) aufgefüllt. Das ist Padding im Signaturblock und laut SPEC erlaubt, solange das Programm gültig läuft.

## Pflichtpunkte

`ja`, `nein` oder `-` (nicht geprüft). Die Programme wurden noch nicht ausgeführt.

| Nr. | Prüfung | 64k | 16k | 4k |
|---|---|---|---|---|
| P1 | Exakte Größe | ja | ja | nein |
| P2 | Mach-O arm64, signiert, kein Wrapper | ja | ja | nein |
| P3 | Startet ohne Eingabe, Bild und Ton | - | - | nein |
| P4 | 50 bis 70 s, endet selbst | - | - | nein |
| P5 | Escape beendet sauber | - | - | nein |
| P6 | MORPH sichtbar | - | - | nein |
| P7 | Drei Phasen mit Übergängen | - | - | nein |
| P8 | Ton synchron zum Bild | - | - | nein |
| P9 | Keine externen Inhalte, kein Netzwerk | - | - | nein |
| P10 | Neubau aus Quellcode klappt | nein (keine Build-Anleitung) | nein (keine Build-Anleitung) | nein |

Gemessene Laufzeit (s): 64k: –, 16k: –, 4k: –

**Vorläufig: unvollständig.** 2 von 3 Programmen, die README mit Build-Befehlen fehlt.

## Qualität (0 bis 5)

Offen, bis die Demos auf dem Mac angeschaut wurden.

| Kriterium | 64k | 16k | 4k |
|---|---|---|---|
| Gesamteindruck | | | 0 |
| Visuelle Qualität | | | 0 |
| Musik | | | 0 |
| Umsetzung des Themas | | | 0 |
| Eigene Identität | | | 0 |

## Notizen

- Der Arbeitsordner liegt auf dem Test-Mac unter `~/Code/morphdemo/GLM-5.3/` (2,5 MB inkl. Build-Reste; `.mimosa/` stammt von zcode und gehört nicht zur Abgabe). Er ist noch nicht nach `workspace/` kopiert.
- Lauf 1 (2026-10-28 nachmittags) wurde abgebrochen und verworfen.
