require "pty"
require "json"

module RSpecLive
  class Runner
    attr_reader :status

    def initialize
      @status = ""
    end

    def inventory(&block)
      @status = "analyzing specs"
      run "inventory", "--dry-run", &block
    end

    def update(example_names = [], &block)
      @status = "running #{example_names.count} specs"
      run "update", example_names.join(" "), &block
      @status = "watching for updates..."
      @update_listener.call if @update_listener
    end

    def on_update(&block)
      @update_listener = block
    end

    private

    def run(formatter, options="", &block)
      PTY.spawn formatter_command(formatter, options) do |stdin, stdout, pid|
        begin
          stdin.each do |line|
            block.call JSON.parse line
            @update_listener.call if @update_listener
          end
        rescue Errno::EIO
        end
      end
    rescue PTY::ChildExited
    end

    def formatter_command(formatter, options)
      options << " --format #{formatter_class formatter}"
      options << " --require #{formatter_source formatter}"
      "rspec #{options}"
    end

    def formatter_source(formatter)
      File.join File.dirname(__FILE__), "../formatters/#{formatter}_formatter.rb"
    end

    def formatter_class(formatter)
      "#{formatter.capitalize}Formatter"
    end
  end
end
