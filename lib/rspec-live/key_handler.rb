module RSpecLive
  class KeyHandler
    def initialize
      @event = {}
    end

    def on(*keys, &block)
      keys.each { |key| @event[key] = block }
    end

    def handle_key_if_available
      key = get_character_if_available
      handle key if key
    rescue Interrupt
      handle :interrupt
    end

    private

    def get_character_if_available
      STDIN.read_nonblock 1
      rescue Errno::EINTR
      rescue Errno::EAGAIN
      rescue EOFError
    end

    def handle(key)
      @event[key].call if @event[key]
    end
  end
end
