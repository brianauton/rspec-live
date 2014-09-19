module RSpecLive
  class Log
    def self.do(text)
      File.open(File.join(__dir__, "../../log.txt"), "a") { |f| f.puts text }
    end
  end
end
