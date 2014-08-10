module RSpecLive
  class Watcher
    def initialize(suite, display)
      @suite = suite
      @display = display
    end

    def start
      @suite.inventory
      @suite.update
    end
  end
end
