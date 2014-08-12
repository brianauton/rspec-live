require "rspec-live/terminal"

module RSpecLive
  class Display
    attr_reader :watcher_display, :suite_display

    def initialize
      @terminal = Terminal.new
      @watcher_display = WatcherDisplay.new(@terminal.add_section :align => :center)
      @suite_display = SuiteDisplay.new(@terminal.add_section :display => :block)
    end
  end

  class WatcherDisplay
    def initialize(section)
      @section = section
    end

    def status=(status)
      @section.content = "RSpec summary for #{File.basename Dir.pwd} (#{status})"
    end
  end

  class SuiteDisplay
    def initialize(section)
      @section = section
    end

    def show_examples(examples, suite_status, failed_examples)
      @section.clear
      examples.map(&:status).each do |status|
        @section.add_section :content => character[status], :color => color[status]
      end
      @section.add_section :content => "#{suite_status}", :display => :block
      failed_examples.each do |example|
        @section.add_section :content => example.failure_message, :display => :block, :color => :red
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
