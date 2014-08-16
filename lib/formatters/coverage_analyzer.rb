class CoverageAnalyzer
  def self.install
    RSpec.configure do |c|
      c.around(:example) do |example|
        CoverageAnalyzer.run_example_with_coverage example
      end
    end
  end

  def self.run_example_with_coverage(example)
    example.metadata[:files_touched] = {}
    set_trace_func proc { |event, file| example.metadata[:files_touched][file] = true }
    example.run
  ensure
    set_trace_func nil
  end
end
