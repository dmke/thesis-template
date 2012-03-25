\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{thesis}[2011/12/20 v1.0 UHB CS Thesis]

\def\englishthesis{english}
\def\ngermanthesis{ngerman}
\def\thesislang{}
\DeclareOption{english}{\global\let\thesislang\englishthesis}
\DeclareOption{ngerman}{\global\let\thesislang\ngermanthesis}

% no options given
\DeclareOption*{\PackageWarning{thesis}{Unknown `\CurrentOption`}}
\ProcessOptions\relax

\LoadClass[10pt]{book}

% common packages
\RequirePackage{ifxetex}
\RequireXeTeX
\RequirePackage{amssymb}
\RequirePackage{fontspec}
\RequirePackage{xunicode}
\RequirePackage{xltxtra}

\RequirePackage[\thesislang]{babel}

\RequirePackage[german=guillemets]{csquotes}
\RequirePackage{amsmath}
\RequirePackage{amsfonts}
\RequirePackage{textcomp}
\RequirePackage{calc}
\RequirePackage{graphicx}
\RequirePackage{parskip}
\RequirePackage{booktabs}
\RequirePackage{array}
\RequirePackage{verbatim}
\RequirePackage{multicol}
\RequirePackage{setspace}
\RequirePackage[nofancy]{svninfo}

