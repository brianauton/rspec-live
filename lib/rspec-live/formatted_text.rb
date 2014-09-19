module RSpecLive
  class FormattedText
    def initialize(text, options = {})
      @text = text
      @wrap = options[:wrap]
      @width = options[:width]
      @hanging_indent = options[:hanging_indent] || 0
    end

    def text
      if @wrap
        wrap(@text, @width - @hanging_indent).split("\n").join("\n" + (" " * @hanging_indent))
      else
        @text
      end
    end

    private

    def wrap(text, width)
      text.scan(/\S.{0,#{width-2}}\S(?=\s|$)|\S+/).join("\n")
    end
  end
end
