desc "Display the PDF document in Evince (GNOME)."
task :evince => :default do
  sh "evince #{MAIN_PDF}"
end

desc "Display the PDF document in Okular (KDE)."
task :okular => :default do
  sh "okular #{MAIN_PDF}"
end

desc "Display the PDF document in Acrobat Reader (may not work properly in MS WIN yet). Ensure you have `acroread` or `acrobat` in your $PATH."
task :acrobat => :default do
  if MSWIN
    sh "acrobat #{MAIN_PDF}"
  else
    sh "acroread #{MAIN_PDF}"
  end
end

desc "Display the PDF document in Vorschau (MacOS)."
task :vorschau => :default do
  sh "open #{MAIN_PDF}"
end

