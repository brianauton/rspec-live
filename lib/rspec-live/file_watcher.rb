module RSpecLive
  class FileWatcher
    def initialize(path)
      @path = path
    end

    def notify(receiver)
      Listen.to(@path) do |updated, added, removed|
        receiver.files_updated updated if updated.any?
        receiver.files_removed removed if removed.any?
        receiver.files_added added if added.any?
      end.start
    end
  end
end
