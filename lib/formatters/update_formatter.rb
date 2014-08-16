require File.join(File.dirname(__FILE__), "coverage_analyzer")
require "json"

class UpdateFormatter
  RSpec::Core::Formatters.register self, :example_passed, :example_failed, :example_pending
  CoverageAnalyzer.install

  def initialize(output)
    @output = output
  end

  def example_passed(notification)
    report notification.example, "passed"
  end

  def example_failed(notification)
    report notification.example, "failed", {
      :backtrace => notification.exception.backtrace,
      :message => notification.exception.message,
    }
  end

  def example_pending(notification)
    report notification.example, "pending"
  end

  private

  def report(example, status, options = {})
    data = {
      :name => example.location,
      :status => status,
      :files_touched => filtered_files_touched(example),
    }
    @output << "#{JSON.unparse data.merge(options)}\n"
  end

  def filtered_files_touched(example)
    raw_files = example.metadata[:files_touched].keys
    raw_files.select { |file| file.start_with? Dir.pwd }
  end
end
