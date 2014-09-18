module RSpecLive
  class FileWatcher
    def initialize(path)
      @updated, @added, @removed = [], [], []
      Listen.to(path) do |updated, added, removed|
        @updated += updated
        @added += added
        @removed += removed
      end.start
    end

    def updates_available?
      @updated.any? || @added.any? || @removed.any?
    end

    def updated
      queued_results @updated
    end

    def added
      queued_results @added
    end

    def removed
      queued_results @removed
    end

    private

    def queued_results(queue)
      [].tap do |result|
        while queue.any?
          result << queue.shift
        end
      end
    end
  end
end
