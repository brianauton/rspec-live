require "rspec-live/concurrent_process"
require "json"

module RSpecLive
  class Runner
    def initialize
      @queued_examples = []
      @results = []
    end

    def request_inventory
      @inventory_requested = true
    end

    def request_results(examples)
      @queued_examples = (@queued_examples + examples).uniq
      return if @queued_examples.empty?
    end

    def results
      start_process unless @process && @process.running?
      @process.each_line { |line| @results << JSON.parse(line) } if @process
      @results.pop @results.length
    end

    private

    def start_process
      if @inventory_requested
        run "inventory", "--dry-run"
        @inventory_requested = false
      elsif @queued_examples.any?
        run "update", @queued_examples.join(" ")
        @queued_examples = []
      end
    end

    def run(formatter, options="", &block)
      @process = ConcurrentProcess.new formatter_command(formatter, options)
      @process.start
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
