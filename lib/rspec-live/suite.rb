require "rspec-live/example"

module RSpecLive
  class Suite
    def initialize(runner, display)
      @runner = runner
      @display = display
      @example_names = []
      @examples = {}
      @show_all = false
      @verbosity = 1
    end

    def toggle_all
      @show_all = !@show_all
      update_display
    end

    def inventory
      @example_names = []
      @runner.inventory do |example_data|
        update_or_create_example example_data
        update_display
      end
    end

    def update
      @runner.update(@example_names) do |example_data|
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

    def stale_example_names
      @example_names.select { |name| @examples[name].stale? }
    end

    private

    def next_visible(name)
    end

    def update_or_create_example(data)
      name = data["name"]
      @example_names << name unless @example_names.include? name
      sort_example_names
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
        index = @example_names.index(@focused) || 0
        all = all[index, all.length-index] + all[0, index]
      end
      @show_all ? all : all.select(&:failed?)
    end

    def ordered_examples
      @example_names.map { |name| @examples[name] }
    end

    def sort_example_names
      @example_names.sort_by! do |name|
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
