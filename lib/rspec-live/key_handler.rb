module RSpecLive
  class KeyHandler
    def initialize
      @event = {}
    end

    def on(*keys, &block)
      keys.each { |key| @event[key] = block }
    end

    def poll
      key = get_character_if_available
      handle key if key
    rescue Interrupt
      handle :interrupt
    end

    def on_update(&block)
      @update_listener = block
    end

    private

    def get_character_if_available
      STDIN.read_nonblock 1
      rescue Errno::EINTR
      rescue Errno::EAGAIN
      rescue EOFError
    end

    def handle(key)
      if @event[key]
        @event[key].call
        @update_listener.call if @update_listener
      end
    end
  end
end
