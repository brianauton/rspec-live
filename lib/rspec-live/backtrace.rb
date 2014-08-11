module RSpecLive
  class Backtrace
    def initialize(data)
      @data = data
    end

    def components
      @data.map { |component| "[#{abbreviate_component component}]" }
    end

    private

    def abbreviate_component(component)
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
