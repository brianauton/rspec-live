require "rspec-live/example"

module RSpecLive
  class Suite
    def initialize(runner, file_watcher)
      @runner = runner
      @file_watcher = file_watcher
      @examples = {}
    end

    def clear_status
      @examples.each_value { |example| example.status = :unknown }
    end

    def process_updates
      @file_watcher.updated.each do |path|
        @examples.values.each { |example| example.file_touched path }
      end
      @file_watcher.removed.each do |path|
        @examples.delete_if { |name, example| example.in_file? path }
      end
      @runner.request_inventory if @file_watcher.added.any?
      @runner.request_results stale_example_names
      @runner.results.each { |result| update_or_create_example result }
    end

    def stale_example_names
      @examples.values.select(&:stale?).map(&:name)
    end

    def activity_status
      run_count = stale_example_names.count
      run_count.zero? ? "watching for updates..." : "running #{run_count} specs"
    end

    def summary
      passed = ordered_examples.select(&:passed?).length
      total = ordered_examples.length
      percent = total.zero? ? 0 : (100*passed/total.to_f).round
      "#{passed} of #{total} examples passed (#{percent}%)"
    end

    def ordered_examples
      ordered_example_names.map { |name| @examples[name] }
    end

    def reset
      clear_status
      @runner.request_inventory
    end

    def ordered_example_names
      example_names.sort_by do |name|
        file, line = name.split(":")
        line = line.rjust(8, "0")
        [file, line].join(":")
      end
    end

    private

    def update_or_create_example(data)
      name = data["name"]
      @examples[name] ||= Example.new
      @examples[name].update data
      @examples[name]
    end

    def example_names
      @examples.keys
    end
  end
end
