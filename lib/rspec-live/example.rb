module RSpecLive
  class Example
    def initialize(data)
      @name = data["name"]
#      puts "#{@name} discovered"
    end

    def status=(status)
#      puts "#{@name} #{status}"
    end
  end
end
