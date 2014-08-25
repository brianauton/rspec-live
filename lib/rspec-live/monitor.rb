require "listen"
require "rspec-live/key_handler"
require "rspec-live/file_watcher"

module RSpecLive
  class Monitor
    def initialize(suite, runner, display)
      @suite = suite
      @runner = runner
      @display = display
      @quit = false
    end

    def start
      services.each do |service|
        service.on_update { @display.update @suite }
      end
      reset
      file_watcher.notify @suite
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
        handler.on("a") { @suite.toggle_all }
        handler.on("n") { @suite.focus_next }
        handler.on("q", :interrupt) { @quit = true }
        handler.on("r") { reset }
        handler.on("v") { @suite.cycle_verbosity }
      end
    end

    def file_watcher
      @file_watcher ||= FileWatcher.new(Dir.pwd)
    end

    def reset
      @suite.clear_status
      @suite.inventory
      @suite.update
    end
  end
end
