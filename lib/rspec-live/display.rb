require "rspec-live/terminal"

module RSpecLive
  class Display
    attr_reader :watcher_display, :suite_display

    def initialize
      @terminal = Terminal.new
      @watcher_display = WatcherDisplay.new(@terminal.add_section :align => :center)
      @terminal.add_section :display => :block, :content => key_command_info
      @suite_display = SuiteDisplay.new(@terminal.add_section :display => :block)
    end

    private

    def key_command_info
      "[ A:all | N:next | V:verbosity | R:rerun | Q:quit ]"
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

    def show_examples(examples, suite_status, detailed_examples, verbosity)
      @section.clear
      @section.add_section :display => :block
      examples.map(&:status).each do |status|
        @section.add_section :content => character[status], :color => color[status]
      end
      @section.add_section :display => :block
      @section.add_section :content => "#{suite_status}", :display => :block
      @section.add_section :display => :block
      bullet_width = (detailed_examples.length-1).to_s.length
      detailed_examples.each_with_index do |example, index|
        bullet = "#{index+1}.".rjust(bullet_width+1, " ")
        @section.add_section :content => example.details(verbosity), :display => :block, :color => color[example.status], :wrap => true, :bullet => bullet
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
