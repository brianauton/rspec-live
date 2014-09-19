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
      any_processed = false
      @file_watcher.updated.each do |path|
        @examples.values.each { |example| example.file_touched path }
        any_processed = true
      end
      @file_watcher.removed.each do |path|
        @examples.delete_if { |name, example| example.in_file? path }
        any_processed = true
      end
      if @examples.empty? || @file_watcher.added.any?
        @runner.request_inventory
        any_processed = true
      end
      @runner.request_results stale_example_names
      @runner.results.each do |result|
        update_or_create_example result
        any_processed = true
      end
      any_processed
    end

    def stale_example_names
      @examples.values.select(&:stale?).map(&:name)
    end

    def activity_status
      run_count = stale_example_names.count
      run_count.zero? ? "watching for updates..." : "running #{example_count run_count}"
    end

    def summary
      passed = ordered_examples.select(&:passed?).length
      total = ordered_examples.length
      percent = total.zero? ? 0 : (100*passed/total.to_f).round
      "#{passed} of #{example_count total} passed (#{percent}%)"
    end

    def example_count(number)
      "#{number} example" + (number == 1 ? "" : "s")
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
