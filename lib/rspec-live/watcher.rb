require "listen"

module RSpecLive
  class Watcher
    def initialize(suite, display)
      @suite = suite
      @display = display
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
      @display.status = "analyzing specs"
      @suite.inventory
    end

    def update
      @display.status = "running #{@suite.stale_example_count} specs"
      @suite.update
      @display.status = "watching for updates..."
    end
  end
end
