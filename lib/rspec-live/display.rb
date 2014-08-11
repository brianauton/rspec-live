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

    def examples=(examples)
      @terminal.move_to 0, 1, :clear_row => true
      examples.map(&:status).each do |status|
        @terminal.text character[status], :color => color[status]
      end
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
