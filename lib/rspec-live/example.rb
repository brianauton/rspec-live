module RSpecLive
  class Example
    def initialize(data, display)
      @name = data["name"]
      @display = display
      @display.status = :unknown
    end

    def status=(status)
      @display.status = status.to_sym
    end
  end
end
