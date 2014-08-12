module RSpecLive
  class Backtrace
    def initialize(data)
      @components = data.map { |text| BacktraceComponent.new text }
    end

    def components
      collapsed_components.map(&:to_s)
    end

    private

    def collapsed_components
      @components.inject([]) do |group, component|
        group.dup.tap do |new_group|
          new_group << component unless group.last && (group.last.to_s == component.to_s)
        end
      end
    end
  end

  class BacktraceComponent
    def initialize(text)
      @file, @line, @method = text.split(":")
    end

    def to_s
      if @file.start_with? Dir.pwd
        "#{@file.gsub(/^#{Dir.pwd}\//, "")}:#{@line}"
      elsif @file.include? "/gems/"
        @file.split("/gems/").last.split("/").first
      else
        "other"
      end
    end
  end
end
