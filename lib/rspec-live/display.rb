require "rspec-live/screen"

module RSpecLive
  class Display
    def initialize(suite, detail)
      @suite = suite
      @detail = detail
      @screen = Screen.new
    end

    def update
      @screen.start_frame
      show_header
      show_summary
      show_details
      @screen.end_frame
    end

    def update_required?
      @screen.update_required?
    end

    private

    def show_header
      @screen.print "RSpec summary for #{File.basename Dir.pwd} (#{@suite.activity_status})\n"
      @screen.print "Keys: A:show/hide-all N:next V:verbosity R:rerun Q:quit", :color => :blue
    end

    def show_summary
      @screen.print "\n\n"
      @suite.ordered_examples.map(&:status).each do |status|
        @screen.print character[status], :color => color[status]
      end
      @screen.print "\n\n"
      @screen.print @suite.summary
    end

    def show_details
      @screen.print "\n\n"
      last_failed = true
      bullet_width = (@detail.detailed_examples.length-1).to_s.length
      @detail.detailed_examples.each_with_index do |example, index|
        bullet = "#{index+1}.".rjust(bullet_width+1, " ")
        @screen.print "\n" if (!last_failed && example.failed?)
        @screen.print "#{bullet} #{example.details @detail.verbosity}", {
          :color => color[example.status],
          :wrap => true,
          :hanging_indent => (bullet_width + 1)
        }
        @screen.print "\n"
        @screen.print "\n" if example.failed?
        last_failed = example.failed?
      end
    end

    def character
      {:unknown => ".", :passed => ".", :failed => "F", :pending => "S"}
    end

    def color
      {:unknown => :blue, :passed => :green, :failed => :red, :pending => :yellow}
    end
  end
end
