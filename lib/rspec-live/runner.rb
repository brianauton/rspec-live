require "rspec-live/concurrent_process"
require "json"

module RSpecLive
  class Runner
    def initialize
      @queued_examples = []
      @results = []
    end

    def request_inventory
      run "inventory", "--dry-run"
    end

    def request_results(examples)
      @queued_examples = (@queued_examples + examples).uniq
      return if @queued_examples.empty?
      run "update", @queued_examples.join(" ")
      @queued_examples = []
    end

    def results
      @results.pop @results.length
    end

    def updates_available?
      results.any?
    end

    private

    def run(formatter, options="", &block)
      process = ConcurrentProcess.new formatter_command(formatter, options)
      process.each_line { |line| @results << JSON.parse(line) }
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
