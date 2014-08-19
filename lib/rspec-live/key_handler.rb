module RSpecLive
  class KeyHandler
    def initialize
      @event = {}
    end

    def on(key, &block)
      @event[key] = block
    end

    def listen
      key = STDIN.getc.chr.downcase
      @event[key].call if @event[key]
    end
  end
end
