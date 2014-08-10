require "json"

class InventoryFormatter
  RSpec::Core::Formatters.register self, :example_started

  def initialize(output)
    @output = output
  end

  def example_started(notification)
    @output << "#{JSON.unparse(name: notification.example.location)}\n"
  end
end
