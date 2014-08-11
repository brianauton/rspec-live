module RSpecLive
  class Example
    attr_reader :status

    def initialize(data)
      @name = data["name"]
      @status = (data["status"] || :unknown).to_sym
    end

    def status=(value)
      @status = value.to_sym
    end

    def passed?
      @status == :passed
    end
  end
end
