require "listen"

module RSpecLive
  class Watcher
    def initialize(suite, display)
      @suite = suite
      @display = display
    end

    def start
      @suite.inventory
      @suite.update
      Listen.to(Dir.pwd) { @suite.update }.start
      sleep
    rescue Interrupt
    end
  end
end
