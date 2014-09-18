require "pty"

module RSpecLive
  class ConcurrentProcess
    def initialize(command)
      @command = command
    end

    def each_line
      PTY.spawn @command do |stdin, stdout, pid|
        begin
          stdin.each do |line|
            yield line
          end
        rescue Errno::EIO
        end
      end
    rescue PTY::ChildExited
    end
  end
end
