require "rspec-live/example"

module RSpecLive
  class Suite
    def initialize(runner)
      @runner = runner
      @examples = {}
    end

    def inventory
      @runner.inventory do |example_data|
        @examples[example_data["name"]] ||= Example.new
      end
    end

    def update
      @runner.update(stale_example_names) do |example_data|
        update_or_create_example example_data
      end
    end

    def clear_status
      @examples.each_value { |example| example.status = :unknown }
    end

    def files_updated(paths)
      @examples.values.each { |example| example.files_touched paths }
      update
    end

    def files_removed(paths)
      @examples.delete_if do |name, example|
        paths.any? {|path| example.in_file? path }
      end
      files_updated paths
    end

    def files_added(paths)
      inventory
      update
    end

    def stale_example_names
      @examples.values.select(&:stale?).map(&:name)
    end

    def summary
      passed = ordered_examples.select(&:passed?).length
      total = ordered_examples.length
      percent = (100*passed/total.to_f).round
      "#{passed} of #{total} examples passed (#{percent}%)"
    end

    def ordered_examples
      ordered_example_names.map { |name| @examples[name] }
    end

    def reset
      clear_status
      inventory
      update
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
