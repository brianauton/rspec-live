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
  end
end
