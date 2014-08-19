require "listen"
require "rspec-live/key_handler"

module RSpecLive
  class Watcher
    def initialize(suite)
      @suite = suite
      @quit = false
    end

    def start
      reset
      Listen.to(Dir.pwd) do |updated, added, removed|
        @suite.files_updated updated if updated.any?
        @suite.files_removed removed if removed.any?
        @suite.files_added added if added.any?
      end.start
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

    def reset
      @suite.clear_status
      @suite.inventory
      @suite.update
    end
  end
end
