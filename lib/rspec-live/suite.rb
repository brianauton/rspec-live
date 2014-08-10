require "rspec-live/example"

module RSpecLive
  class Suite
    def initialize(runner)
      @runner = runner
      @examples = {}
    end

    def inventory
      new_examples = {}
      @runner.inventory do |example_data|
        name = example_data["name"]
        new_examples[name] = @examples[name] || Example.new(example_data)
      end
      @examples = new_examples
    end

    def update
      @runner.update do |example_data|
        name = example_data["name"]
        example = @examples[name] || Example.new(example_data)
        example.status = example_data["status"]
      end
    end
  end
end
