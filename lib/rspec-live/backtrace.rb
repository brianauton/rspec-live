module RSpecLive
  class Backtrace
    def initialize(data, verbosity)
      @components = data.map { |text| BacktraceComponent.new text, verbosity }
    end

    def components
      strip_setup collapsed_components.map(&:to_s)
    end

    private

    def strip_setup(text_components)
      list = text_components.dup
      while ["gem:ruby", "gem:rspec-core"].include? list.last do
        list = list[0, list.length-1]
      end
      list
    end

    def collapsed_components
      @components.inject([]) do |group, component|
        group.dup.tap do |new_group|
          new_group << component unless group.last && (group.last.to_s == component.to_s)
        end
      end
    end
  end

  class BacktraceComponent
    def initialize(text, verbosity)
      @file, @line, @method = text.split(":")
      @verbosity = verbosity
    end

    def to_s
      local_file_reference || gem_reference || "other"
    end

    private

    def local_file_reference
      if @file.start_with? Dir.pwd
        ref = "#{@file.gsub(/^#{Dir.pwd}\//, "")}:#{@line}"
        ref += ":#{cleaned_method}" if @verbosity > 1
        ref
      end
    end

    def cleaned_method
      @method.gsub(/^in `/, "").gsub(/'$/, "")
    end

    def gem_reference
      if @file.include? "/gems/"
        local_reference = @file.split("/gems/").last
        path = local_reference.gsub(/^\/*/, "")
        gem_name_parts = local_reference.split("/").first.split("-")
        gem_name = gem_name_parts[0, gem_name_parts.length - 1].join("-")
        ref = "gem:#{gem_name}"
        ref += "/#{path}:#{@line}:#{cleaned_method}" if @verbosity > 2
        ref
      end
    end
  end
end
