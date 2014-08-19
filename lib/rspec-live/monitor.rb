require "listen"
require "rspec-live/key_handler"
require "rspec-live/file_watcher"

module RSpecLive
  class Monitor
    def initialize(suite)
      @suite = suite
      @quit = false
    end

    def start
      reset
      file_watcher.notify @suite
      key_handler.listen while !@quit
    end

    private

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
