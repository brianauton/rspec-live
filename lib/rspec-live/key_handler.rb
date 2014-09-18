module RSpecLive
  class KeyHandler
    def initialize
      @event = {}
    end

    def on(*keys, &block)
      keys.each { |key| @event[key] = block }
    end

    def process_updates
      any_processed = false
      while key = get_character_if_available
        handle key
        any_processed = true
      end
      any_processed
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
