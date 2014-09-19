require "pty"

module RSpecLive
  class ConcurrentProcess
    def initialize(command)
      @command = command
      @output = ""
    end

    def running?
      @running
    end

    def start
      @stdout, @stdin, @pid = PTY.spawn @command
      @running = true
    end

    def each_line
      read_characters if running?
      shift_completed_lines.each_line { |line| yield line }
    end

    private

    def shift_completed_lines
      lines = ""
      while index = @output.index("\n")
        lines << @output.slice(0, index + 1)
        @output = @output.slice(index + 1, @output.length - index - 1)
      end
      lines
    end

    def read_characters
      while char = @stdout.read_nonblock(100000)
        @output << char
      end
    rescue IO::WaitReadable
    rescue Errno::EIO
      @stdout.close
      @stdin.close
      @running = false
    end
  end
end
