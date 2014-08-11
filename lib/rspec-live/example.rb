require "rspec-live/backtrace"

module RSpecLive
  class Example
    attr_reader :status

    def initialize
      @name = ""
      @status = :unknown
      @backtrace = []
    end

    def update(data)
      @name = data["name"] if data["name"]
      @status = data["status"].to_sym if data["status"]
      @backtrace = data["backtrace"] if data["backtrace"]
    end

    def status=(value)
      @status = value.to_sym
    end

    def passed?
      @status == :passed
    end

    def failed?
      @status == :failed
    end

    def failure_message
      Backtrace.new(@backtrace).components.reverse.map { |c| "[#{c}]" }.join " -> "
    end
  end
end
