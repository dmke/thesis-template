# on clean, delete auxiliary files. on clobbing, delete targets.
require 'rake/clean'

class Array
  def globit
    map {|m| "**/*.#{m}"}
  end
end

# default auxiliary files
CLEAN.include %w{aux log toc lof lot}.globit
# beamer auxiliary files
CLEAN.include %w{snm vrb}.globit
# biblatex auxiliary files
CLEAN.include '**/*-blx.bib'
CLEAN.include %w{blg bbl}.globit
# glossaries auxiliary files (glossary, acronyms)
CLEAN.include %w{glg gls ist glo ind ilg idx acn acr alg}.globit
# misc (hyperref, todonotes, logreq)
CLEAN.include %w{out tdo run.xml}.globit
# finally pdf and synctex
CLOBBER.include(MAIN_PDF, MAIN_PDF.gsub(/pdf$/, 'synctex.gz'))

# runs XeTeX on MAIN_TEX and returns the log file
def xtex2pdf
  # output is logged to main.log which is parsed afterwards. it may be nice to
  # redirect STDOUT or $stdout into a StringIO, but this seems to be harder
  # than thought...
  print bold("Running #{TEX_ENGINE}: ")
  log = nil
  begin
    puts green('OK.') if sh "#{TEX_ENGINE} -synctex=1 -interaction=nonstopmode #{MAIN_TEX} >#{NULL_DEVICE}"
  rescue
    puts red('Error (details below).')
    raise
  ensure
    log = File.readlines(MAIN_LOG)
    nl_or_none
    nl_or_none(print_badboxes(log))
    nl_or_none(print_warnings(log))
    nl_or_none(print_errors(log))
    nl_or_none
  end
  return log
end

# runs Inkscape on given SVG file and converts it to PDF
def svg2pdf file
  print bold("Converting #{file}... ")
  begin
    puts green('OK.') if sh "inkscape -f #{file} -A #{file.gsub /svg$/, "pdf"} >#{NULL_DEVICE}"
  rescue
    puts red('Error (details below).')
    raise
  end
end

# runs BibTeX on MAIN_AUX to create a bibliography
def bibtex
  print bold("Running bibtex (biber): ")
  begin
    puts green('OK.') if sh "biber #{MAIN_AUX.gsub /\.aux$/, '' } >#{NULL_DEVICE}"
  rescue
    puts red("Error (see #{MAIN_AUX.gsub /aux$/, 'blg' }).")
    raise
  end
end

# TODO: merge make_* methods

def make_glossary style, main
  ist = "#{style}.ist"
  glg = "#{main}.glg"
  gls = "#{main}.gls"
  glo = "#{main}.glo"
  print bold("Running makeindex on glossary: ")
  begin
    puts green('OK.') if sh "makeindex -s #{ist} -t #{glg} -o #{gls} #{glo} >#{NULL_DEVICE} 2>#{NULL_DEVICE}"
  rescue
    puts red("Error (see #{glg}).")
    raise
  end
end

def make_acronyms style, main
  ist = "#{style}.ist"
  alg = "#{main}.alg"
  acr = "#{main}.acr"
  acn = "#{main}.acn"
  print bold("Running makeindex on acronyms: ")
  begin
    puts green('OK.') if sh "makeindex -s #{ist} -t #{alg} -o #{acr} #{acn} >#{NULL_DEVICE} 2>#{NULL_DEVICE}"
  rescue
    puts red("Error (see #{alg}).")
    raise
  end
end

def make_index
  stub = MAIN_AUX.gsub /\.aux$/, ''
  idx = "#{stub}.idx"
  ind = "#{stub}.ind"
  ilg = "#{stub}.ilg"
  print bold("Running makeindex on index: ")
  begin
    puts green('OK.') if sh "makeindex #{idx} >#{NULL_DEVICE} 2>#{NULL_DEVICE}"
  rescue
    puts red("Error .")
    raise
  end
end

