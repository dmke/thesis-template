module LaTeX
  CheckItem = Struct.new :file, :line, :comment
  
  class Check
    def initialize glossary_file, acronyms_file
      @glossary = read_glossary glossary_file
      @acronyms = read_acronyms acronyms_file
      #@items = { :acr => [], :gls => [], :len => [], :ref => [], :cmd => [] }
      @items = { :acr => [], :gls => [], :len => [], :ref => [] }
    end
    
    def checkfile file
      return nil if file =~ /^(definitions|acronyms|glossary)\.tex$/
      lineno = 0
      File.readlines(file).each do |line|
        lineno += 1
        next if line =~ /^\s*$/
        if acr = checkline_acronyms(line)
          @items[:acr] << CheckItem.new(file, lineno, acr)
        end
        if gls = checkline_glossary(line)
          @items[:gls] << CheckItem.new(file, lineno, gls)
        end
        if len = checkline_length(line)
          @items[:len] << CheckItem.new(file, lineno, len)
        end
        if ref = checkline_references(line)
          @items[:ref] << CheckItem.new(file, lineno, ref)
        end
        #if cmd = checkline_deprecated(line)
        #  @items[:cmd] << CheckItem.new(file, lineno, cmd)
        #end
      end
    end
    
    RESULT_CODES = {
      :acr => {
        :check   => bold("Performing acronyms check"),
        :result  => bold(red("Failed.")),
        :failure => true
      },
      :gls => {
        :check => bold("Performing glossary check"),
        :result => bold(red("Failed.")),
        :failure => true
      },
      :len => {
        :check => bold("Performing line length check"),
        :result => bold(yellow("Passed with warnings.")),
        :failure => false
      },
      :ref => {
        :check => bold("Checking non-breakable spaces in front of \\ref's"),
        :result => bold(yellow("Passed with warnings.")),
        :failure => false
      },
      #:cmd => {
      #  :check => bold("Checking deprecated macros and general style"),
      #  :result => bold(yellow("Passed with warnings.")),
      #  :failure => false
      #},
      :pass => green("Passed.")
    }
    
    def results
      result = ""
      fail = false
      @items.each_pair do |key,value|
        result << "#{RESULT_CODES[key][:check]}: "
        if value.size > 0
          fail &&= RESULT_CODES[key][:failure]
          result << RESULT_CODES[key][:result]
        else
          result << RESULT_CODES[:pass]
        end
        result << "\n"
        value.each do |e|
          result << "#{e.file}:#{e.line} -- #{e.comment}\n"
        end
      end
      return result, fail
    end

  private
    def read_glossary file
      glossary = {}
      curr = nil
      File.readlines(file).each do |line|
        if line =~ /^\s*\\newglossaryentry\{(.*?)\}/
          curr = $1.strip
          glossary[curr] = ""
        end
        if line =~ /^\s*\}\s*$/
          curr = nil
        end
        if line =~ /\s*name\s*=\s*\{(.*?)\}/
          glossary[curr] = $1.strip
        end
      end
      glossary
    end

    def read_acronyms file
      acronyms = {}
      curr = nil
      File.readlines(file).each do |line|
        if line =~ /^\s*\\newacronym(\[.*?\])?\{(.*?)\}\{(.*?)\}/
          acronyms[$2.strip] = $3.strip
        end
      end
      acronyms
    end

    def checkline_glossary line
      curr = []
      line.scan /\\(glo?sp?l?)\{(.*?)\}/i do |cmd,key|
        k = key.strip
        next if k =~ /^acr/
        k = "glos:#{k}" if cmd =~ /^glos/i
        curr << k unless @glossary.has_key? k
      end
      return nil if curr.empty?
      curr.map{|x| red x}.join ', '
    end

    def checkline_acronyms line
      curr = []
      line.scan /\\(glo?sp?l?)\{(.*?)\}|\\acrp?l?\{(.*?)\}/i do |cmd,a,b|
        next if cmd =~ /^glos/i
        if cmd.nil? and a.nil? # kind of \acr{…} macro
          key = "acr:#{b.strip}"
          curr << key unless @acronyms.has_key? key
        else # kind of \gls{acr:…} macro
          next if a =~ /^glos/
          key = a.strip
          curr << key unless @acronyms.has_key? key
        end
      end
      return nil if curr.empty?
      curr.map{|x| red x}.join ', '
    end
    
    def checkline_length line
      return nil if line.size <= 110
      case line.size
        when (110..130) then "#{yellow line.size} characters."
        when (130..180) then "#{bold(yellow(line.size))} characters."
        when (180..250) then "#{magenta line.size} characters."
        when (250..350) then "#{red line.size} characters."
        else "#{bold(red(line.size))} characters."
      end
    end
    
    def checkline_references line
      curr = 0
      line.scan /\s~?\\ref/ do
        curr += 1
      end
      return nil if curr.zero?
      "#{yellow "#{curr} time#{curr>1?"s":""}"}."
    end
    
    def checkline_deprecated line
      curr = []
      deprecated = %w{over bf it}.map {|a| /\\(#{a})[^\w]/ }
      line.scan(Regexp.union(deprecated)) do |match|
        dep = match.delete_if{|i| i.nil? }.join ''
        curr << "deprecated #{red "\\#{dep}"} found"
      end
      line.scan(/\\begin\{eqnarray\}/) do
        curr << "found #{red "eqnarray environment"} (use 'align' or 'align*' instead)"
      end
      line.scan(/\\begin\{verbatim\}/) do
        curr << "found #{red "verbatim environment"} (use #{yellow "\\begin{lstlisting}[language={}]"} instead)"
      end
      abbrev = %w{z.B. d.h. u.U. i.d.R. u.A.}.map {|a| Regexp.escape a}
      line.scan(Regexp.union(abbrev)) do
        curr << "found #{red abbrev} (use #{yellow "\\#{abbrev.gsub '.', ''}"} instead)"
      end
      line.scan(/\\FloatBarrier|\\begin\{(table|figure)\}\[[htbp]*H[htbp]*\]/) do
        curr << "found #{red "useless attempt"} to stop figures/tables from floating " +
          "(use #{yellow "\\begin{nonfloatfigure}"} or #{yellow "nonfloattable"} instead)"
      end
      [["``", "''"], ["\"`", "\"'"], ["\\glqq", "\\grqq"]].each do |l,r|
        l = Regexp.escape l
        r = Regexp.escape r
        line.scan(/(#{l}(.*?)#{r})/) do |match,inner|
          curr << "found quotation #{red match} (use #{yellow "\\enquote{#{inner}}"})"
        end
      end
      return nil if curr.empty?
      curr.join ', '
    end
  end
end
