require "json"

class UpdateFormatter
  RSpec::Core::Formatters.register self, :example_passed, :example_failed, :example_pending

  def initialize(output)
    @output = output
  end

  def example_passed(notification)
    report_status notification.example.location, "passed"
  end

  def example_failed(notification)
    report_status notification.example.location, "failed"
  end

  def example_pending(notification)
    report_status notification.example.location, "pending"
  end

  def report_status(name, status)
    @output << "#{JSON.unparse :name => name, :status => status}\n"
  end
end
