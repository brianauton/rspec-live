require "rspec-live/example"

module RSpecLive
  class Suite
    def initialize(runner, display)
      @runner = runner
      @display = display
      @examples = {}
    end

    def inventory
      new_examples = {}
      @runner.inventory do |example_data|
        name = example_data["name"]
        new_examples[name] = find_or_create_example(name, example_data)
      end
      @examples = new_examples
    end

    def update
      @runner.update do |example_data|
        name = example_data["name"]
        example = find_or_create_example(name, example_data)
        example.status = example_data["status"]
      end
    end

    private

    def find_or_create_example(name, data)
      @examples[name] || Example.new(data, @display.example_display)
    end
  end
end
