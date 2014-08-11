module RSpecLive
  class Backtrace
    def initialize(data)
      @components = data.map { |text| BacktraceComponent.new text }
    end

    def components
      @components.map(&:abbreviated_text)
    end
  end

  class BacktraceComponent
    def initialize(text)
      @file, @line, @method = text.split(":")
    end

    def abbreviated_text
      if @file.start_with? Dir.pwd
        @file = @file.gsub(/^#{Dir.pwd}\//, "")
        "#{@file}:#{@line}"
      elsif @file.include? "/gems/"
        @file.split("/gems/").last.split("/").first
      else
        "other"
      end
    end
  end
end
