desc "Run #{TEX_ENGINE} to gain a PDF document (invoked by default target)."
file MAIN_PDF => FileList['*.cls', '*.sty', '**/*.xtex', '**/*.tex', '**/*.latex', '**/*.bib', 'images/**/*.*'] do |t|
  run_no = 0
  log = xtex2pdf
  while rerun? log, run_no
    run_no += 1
    bibtex
    make_glossary 'glossary', MAIN_AUX.gsub(/\.aux$/, '')
    make_acronyms 'glossary', MAIN_AUX.gsub(/\.aux$/, '')
    #make_index
    log = xtex2pdf
  end
  puts "Done."
end

desc "Convert all SVG images to PDF images for LaTeX (invoked by default target)."
task :images => FileList["images/**/*.svg"] do |t|
  t.prerequisites.each do |pr|
    if File.exist?(pr.gsub(/svg$/, 'pdf'))
      svg2pdf(pr) if File.stat(pr).mtime > File.stat(pr.gsub(/svg$/, 'pdf')).mtime
    else
      svg2pdf(pr)
    end
  end
end

desc "Convert all SVG images and create the PDF document."
task :default => [:images, :check, MAIN_PDF]

desc "Determines labels and things they belong to."
task :labels => FileList['**/*.tex', '**/*.latex'] do |t|
  t.prerequisites.sort.each do |pr|
    labels = []
    labels_of(pr).each_pair do |label,thing|
      labels << "%43s -> %s" % [red(label), yellow(thing)]
    end
    puts "\n#{bold pr}\n#{labels.join "\n"}" if labels.size > 0
  end
end

desc "Printout required packages."
task :required => "thesis.cls" do
  f = File.readlines "thesis.cls"
  pkgs = []
  f.each do |line|
    /^\\RequirePackage(\[.*\])?\{(.*?)\}/.match(line) do |m|
      pkgs << m[2].split(/,/)
    end
  end
  puts(pkgs.flatten.sort.join("\n"))
end
