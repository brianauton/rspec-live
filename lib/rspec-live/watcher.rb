require "listen"

module RSpecLive
  class Watcher
    def initialize(suite, display)
      @suite = suite
      @display = display
    end

    def start
      process_tests
      Listen.to(Dir.pwd) { process_tests }.start
      while perform_key_command; end
    rescue Interrupt
    end

    private

    def perform_key_command
      key = STDIN.getc.chr.downcase
      @suite.toggle_all if key == "a"
      return false if key == "q"
      process_tests if key == "r"
      true
    end

    def process_tests
      @display.status = "analyzing specs"
      @suite.inventory
      @display.status = "running specs"
      @suite.update
      @display.status = "watching for updates..."
    end
  end
end
