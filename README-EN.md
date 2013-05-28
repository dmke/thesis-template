# Uni Bremen, Infomatik, Diploma Dissertation Template in Latex

*(University of Bremen, Department for Mathematics and Computer Science, Latex 
template for theses)

## Prerequisiets

* a current TeX-Installation (TeXLive >= 2010)
* advanced (La-)TeX-Understanding
* Ruby >= 1.9
* Topic for a Diplma Dissertation

## Setup

1. Clone this repository to your local machine:

        git clone git://github.com/dmke/thesis-template.git

    or download [this](https://github.com/dmke/thesis-template/tarball/master) 
    file und unpack it.
2. Copy all files into your personal folder and adjust the `settings.tex` to 
    your needs.
3. Commence your diploma dissertation

## Contents

* For seperate **sections**, the folder `chapters/` is to be used. Further 
  subsections can be meaningfully incorperated in `chapterd/ch01/*.tex`.
* `appendices/` reserves space for the inclusion of appendices. As with
  chapters, a seperate file should be created for each appendice and be
  defined in `appendices/index.tex`.
* UTF-8 is allowed and is the recommended encoding
* **Illustrations** should be stored in the `images/` folder.
  * SVG files are automatically converted converted to PDF images and included
    (requires Inkscape)
  * The path to all images is (in **all** included files) relative to
    `thesis.tex`. Therefore, even in `chapter/c42/foo.tex` the image 
    `images/foo.png` is included with `\includegraphics[...]{images/foo.png}`.
* **BibTeX** is used in this template. This is a BibLaTeX implementation *in
  LaTeX*, therefore the output formating can be precisely adjusted and in the
  input file `bib` further fields can be used. For clarification see the BibLaTeX documentation.

## Compilation

The `rake` command in the console starts the compile process.

Manual execution of the `xelatex thesis.tex` or the `bibtex thesis.aux`
commands are not required, since the `rake` command takes care of those tasks.
Depending on the log outputs, the command decides if and which programs have to be launched. For example, after a change in the bibliography woudl cause
`bibtex` to be launched and `xelatex` would be used to update the page numbers and cross-references. If there is nothing to do (only when the created
`thesis.pdf` is newer than all `tex` and image files), nothing is done.

## Tips and Tricks

Further information can be found in the **[Wiki](https://github.com/dmke/thesis-template/wiki)**.

## Rake

The `rake` command accepts several helpful options, such as checking common
mistakes (especially typographical ones). Furthermore, the output can be made
more legible through the use of the `rake -q` command.

`rake -D` gives an in detail description of all available options.

## Automatic Compilation

The »Build PDF« button in most (La-)TeX editors should be avoided, since after
the compile process some but not necessarily all page numbers may have to be
reindexed. The `rake` command properly recognizes which steps have to be taken.

Furthermore, there exists the a mode, in which Rake reacts to file changes,
thereby automatically starting the compile process again. To enable it, run
`rake watch` in a seperate terminal.

## Cleaning Up

All created files (with the exception of the PDF and PDF converted SVG image files) are removed with the `rake clean` command. The `rake clobber` command removes even these files.

## Miscellaneous

I am in no way affilated with the administration of University of Bremen or
its departments, with the exception of the registration of my diploma thesis.
This template is therefore explicitly provided as an **inofficial template**.
It is provided AS IS and no guarantee is given that it compiles with the requirements of the Examination Office.

This template may be freely used to create a diploma thesis for department 3 (computer science) of the University of Bremen.