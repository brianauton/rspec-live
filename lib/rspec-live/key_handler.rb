module RSpecLive
  class KeyHandler
    def initialize
      @event = {}
    end

    def on(*keys, &block)
      keys.each { |key| @event[key] = block }
    end

    def listen
      handle STDIN.getc.chr.downcase
    rescue Interrupt
      handle :interrupt
    end

    private

    def handle(key)
      @event[key].call if @event[key]
    end
  end
end
