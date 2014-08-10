require "pty"
require "json"

module RSpecLive
  class Runner
    def inventory(&block)
      PTY.spawn inventory_command do |stdin, stdout, pid|
        begin
          stdin.each do |line|
            block.call JSON.parse line
          end
        rescue Errno::EIO
        end
      end
    rescue PTY::ChildExited
    end

    private

    def inventory_command
      "rspec --require #{inventory_formatter} --format InventoryFormatter --dry-run"
    end

    def inventory_formatter
      File.join File.dirname(__FILE__), "../formatters/inventory_formatter.rb"
    end
  end
end
