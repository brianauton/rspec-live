require "listen"
require "rspec-live/key_handler"
require "rspec-live/result_detail"

module RSpecLive
  class Monitor
    def initialize(suite, runner, display, detail, file_watcher)
      @suite = suite
      @runner = runner
      @display = display
      @detail = detail
      @file_watcher = file_watcher
      @quit = false
    end

    def start
      @runner.on_update { @display.update @suite }
      @suite.reset
      while !@quit do
        if services.any?(&:updates_available?)
          key_handler.process_updates
          @suite.process_updates
          @display.update @suite
        end
        sleep 0.05
      end
    end

    private

    def services
      [key_handler, @file_watcher]
    end

    def key_handler
      @key_handler ||= KeyHandler.new.tap do |handler|
        handler.on("a") { @detail.toggle_all }
        handler.on("n") { @detail.focus_next }
        handler.on("q", :interrupt) { @quit = true }
        handler.on("r") { @suite.reset }
        handler.on("v") { @detail.cycle_verbosity }
      end
    end
  end
end
