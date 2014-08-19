require "listen"

module RSpecLive
  class Watcher
    def initialize(suite)
      @suite = suite
    end

    def start
      reset
      Listen.to(Dir.pwd) do |updated, added, removed|
        @suite.files_touched(updated + removed)
        @suite.files_removed removed
        inventory if added.any?
        update
      end.start
      while perform_key_command; end
    rescue Interrupt
    end

    private

    def perform_key_command
      key = STDIN.getc.chr.downcase
      @suite.toggle_all if key == "a"
      @suite.focus_next if key == "n"
      return false if key == "q"
      reset if key == "r"
      @suite.cycle_verbosity if key == "v"
      true
    end

    def reset
      @suite.clear_status
      inventory
      update
    end

    def inventory
      @suite.inventory
    end

    def update
      @suite.update
    end
  end
end
