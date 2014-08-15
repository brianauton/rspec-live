require "json"

class UpdateFormatter
  RSpec::Core::Formatters.register self, :example_passed, :example_failed, :example_pending
  RSpec.configure do |c|
    c.around(:example) do |example|
      example.metadata[:files_touched] = {}
      set_trace_func proc { |event, file| example.metadata[:files_touched][file] = true }
      example.run
      set_trace_func nil
    end
  end

  def initialize(output)
    @output = output
  end

  def example_passed(notification)
    report notification, "passed"
  end

  def example_failed(notification)
    report notification, "failed", {
      :backtrace => notification.exception.backtrace,
      :message => notification.exception.message,
    }
  end

  def example_pending(notification)
    report notification, "pending"
  end

  private

  def report(notification, status, options = {})
    data = {
      :name => notification.example.location,
      :status => status,
      :files_touched => filtered_files_touched(notification),
    }
    @output << "#{JSON.unparse data.merge(options)}\n"
  end

  def filtered_files_touched(notification)
    raw_files = notification.example.metadata[:files_touched].keys
    raw_files.select { |file| file.start_with? Dir.pwd }
  end
end
