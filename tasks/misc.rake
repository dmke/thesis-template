desc "Printout all TODOs, FIXMEs, XXXs."
task :notes => FileList['**/*.tex', '**/*.latex'] - [MAIN_TEX] do |t|
  t.prerequisites.sort.each do |pr|
    todos = []
    curr_authors = nil
    File.readlines(pr).each do |line|
      if /\\authors\{(.*?)\}\{.*?\}/ =~ line
        if todos.size > 0
          todos = todos.join "\n    "
          puts "\n#{bold pr}:"
          puts "  Authors: #{curr_authors}"
          puts "    #{todos}"
          todos = []
        end
        authors = $1.split(/\s*\\and\s*/)
        curr_authors = authors.map {|e| red(e.gsub('\\', '')) }.join ', '
      end
      if pos = (/(%\s*)?(TODO|FIXME|XXX)/i =~ line)
        todos << line[pos..-1].gsub(/^%/, '').strip
      end
    end
    if todos.size > 0
      todos = todos.join "\n    "
      puts "\n#{bold pr}:"
      puts "  Authors: #{curr_authors}"
      puts "    #{todos}"
    end
  end
end

desc "Deletes generated PDF images (only if SVG source is available)."
task :clobber_images => FileList['images/**/*.pdf'] do |t|
  t.prerequisites.sort.each do |pr|
    if File.exist? pr.gsub(/\.pdf$/i, '.svg')
      FileUtils.rm pr, :verbose => true
    end
  end
end

desc "Watches for file modifications and runs the default task."
task :watch do
  loop do
    begin
      sleep 1
      sh "rake -s"
    rescue
    end
  end
end

