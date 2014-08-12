require "rspec-live/backtrace"

module RSpecLive
  class Example
    attr_reader :name, :status

    def initialize
      @name = ""
      @status = :unknown
      @backtrace = []
    end

    def update(data)
      @name = data["name"] if data["name"]
      @status = data["status"].to_sym if data["status"]
      @backtrace = data["backtrace"] if data["backtrace"]
      @message = data["message"] if data["message"]
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

    def details
      failed? ? failure_message : name_component
    end

    def name_component
      "(" + @name.gsub(/^.\//, "") + ")"
    end

    def failure_message
      ([name_component] + backtrace_components + exception_components).compact.join " -> "
    end

    def backtrace_components
      Backtrace.new(@backtrace).components.reverse.map { |c| "(#{c})" }
    end

    def exception_components
      [@message.inspect]
    end
  end
end
