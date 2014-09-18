require "pty"

module RSpecLive
  class ConcurrentProcess
    def initialize(command)
      @command = command
      @output = ""
    end

    def start
      @stdout = PTY.spawn(@command).first
    end

    def each_line
      begin
        loop do
          sleep 0.001
          read_characters
        end
      rescue Errno::EIO
      end
      @output.each_line { |line| yield line }
    end

    private

    def read_characters
      while char = @stdout.read_nonblock(1)
        @output << char
      end
    rescue IO::EAGAINWaitReadable
    end
  end
end
