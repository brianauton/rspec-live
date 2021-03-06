require "listen"
require "rspec-live/key_handler"
require "rspec-live/result_detail"

module RSpecLive
  class Monitor
    def initialize(suite, display, detail)
      @suite = suite
      @display = display
      @detail = detail
      @quit = false
    end

    def start
      @display.update
      while !@quit do
        @display.update if process_updates || @display.update_required?
        sleep 0.05
      end
      rescue Interrupt
    end

    private

    def process_updates
      key_handler.process_updates || @suite.process_updates
    end

    def key_handler
      @key_handler ||= KeyHandler.new.tap do |handler|
        handler.on("a") { @detail.toggle_all }
        handler.on("n") { @detail.focus_next }
        handler.on("q") { @quit = true }
        handler.on("r") { @suite.reset }
        handler.on("v") { @detail.cycle_verbosity }
      end
    end
  end
end
