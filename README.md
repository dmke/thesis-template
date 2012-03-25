# Uni Bremen, Infomatik, Diplomarbeitsvorlage in LaTeX

*(Univertität Bremen, Department for Mathematics and Computer Science, LaTeX
template for theses. There is no manual/readme in english, yet. Feel free to
contribute!)*

## Voraussetzungen

* eine aktuelle TeX-Installation (TeXlive >= 2010)
* fortgeschrittene (La-)TeX-Kenntnisse
* ein installiertes Ruby >= 1.9
* ein Thema für die DA ;-)

## Setup

1. Klone dieses Repository auf deine Festplatte:

        git clone git://github.com/dmke/thesis-template.git

    oder lade [diese](https://github.com/dmke/thesis-template/tarball/master)
    Datei herunter und entpacke sie.
2. Kopiere alle Dateien in ein eigenes Verzeichnis passe die `settings.tex` deinen Bedürfnissen an.
3. Fange an zu schreiben.

## Inhalte

* Für einzelne **Abschnitte** ist das Verzeichnis `chapters/` vorgesehen.
  Eine weitere Untergliederung in `chapterd/ch01/*.tex` kann sinnvoll
  sein.
* Für **Anhänge** ist in `appendices/` Platz reserviert. Hier sollte, wie
  bei den Kapiteln, für jeden Anhang eine neue Datei angelegt und in
  `appendices/appendices.tex` eingebettet werden.
* UTF-8 ist erlaubt und wird empfohlen
* **Abbildungen** sollten im `images/`-Verzeichnis abgelegt werden.
  * SVG-Dateien werden automatisch in PDF-Bilder umgewandelt und
    eingebunden (benötigt Inkscape)
  * Der Pfad zu den Bildern ist (in **allen** eingebundenen Dateien)
    relativ zur `thesis.tex`. D.h. auch in `chapter/c42/foo.tex` wird
    das Bild `images/foo.png` mit `\includegraphics[...]{images/foo.png}`
    eingebunden.
* **BibTeX**: in dieser Vorlage wird BibLaTeX verwendet. Dies ist eine
  BibTeX-Implementierung *in LaTeX*, d.h. die Ausgabeformatierung kann
  sehr genau angepasst und in der Eingabe `bib`-Datei können einige neue
  Felder verwendet werden. Siehe dazu die Doku von BibLaTeX.

## Kompilieren

In der Konsole startet ein `rake` den Kompilierprozess.

Ein manuelles, ggf. mehrfaches `xelatex thesis.tex`, bzw. `bibtex thesis.aux`
ist nicht notwendig, da genau dafür der `rake`-Befehl existiert. Anhand der
Log-Ausgaben entscheidet der Befehl, ob und ggf. welche Programme gestartet
werden müssen (eben `bibtex` nach Änderungen an den Literaturverweisen, oder
`xelatex` um ggf. Seitenzahlen und Querverweise herzustellen). Wenn nichts
zu tun ist (genau dann, wenn die erzeugte `thesis.pdf` neuer als alle `tex`-
und Bilddateien ist), passiert nichts.

## Tipps und Tricks

Im **[Wiki](https://github.com/dmke/thesis-template/wiki)** finden sich noch
weitere Hinweise.

### Rake

Das `rake`-Kommando kennt einige hilfreiche Optionen, z.B. die Überprüfung
von gängigen Fehlern (insbesondere typographischen). Weiter kann die sehr
umfangreiche Ausgabe mit `rake -q` etwas reduziert werden.

Ein `rake -D` liefert eine ausführliche Beschreibung aller Möglichkeiten.

### automatisches Kompilieren

Der »Baue PDF«-Knopf in gängigen (La-)TeX-Editoren sollte vermieden werden,
da nach einem Kompilierdurchgang die Indizes oft ebenfall nochmal erneuert
werden müssen -- aber nicht zwangläufig alle. Der `rake`-Befehl erkennt,
welche weiteren Schritte getan werden müssen.

Darüber hinaus gibt es einen Modus, bei dem Rake auf Dateiänderungen
reagiert und den Kompilierprozess eigenständig startet. Dazu muss (am besten
in einem eigenen Terminal) der Befehl `rake watch` abgesetzt werden.

### Aufräumen

Alle erzeugten Dateien (bis auf das PDF und zu PDF konvertierte SVG-Bilder)
lassen sich mit `rake clean` entfernen. Ein `rake clobber` räumt auch diese
Daten auf.

# Rechtliches

Ich stehe in keiner Verbindung zur Verwaltung der Universität oder des
Fachbereichs, abgesehen davon, dass ich dort meine DA anmelden werde bzw.
angemeldet habe. Diese Vorlage ist daher **ausdrücklich als inoffizielle
Vorlage** zu sehen. Ich übernehme keine Garantie dafür, dass die äußere
Form den Anforderungen des Prüfungsamtes genügt.

Die Vorlage selbst darf frei zur Erstellung einer DA im Fachbereich 3 der
Universität Bremen genutzt werden.
