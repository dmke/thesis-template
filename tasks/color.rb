# null device for shell output redirection. typically `/dev/null`,
# but in ms windows `NUL`
require 'rbconfig'
MSWIN = RbConfig::CONFIG['host_os'] =~ /mswin|mingw/
if MSWIN
  NULL_DEVICE = 'NUL'
  begin
    require 'Win32/Console/ANSI'
    COLOR = true
  rescue LoadError
    puts "Perform `gem install win32console` to get some color."
    COLOR = false
  end
else
  NULL_DEVICE = '/dev/null'
  # stolen from .bashrc
  if File.executable? '/usr/bin/tput' and `/usr/bin/tput setaf`
    COLOR = $?.exitstatus == 0
  else
    COLOR = false
  end
end

def colorize(text, color_code)
  return text unless COLOR
  "#{color_code}#{text}\033[0m"
end

def red(text);       colorize(text, "\033[31m"); end
def green(text);     colorize(text, "\033[32m"); end
def yellow(text);    colorize(text, "\033[33m"); end
def magenta(text);   colorize(text, "\033[35m"); end
def bold(text);      colorize(text, "\033[1m");  end
def underline(text); colorize(text, "\033[4m");  end
