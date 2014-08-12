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
      sleep
    rescue Interrupt
    end

    private

    def process_tests
      @display.status = "analyzing specs"
      @suite.inventory
      @display.status = "running specs"
      @suite.update
      @display.status = "watching for updates..."
    end
  end
end
