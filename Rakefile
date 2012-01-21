#!/usr/bin/env rake
# encoding: utf-8
$KCODE = 'u' if RUBY_VERSION < '1.9'

# required debian packages:
#  inkscape rake biblatex texlive-xetex texlive-latex-extra
# or use the texlive manager:
# $ (sudo) tlmgr update --self
# $ (sudo) tlmgr install biblatex todonotes

=begin
  Rakefile to compile a `main.xtex` to gather a `main.pdf` using XeLaTeX.
  
  Intended to work on Linux, Mac OSX and Windows, using either TeXLive >= 2009,
  MacTeX >= 2009 or MikTeX >= 2.8
  
  Supports currently *only* a `main.xtex`, but may use any *.tex, *.latex,
  *.xtex file as prerequisite. Used SVG images will be converted to PDF using
  Inkscape >= 0.47
 
  Status: To be improved.
  Author: Dominik Menke <dmke@tzi.de>
  Version: 0.3
=end

# defining main files. should be easily detectable by algorithms.
MAIN_TEX = 'thesis.tex'
MAIN_PDF = MAIN_TEX.gsub /tex$/, 'pdf'
MAIN_AUX = MAIN_TEX.gsub /tex$/, 'aux'
MAIN_LOG = MAIN_TEX.gsub /tex$/, 'log'

# the tex processor =~ /(pdf(la)?|xe(la)?|lua)?tex/
TEX_ENGINE = 'xelatex'

%w{latex color check}.each do |rb|
  require "./tasks/#{rb}.rb"
end

Dir.glob('./tasks/*.rake').each do |task|
  import task
end
