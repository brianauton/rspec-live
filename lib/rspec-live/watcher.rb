require "listen"

module RSpecLive
  class Watcher
    def initialize(suite, display)
      @suite = suite
      @display = display
    end

    def start
      process_tests :inventory => true
      Listen.to(Dir.pwd) do |modified, added, removed|
        process_tests :inventory => (added.any? || removed.any?)
      end.start
      sleep
    rescue Interrupt
    end

    private

    def process_tests(options)
      if options[:inventory]
        @display.status = "analyzing specs"
        @suite.inventory
      end
      @display.status = "running specs"
      @suite.update
      @display.status = "waiting for updates"
    end
  end
end
