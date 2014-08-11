require "json"

class UpdateFormatter
  RSpec::Core::Formatters.register self, :example_passed, :example_failed, :example_pending

  def initialize(output)
    @output = output
  end

  def example_passed(notification)
    report :name => notification.example.location, :status => "passed"
  end

  def example_failed(notification)
    report({
      :name => notification.example.location,
      :status => "failed",
      :backtrace => notification.exception.backtrace,
    })
  end

  def example_pending(notification)
    report :name => notification.example.location, :status => "pending"
  end

  def report(data)
    @output << "#{JSON.unparse data}\n"
  end
end
