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
      local_file_reference || gem_reference || "other"
    end

    private

    def local_file_reference
      "#{@file.gsub(/^#{Dir.pwd}\//, "")}:#{@line}" if @file.start_with? Dir.pwd
    end

    def gem_reference
      if @file.include? "/gems/"
        gem_parts = @file.split("/gems/").last.split("/").first.split("-")
        gem_name = gem_parts[0, gem_parts.length - 1].join("-")
        "gem:#{gem_name}"
      end
    end
  end
end
