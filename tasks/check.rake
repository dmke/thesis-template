desc "Performs various checks."
task :check => FileList['**/*.xtex', '**/*.tex', '**/*.latex'] do |t|
  check = LaTeX::Check.new 'glossary.tex', 'acronyms.tex'
  fail  = false
  t.prerequisites.each do |pr|
    check.checkfile pr
  end
  
  results, fail = check.results
  if Rake.application.options.silent
    raise bold(red("Update you glossary/acronyms database!")) + 
      red("Rerun rake without -s/--silent option to see the details.") if fail
  else
    puts results
    raise bold(red("Update you glossary/acronyms database!")) if fail
  end
end
