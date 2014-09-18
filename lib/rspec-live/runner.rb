require "rspec-live/concurrent_process"
require "json"

module RSpecLive
  class Runner
    def initialize
      @queued_examples = []
    end

    def request_inventory
    end

    def example_names
      [].tap do |results|
        run("inventory", "--dry-run") { |result| results << result["name"] }
      end
    end

    def request_results(examples)
      @queued_examples = (@queued_examples + examples).uniq
    end

    def results
      results = []
      run("update", @queued_examples.join(" ")) { |result| results << result }
      @queued_examples = []
      @update_listener.call if @update_listener
      results
    end

    def on_update(&block)
      @update_listener = block
    end

    private

    def run(formatter, options="", &block)
      process = ConcurrentProcess.new formatter_command(formatter, options)
      process.each_line do |line|
        block.call JSON.parse line
        @update_listener.call if @update_listener
      end
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
