require "curses"

module RSpecLive
  class Display
    def initialize
      Curses.init_screen
      Curses.clear
      Curses.refresh
    end

    def watcher_display
      WatcherDisplay.new
    end

    def suite_display
      SuiteDisplay.new
    end
  end

  class WatcherDisplay
    def status=(status)
      Curses.setpos 0, 0
      Curses.clrtoeol
      Curses.addstr "RSpec Live #{RSpecLive::VERSION} [#{status}]"
      Curses.refresh
    end
  end

  class SuiteDisplay
    def initialize
      @x = -1
    end

    def example_display
      @x += 1
      ExampleDisplay.new @x, 1
    end
  end

  class ExampleDisplay
    def initialize(x, y)
      @x = x
      @y = y
    end

    def status=(status)
      Curses.setpos @y, @x
      Curses.addch status
      Curses.refresh
    end
  end
end