# parses the given log file contents and print messages about bad boxes (over-/
# underfull horizontal/vertical boxes).
def print_badboxes log
  puts underline("Badboxes:")
  result = false
  curr_file = MAIN_TEX
  log.each do |l|
    begin
      if /\s\((.*?\.tex)/ =~ l
        curr_file = ' in file '
        curr_file << $1.gsub(/^\.\//, '')
      end
      # TODO: the file causing this badbox would be nice to know
      if /^(Ov|Und)erfull \\(v|h)box/ =~ l
        puts "#{magenta(l.strip + curr_file)}"
        result = true
      end
    rescue ArgumentError
    end
  end
  result
end

# parses the given log file contents and print contained warnings.
# the log file entries have a linebreak, if the line length exceedes
# 80 (?) characters. here, i will try to reconcatenate them.
def print_warnings log
  puts underline("Warnings:")
  # return value
  result = false

  # most recently found warning line(s). nil, if none were found.
  curr = nil

  # multiline warnings (sometimes) are prefixed by the package name
  # shouting the warning. unless cut_prefix is nil, we will cut
  # "(cut_prefix)" and any space from the current line.
  cut_prefix = nil
  log.each do |l|
    begin
      if curr # found a warning
        if /^$/ =~ l # warning delimiter: empty line
          puts yellow(curr)
          curr = nil
          cut_prefix = nil
        else
          if /^\(#{cut_prefix}\)(.*)/ =~ l # we have a prefix
            curr << " #{$1.strip}"
          else
            curr << l.chomp
          end
        end
      end
      if /^(Package|LaTeX|Class)(.*)Warning:/ =~ l # warning found
        if $2 and $2.strip != '' # package with name $2 issued a warning
          cut_prefix = $2.strip
        end
        curr = l.chomp
        result = true
      end
    rescue ArgumentError
      cut_prefix = nil
      curr = nil
    end
  end
  result
end

# parses the given log file contents and print contained errors.
# reconcatenating is a bit harder here, since there a many very different
# types of errors...
def print_errors log
  puts underline("Errors:")
  found_error = false
  result = false
  log.each do |l|
    begin
      if found_error
        unless /^$/ =~ l
          puts red(l.chomp)
        else
          found_error = false
        end
      end
      if /^!/ =~ l
        puts red(l.chomp)
        found_error = true
        result = true
      end
    rescue ArgumentError
      found_error = false;
    end
  end
  result
end

# determine if the TeX compiler must be rerunned. three runs should be normal
# if none auxillary files are present. depending on self referencing bibtex or
# glossary entries, two more runs may be necessary. a collateral sixth run
# may resolves any other weird structures. finally, in a seventh run will fail.
def rerun? log, run_no
  raise "Something went wrong. Please check your references." if run_no > 6
  result = false
  log.each do |l|
    begin
      # TODO: may be shortened. could be get confused with "funny" messages...
      result ||= l =~ /LaTeX Warning: Label\(s\) may have changed\. Rerun to get cross-references right\./
      result ||= l =~ /Package hyperref Warning: Rerun to get \/PageLabels entry\./
      result ||= l =~ /\(rerunfilecheck\)\s*Rerun to get outlines right/
      result ||= l =~ /Package biblatex Warning: Please rerun LaTeX\./
      result ||= l =~ /old tdo file detected, not used; run LaTeX again/
      # FIXME: next message matches /BibTeX on (.*?).aux and rerun LaTeX afterwards.$/
      #        and "$1.aux" may differ from MAIN_AUX
      result ||= l =~ /Package biblatex Warning: Please \(re\)run BibTeX/
    rescue ArgumentError
    end
  end
  result
end

# helper.
def nl_or_none in_case_of = true
  if in_case_of
    print $/
  else
    puts "None."
  end
end

# determine labels (per file)
THINGS_WITH_LABEL = %w{\\chapter \\section \\subsection \\subsubsection \\paragraph \\subparagraph \\caption}
def labels_of file
  thing = nil
  labels = {}
  f = File.open(file, "r")
  while line = f.gets
    if line =~ Regexp.union(THINGS_WITH_LABEL)
      thing = line.strip
    end
    if /\\label\{(.*?)\}/ =~ line
      labels[$1] = thing
    end
  end
  f.close
  labels
end
