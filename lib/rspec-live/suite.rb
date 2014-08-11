require "rspec-live/example"

module RSpecLive
  class Suite
    def initialize(runner, display)
      @runner = runner
      @display = display
      @example_names = []
      @examples = {}
    end

    def inventory
      @example_names = []
      @runner.inventory do |example_data|
        update_or_create_example example_data
        update_display
      end
    end

    def update
      @runner.update do |example_data|
        update_or_create_example example_data
        update_display
      end
    end

    private

    def update_or_create_example(data)
      name = data["name"]
      @example_names << name unless @example_names.include? name
      @example_names.sort!
      @examples[name] ||= Example.new
      @examples[name].update data
      @examples[name]
    end

    def update_display
      @display.show_examples ordered_examples, summary, ordered_examples.select(&:failed?)
    end

    def ordered_examples
      @example_names.map { |name| @examples[name] }
    end

    def summary
      passed = ordered_examples.select(&:passed?).length
      total = ordered_examples.length
      percent = (100*passed/total.to_f).round
      "#{passed} of #{total} examples passed (#{percent}%)"
    end
  end
end
