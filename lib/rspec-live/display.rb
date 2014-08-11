require "curses"

module RSpecLive
  class Display
    def initialize
      Curses.init_screen
      Curses.clear
      Curses.refresh
    end

    def watcher_status=(status)
      Curses.setpos 0, 0
      Curses.clrtoeol
      Curses.addstr "RSpec Live #{RSpecLive::VERSION} [#{status}]"
      Curses.refresh
    end
  end
end
