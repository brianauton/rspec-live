require "rspec-live/terminal"

module RSpecLive
  class Display
    def initialize
      @terminal = Terminal.new
    end

    def watcher_display
      WatcherDisplay.new @terminal
    end

    def suite_display
      SuiteDisplay.new @terminal
    end
  end

  class WatcherDisplay
    def initialize(terminal)
      @terminal = terminal
    end

    def status=(status)
      version = RSpecLive::VERSION
      @terminal.text "RSpec Live #{version} [#{status}]", :at => [0, 0], :clear_row => true
    end
  end

  class SuiteDisplay
    def initialize(terminal)
      @terminal = terminal
      @x = -1
    end

    def example_display
      @x += 1
      ExampleDisplay.new @terminal, @x, 1
    end
  end

  class ExampleDisplay
    def initialize(terminal, x, y)
      @terminal = terminal
      @x = x
      @y = y
    end

    def status=(status)
      @terminal.text character[status], :at => [@x, @y], :color => color[status]
    end

    private

    def character
      {:unknown => ".", :passed => ".", :failed => "F", :pending => "S"}
    end

    def color
      {:unknown => :blue, :passed => :green, :failed => :red, :pending => :yellow}
    end
  end
end
