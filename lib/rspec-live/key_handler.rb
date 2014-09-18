module RSpecLive
  class KeyHandler
    def initialize
      @event = {}
      @keys_received = []
    end

    def on(*keys, &block)
      keys.each { |key| @event[key] = block }
    end

    def process_updates
      while key = get_character_if_available
        @keys_received << key
      end
      any_processed = false
      while @keys_received.any?
        handle @keys_received.shift
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
