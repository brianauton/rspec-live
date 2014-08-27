module RSpecLive
  class ResultDetail
    attr_reader :verbosity

    def initialize(suite)
      @suite = suite
      @show_all = false
      @verbosity = 1
    end

    def toggle_all
      @show_all = !@show_all
    end

    def focus_next
      @focused = detailed_examples[1].name if detailed_examples[1]
    end

    def cycle_verbosity
      @verbosity = (@verbosity + 1) % 4
    end

    def detailed_examples
      all = @suite.ordered_examples
      if @focused
        index = @suite.ordered_example_names.index(@focused) || 0
        all = all[index, all.length-index] + all[0, index]
      end
      @show_all ? all : all.select(&:failed?)
    end
  end
end
