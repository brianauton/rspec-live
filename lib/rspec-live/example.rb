module RSpecLive
  class Example
    def initialize(data, display)
      @name = data["name"]
      @display = display
      @display.status = "?"
    end

    def status=(status)
      @display.status = status_codes[status]
    end

    private

    def status_codes
      {"passed" => ".", "failed" => "F", "pending" => "S"}
    end
  end
end
