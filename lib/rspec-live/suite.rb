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
        find_or_create_example example_data
        update_display
      end
    end

    def update
      @runner.update do |example_data|
        find_or_create_example(example_data).status = example_data["status"]
        update_display
      end
    end

    private

    def find_or_create_example(data)
      name = data["name"]
      @example_names << name unless @example_names.include? name
      @example_names.sort!
      @examples[name] ||= Example.new(data)
      @examples[name]
    end

    def update_display
      @display.example_statuses = @example_names.map { |name| @examples[name].status }
    end
  end
end
