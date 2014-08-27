require "listen"
require "rspec-live/key_handler"
require "rspec-live/file_watcher"
require "rspec-live/result_detail"

module RSpecLive
  class Monitor
    def initialize(suite, runner, display, detail)
      @suite = suite
      @runner = runner
      @display = display
      @detail = detail
      @quit = false
    end

    def start
      services.each do |service|
        service.on_update { @display.update @suite }
      end
      @suite.reset
      while !@quit do
        services.each(&:poll)
        sleep 0.05
      end
    end

    private

    def services
      [key_handler, file_watcher, @runner]
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

    def file_watcher
      @file_watcher ||= FileWatcher.new(Dir.pwd, @suite)
    end
  end
end
