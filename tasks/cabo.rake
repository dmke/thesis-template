desc "Display the PDF document in Skim (MacOSX)."
task :skim => :default do
  sh "open -a skim #{MAIN_PDF}"
end

desc "Update from SVN."
task :up do
  sh "svn up"
end

desc "Update and skim."
task :cabo => [:up, :skim]