\RequirePackage{xspace}
\xspaceaddexceptions{"}

% thesis color scheme
\RequirePackage[table]{xcolor}
\xdefinecolor{Strong Blue}{RGB}{6,64,194}
\xdefinecolor{Dark Blue}{RGB}{6,46,139}
\xdefinecolor{Night Blue}{RGB}{0,0,89}
\xdefinecolor{Beige}{RGB}{219,212,192}
\xdefinecolor{Dark Beige}{RGB}{185,170,129}
\xdefinecolor{Night Beige}{RGB}{90,83,63}
\xdefinecolor{Light Khaki}{RGB}{217,219,209}
\xdefinecolor{Khaki}{RGB}{181,186,159}
\xdefinecolor{Dark Khaki}{RGB}{113,117,99}
\xdefinecolor{Light Red}{RGB}{214,124,118}
\xdefinecolor{Red}{RGB}{212,24,14}
\xdefinecolor{Night Red}{RGB}{105,18,12}
\xdefinecolor{White}{RGB}{255,255,255}
\xdefinecolor{Grey 1}{RGB}{238,238,238}
\xdefinecolor{Grey 2}{RGB}{204,204,204}
\xdefinecolor{Grey 3}{RGB}{170,170,170}
\xdefinecolor{Grey 4}{RGB}{136,136,136}
\xdefinecolor{Grey 5}{RGB}{102,102,102}
\xdefinecolor{Grey 6}{RGB}{51,51,51}
\xdefinecolor{Grey 7}{RGB}{33,33,33}
\xdefinecolor{Black}{RGB}{0,0,0}

\RequirePackage{tikz}
\usetikzlibrary{calc,shapes,shapes.symbols,shapes.geometric,positioning,fit,arrows}
\tikzset{every node/.style={anchor=center,font=\footnotesize\sffamily}}

% XeTeX font config
%\setromanfont[
%  Scale=0.98,
%  ExternalLocation=./fonts/,
%  BoldFont={MinionPro-Bold.otf},
%  ItalicFont={MinionPro-It.otf},
%  BoldItalicFont={MinionPro-BoldIt.otf},
%  Numbers=OldStyle,
%  Mapping=tex-text
%]{MinionPro-Regular.otf}
%\def\textsuperscript#1{$^{\text{#1}}$}

%\setsansfont[
%  Scale=1.04,
%  Mapping=tex-text,
%  ExternalLocation=./fonts/,
%  BoldFont={HelveticaNeue-Condensed.otf},
%  ItalicFont={HelveticaNeue-ThinItalic.otf},
%  BoldItalicFont={HelveticaNeue-CondensedObl.otf}
%]{HelveticaNeue-Thin.otf}

%\setmonofont[
%  Scale=0.72,
%  Mapping=tex-text,
%  ExternalLocation=./fonts/,
%  BoldFont={DejaVuSansMono-Bold.ttf},
%  ItalicFont={DejaVuSansMono-Oblique.ttf},
%  BoldItalicFont={DejaVuSansMono-BoldOblique.ttf},
%  HyphenChar={-}
%]{DejaVuSansMono.ttf}

% renew title command, create subtitle and authoremail command
\long\def\title{\@dblarg\thesis@title}
\long\def\thesis@title[#1]#2{
  \gdef\@titleshort{#1}
  \gdef\@title{#2}
  \ifx\@titleshort\@empty
    \gdef\@titleshort{#2}
  \fi
}
\newif\ifthesis@hassubtitle
\long\def\subtitle{\@dblarg\thesis@subtitle}
\long\def\thesis@subtitle[#1]#2{
  \gdef\@subtitleshort{#1}
  \gdef\@subtitle{#2}
  \ifx\@subtitle\@empty
    \gdef\@subtitleshort{~}
    \gdef\@subtitle{~}
    \thesis@hassubtitlefalse
  \else
    \ifx\@subtitleshort\@empty
      \gdef\@subtitleshort{#2}
    \fi
    \thesis@hassubtitletrue
  \fi
}
\def\@subtitle{~}

\def\authoremail#1{\gdef\@authoremail{#1}}
\def\@authoremail{~}

\def\matriculationnumber#1{\gdef\@matriculationnumber{#1}}
\def\@matriculationnumber{~}

\def\institute#1{\gdef\@institute{#1}}
\def\@institute{~}

\def\department#1{\gdef\@department{#1}}
\def\@department{~}

\def\examiner#1{\gdef\@examiner{#1}}
\def\@examiner{~}

\def\supervisor#1{\gdef\@supervisor{#1}}
\def\@supervisor{~}

\def\advisor#1{\gdef\@advisor{#1}}
\def\@advisor{~}


% adjust some lengths
\setcounter{secnumdepth}{5}%     we've got 5 heading levels that got numbered
\setcounter{tocdepth}{4}%        show level 4 headings (paragraph) in TOC
\renewcommand\arraystretch{1.5}% more space in tabular/longtable cells
\linespread{1.12}%               enlarge linespacing
\raggedbottom%                   ragged bottom
\setlength\marginparpush{2pt}%   space between margin notes

\RequirePackage{geometry}
\geometry{
  a4paper,
%  paperheight=240mm,
%  paperwidth=170mm,
  headheight=35pt,
  footskip=40pt,
  headsep=35pt,
  marginparwidth=70pt
}

% reducing ToC, LoF, LoT pagestyle, margins and indention
\RequirePackage[titles]{tocloft}
\tocloftpagestyle{fancy}
\renewcommand\@pnumwidth{2em}
\renewcommand{\listoffigures}{%
  \@cfttocstart
  \par
  \begingroup
    \parindent\z@ \parskip\cftparskip
    \section{\listfigurename}
    \@starttoc{lof}%
  \endgroup
  \@cfttocfinish%
}%
\renewcommand{\listoftables}{%
  \@cfttocstart
  \par
  \begingroup
    \parindent\z@ \parskip\cftparskip
    \section{\listtablename}
    \@starttoc{lot}%
  \endgroup
  \@cfttocfinish%
}%
\newcommand\shorttoc{\bgroup
  \makeatletter
  \setlength\parskip{0pt}
  \def\l@subsection##1##2{\relax}
  \def\l@subsubsection##1##2{\relax}
  \def\l@paragraph##1##2{\relax}
  \def\l@subparagraph##1##2{\relax}
  \def\overviewname{Übersicht}
  \phantomsection
  \addcontentsline{toc}{section}{\overviewname}
  \chapter*{\overviewname}
  \markboth{\overviewname}{\overviewname}
  \@input{\jobname.toc}
  \makeatother
\egroup}


\RequirePackage[toc,section,numberedsection=autolabel,nosuper,numberline,acronym,nosuper,notree]{glossaries}


% redefining ToC, LoF, LoT appearance
\renewcommand\cfttoctitlefont{\huge\sffamily\color{Night Blue}}
\renewcommand\cftloftitlefont{\huge\sffamily\color{Night Blue}}
\renewcommand\cftlottitlefont{\huge\sffamily\color{Night Blue}}
\setlength\cftbeforetoctitleskip{0pt}
\setlength\cftbeforeloftitleskip{0pt}
\setlength\cftbeforelottitleskip{0pt}
\setlength\cftparskip{\z@}

% margins, defaults to about .5\baselineskip
\setlength\cftbeforechapskip{.3\baselineskip}
\setlength\cftbeforesecskip{.05\baselineskip}
\setlength\cftbeforesubsecskip{.05\baselineskip}
\setlength\cftbeforesubsubsecskip{.05\baselineskip}
\setlength\cftbeforefigskip{.05\baselineskip}
\setlength\cftbeforetabskip{.05\baselineskip}

% reducing list item seperation
\RequirePackage{enumitem}
\setlist{noitemsep,leftmargin=2em}
\setdescription{style=nextline}

% formatting of footnotes
\RequirePackage[flushmargin,hang,bottom]{footmisc}

% BibLaTeX: A modern BibTeX approach.
\RequirePackage[citestyle=alphabetic-verb,bibstyle=alphabetic,maxnames=100,backend=biber]{biblatex}
\defbibheading{bibliography}[\bibname]{%
  \section{#1}\label{sec:bibliography}%
}
\DefineBibliographyStrings{german}{urlseen = {abgerufen am}}

% hyperlinking
\RequirePackage[pdfa,xetex]{hyperref}
\hypersetup{
  linktocpage=false,
  colorlinks=true,
  linkcolor={Night Blue},
  citecolor={Night Blue},
  filecolor={Night Blue},
  urlcolor={Night Blue},
  frenchlinks=false,
  breaklinks=true,
  pdffitwindow=true,
  pdfcreator={XeTeX \the\XeTeXversion\XeTeXrevision},
  pdfproducer={XeTeX with hyperref, TikZ and many more packages},
  pdfencoding=auto
}
\def\UrlFont{\itshape}

% renew figure and table captions to include chapter number
\RequirePackage[
  margin=10pt,
  font=small,
  format=hang,
  labelfont=bf,
  labelsep=quad,
  position=below,
  hypcap=false
]{caption}
\renewcommand\thefigure{\thechapter.\arabic{figure}}
\renewcommand\thetable{\thechapter.\arabic{table}}
\renewcommand\theequation{\thechapter.\arabic{equation}}
\@addtoreset{figure}{chapter}
\@addtoreset{table}{chapter}
\@addtoreset{equation}{chapter}

% formatting sections
\RequirePackage{titlesec}
\titleformat{\chapter}    [display] {\large\sffamily}          {\@chapapp\space\thechapter} {1ex} {\huge\bfseries\sffamily}
\titleformat{\section}       [hang] {\Large\bfseries\sffamily} {\thesection}                {1em} {}
\titleformat{\subsection}    [hang] {\large\bfseries\sffamily} {\thesubsection}             {1em} {}
\titleformat{\subsubsection} [hang] {\large\sffamily}          {\thesubsubsection}          {1em} {}
\titleformat{\paragraph}     [hang] {\large\sffamily}          {\theparagraph}              {1em} {}
\titleformat{\subparagraph}  [hang] {\normalsize\sffamily}     {\thesubparagraph}           {1em} {}

\titlespacing{\section}       {0pt} {*9} {*1.5}
\titlespacing{\subsection}    {0pt} {*7} {*1.5}
\titlespacing{\subsubsection} {0pt} {*6} {*1.5}
\titlespacing{\paragraph}     {0pt} {*5} {*1.5}
\titlespacing{\subparagraph}  {0pt} {*4} {*1.5}

% more usable tabular environment.
%  #1    = comma seperated list of column widths (percentage)
%  #2    = the table caption (argument will be passed to \caption)
%  #3    = an unique label (argument will be passed to \label)
%  usage = \begin{tabelle}{0.5,0.5}{A nice table}{tab:nice-tab}
%              left & right header \\ \endheadline
%              row 1.left & row 2.right \\
%              ...
%              row n.left & row n.right \\
%          \end{tabelle}
%  note, that the first row must be ending with \endheadline
\RequirePackage{longtable}
\def\tabelletbcname{(wird fortgesetzt)}
\newenvironment{tabelle}[3]{
  \def\endheadline{
    \endhead
      \caption[]{#2\\\tabelletbcname}
    \endfoot
      \caption{#2\label{#3}}
    \endlastfoot
  }
  \let\thesis@tempa\@empty%
  \@for\thesis@tempb:=#1\do{%
    \edef\thesis@tempa{\thesis@tempa p{\thesis@tempb\linewidth-2\tabcolsep}}%
  }
  \edef\thesis@tempa{\noexpand\begin{longtable}{\thesis@tempa}}
  \thesis@tempa
    \rowcolor{Beige}
}{
    \end{longtable}%
}

\RequirePackage{listings}
\lstset{
  language=Ruby,
  gobble=2,
  upquote=true,
  tabsize=4,
  numbers=left,
  numberstyle=\footnotesize\rmfamily,
  stepnumber=1,
  basicstyle=\small\ttfamily,
  keywordstyle=\bfseries\color{Strong Blue},
  commentstyle=\itshape\color{Grey 6},
  stringstyle=\color{Red},
  backgroundcolor=\color{Beige!50},
  columns=fixed,
  showstringspaces=false,
  extendedchars=true,
  breaklines=true,
  prebreak=\raisebox{0ex}[0ex][0ex]{\ensuremath{\hookleftarrow}},
  xleftmargin=1em,
  xrightmargin=1em,
  framexleftmargin=1em,
  framexrightmargin=1em
}
\lstnewenvironment{console}{
  \lstset{
    numbers=none,
    language={},
    basicstyle=\ttfamily\small\color{white},
    backgroundcolor=\color{black!85},
    breaklines=true,
    breakindent=21pt,
    prebreak={\space\textbackslash}
  }
}{}

% last page number. kind of hack...
\newcounter{lastpage}
\setcounter{lastpage}{0}
\let\@rigmainmatter\mainmatter
\def\mainmatter{%
  \addtocounter{lastpage}{\value{page}}%
  \@rigmainmatter%
}
\AtEndDocument{
  \addtocounter{lastpage}{\value{page}}%
  \protected@write\@auxout{}{\string\gdef\string\@lastpage{\thelastpage}}
}
\def\lastpage{%
  \@ifundefined{@lastpage}{%
    \textbf{??}% TODO: commit rerun message
  }{\@lastpage}\xspace
}

%\RequirePackage[colorinlistoftodos,disable]{todonotes}
\RequirePackage[colorinlistoftodos]{todonotes}
\tikzset{notestyle/.style={notestyleraw,rounded corners=0.5pt,inner sep=2pt}}
\let\@rigt@d@\todo
\def\todo{%
  \ClassWarning{thesis}{%
    \string\todo\space is deprecated. use \string\TODO, %
    \string\FIXME\space or \string\XXX\space instead
  }\TODO%
}
\newcommand{\TODO}[2][]{%
  \@rigt@d@[caption={#2},color=Strong Blue,#1]{%
    \def\baselinestretch{0.4}\fontsize{6}{2}\selectfont\bfseries\sffamily\color{white}{#2}\par
  }\xspace%
}
\newcommand{\FIXME}[2][]{%
  \@rigt@d@[caption={#2},color=Red,#1]{%
    \def\baselinestretch{0.4}\fontsize{6}{2}\selectfont\bfseries\sffamily\textcolor{white}{#2}\par
  }\xspace%
}
\newcommand{\XXX}[2][]{%
  \@rigt@d@[caption={#2},color=Beige,#1]{%
    \def\baselinestretch{0.4}\fontsize{6}{2}\selectfont\bfseries\sffamily\textcolor{black}{#2}\par
  }\xspace%
}
\renewcommand\listoftodos{
  \section*{List of TODOs}
  \FIXME[inline]{remove \char`\\listoftodos again}
  \@starttoc{tdo}
}

\newenvironment{nonfloattable}{%
  \vspace{1em}%
  \begin{minipage}{\linewidth}
    \captionsetup{type=table}%
    \centering%
}{%
  \end{minipage}%
  \vspace*{1em}%
}

\newenvironment{nonfloatfigure}{%
  \vspace{1em}%
  \begin{minipage}{\linewidth}
    \captionsetup{type=figure}%
    \centering%
}{%
  \end{minipage}%
  \vspace{1em}%
}

\def\maybespaceafter#1#2{%
  \expandafter\def\csname #1\endcsname{#2\xspace}%
}

\ifx\thesislang\ngermanthesis
  \input{abbreviations.de.tex}
\fi
\ifx\thesislang\englishthesis
  \input{abbreviations.en.tex}
\fi

% basically: "\maybespaceafter{foo}{bar}" defines "\foo" which prints "bar"

\newcommand*{\acr}[1]{\gls{acr:#1}}
\newcommand*{\Acr}[1]{\Gls{acr:#1}}
\newcommand*{\ACR}[1]{\GLS{acr:#1}}
\newcommand*{\acrpl}[1]{\glspl{acr:#1}}
\newcommand*{\Acrpl}[1]{\Glspl{acr:#1}}
\newcommand*{\ACRpl}[1]{\GLSpl{acr:#1}}

\newcommand*{\glos}[1]{\gls{glos:#1}}
\newcommand*{\Glos}[1]{\Gls{glos:#1}}
\newcommand*{\GLOS}[1]{\GLS{glos:#1}}
\newcommand*{\glospl}[1]{\glspl{glos:#1}}
\newcommand*{\Glospl}[1]{\Glspl{glos:#1}}
\newcommand*{\GLOSpl}[1]{\GLSpl{glos:#1}}

%% math tools

\def\N{\ensuremath{\mathbb{N}}}
\def\Z{\ensuremath{\mathbb{Z}}}
\def\I{\ensuremath{\mathbb{I}}}
\def\Q{\ensuremath{\mathbb{Q}}}
\def\R{\ensuremath{\mathbb{R}}}
\def\C{\ensuremath{\mathbb{C}}}
\DeclareMathOperator{\sgn}{\text{sgn}}

% acronyms style
\newglossarystyle{thesisacr}{%
  \renewenvironment{theglossary}%
    {\begin{description}[style=sameline]}
    {\end{description}}
  \renewcommand*{\glossaryheader}{}%
  \renewcommand*{\glsgroupheading}[1]{}%
  \renewcommand*{\glossaryentryfield}[5]{%
      \item[\glstarget{##1}{##2}] ##3, S.~##5
  }%
  \renewcommand*{\glsgroupskip}{\indexspace}%
}

% glossary style
\newglossarystyle{thesis}{%
  \renewenvironment{theglossary}%
    {\begin{description}}
    {\end{description}}
  \renewcommand*{\glossaryheader}{}%
  \renewcommand*{\glsgroupheading}[1]{}%
  \renewcommand*{\glossaryentryfield}[5]{%
      \item[\glstarget{##1}{##2}] ##3 \\
      S.~##5
  }%
  \renewcommand*{\glsgroupskip}{\indexspace}%
}

%% some tolerance parameters
\tolerance=400
\hfuzz=0.2pt

% headers & footers
\RequirePackage{fancyhdr}
\pagestyle{fancy}
%\renewcommand{\chaptermark}[1]{\markboth{#1}{#1}}
%\renewcommand{\sectionmark}[1]{\markboth{#1}{#1}}

\fancyhf{}% clear all fields
\fancyhead[RO]{\thesis@head@oddpage}% ungerade, rechts
\def\thesis@head@oddpage{%
  \small\slshape%
  \diplomaname\hfill\@titleshort\par
  \if@mainmatter\strut\hfill\leftmark\fi%
}

\fancyhead[LE]{\thesis@head@evenpage}% gerade, links
\def\thesis@head@evenpage{%
  \small\slshape%
  \diplomaname\hfill\@titleshort\par
  \if@mainmatter\rightmark\hfill\strut\fi%
}

\fancyfoot[RO,LE]{\thesis@foot}
\def\thesis@foot{\small\thepage}
\renewcommand{\headrulewidth}{0.5pt}

\fancypagestyle{plain}{%
  \fancyhf{}%
  \fancyfoot[RO,LE]{\thesis@foot}
  \renewcommand{\headrulewidth}{0pt}
}

\renewcommand\cleardoublepage{%
  \clearpage
  \if@twoside
    \ifodd
      \c@page
    \else
      \strut\thispagestyle{empty}
      \newpage
      \if@twocolumn
        \strut\thispagestyle{empty}
        \newpage
      \fi
    \fi
  \fi
}


\renewcommand\maketitle{%
  \thispagestyle{empty}%
  \global\@topnum\z@% prevent images to appear on top of first page
  \begin{center}
    \sffamily
    \includegraphics[width=.5\linewidth]{images/institute-logo}\\
    \@department
    \vfill%
    \begin{Huge}
      \color{Night Blue}%
      \bfseries%
      \diplomaname
    \end{Huge}\\[1cm]
    \begin{LARGE}
      \color{Night Blue}%
      \bfseries%
      \@title
    \end{LARGE}\\
    \begin{large}
      \color{Night Blue}%
      \bfseries%
      \@subtitle
    \end{large}\\[2cm]
    \def\and{\\}%
    \def\arraystretch{1.1}%
    \setlength\tabcolsep{4pt}%
    \def\and{$\qquad$}
    \@author\\
    \@authoremail\\
    \matriculationname \@matriculationnumber \\[3em]
    \strut\@date\par%
    \vfill%
    \begin{tabular}{rl}
      \textbf{\examinername:} & \@examiner \\
      \textbf{\supervisorname:} & \@supervisor \\
      \textbf{\advisorname:} & \@advisor
    \end{tabular}
  \end{center}
  \def\and{, }
  \hypersetup{pdftitle=\@title}
  \hypersetup{pdfsubject=\@subtitle}
  \hypersetup{pdfauthor={\@author}}

  \rowcolors{1}{Beige!25}{}
}

\endinput
