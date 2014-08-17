require "rspec-live/example"

module RSpecLive
  class Suite
    def initialize(runner, display)
      @runner = runner
      @display = display
      @examples = {}
      @show_all = false
      @verbosity = 1
    end

    def toggle_all
      @show_all = !@show_all
      update_display
    end

    def inventory
      @runner.inventory do |example_data|
        @examples[example_data["name"]] ||= Example.new
        update_display
      end
    end

    def update
      @runner.update(example_names) do |example_data|
        update_or_create_example example_data
        update_display
      end
    end

    def focus_next
      @focused = detailed_examples[1].name if detailed_examples[1]
      update_display
    end

    def clear_status
      @examples.each_value { |example| example.status = :unknown }
    end

    def cycle_verbosity
      @verbosity = (@verbosity + 1) % 4
      update_display
    end

    def files_touched(names)
      @examples.values.each { |example| example.files_touched names }
    end

    def files_removed(files)
      @examples.delete_if do |name, example|
        files.any? {|f| example.in_file? f }
      end
      update_display
    end

    def stale_example_count
      @examples.values.select(&:stale?).count
    end

    private

    def next_visible(name)
    end

    def update_or_create_example(data)
      name = data["name"]
      @examples[name] ||= Example.new
      @examples[name].update data
      @examples[name]
    end

    def update_display
      @display.show_examples ordered_examples, summary, detailed_examples, @verbosity
    end

    def detailed_examples
      all = ordered_examples
      if @focused
        index = ordered_example_names.index(@focused) || 0
        all = all[index, all.length-index] + all[0, index]
      end
      @show_all ? all : all.select(&:failed?)
    end

    def ordered_examples
      ordered_example_names.map { |name| @examples[name] }
    end

    def example_names
      @examples.keys
    end

    def ordered_example_names
      example_names.sort_by do |name|
        file, line = name.split(":")
        line = line.rjust(8, "0")
        [file, line].join(":")
      end
    end

    def summary
      passed = ordered_examples.select(&:passed?).length
      total = ordered_examples.length
      percent = (100*passed/total.to_f).round
      "#{passed} of #{total} examples passed (#{percent}%)"
    end
  end
end
