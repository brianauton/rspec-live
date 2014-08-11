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
      backtrace_components.reverse.join " -> "
    end

    private

    def backtrace_components
      @backtrace.map { |component| "[#{abbreviate_backtrace_component component}]" }
    end

    def abbreviate_backtrace_component(component)
      file, line = component.split(":")
      if file.start_with? Dir.pwd
        file = file.gsub(/^#{Dir.pwd}\//, "")
        "#{file}:#{line}"
      elsif file.include? "/gems/"
        file.split("/gems/").last.split("/").first
      else
        "other"
      end
    end
  end
end
