require "curses"

module RSpecLive
  class Terminal
    def initialize
      Terminal.reset_curses
      @root_section = TerminalSection.new
      Signal.trap("SIGWINCH", proc { Terminal.reset_curses; refresh })
    end

    def self.reset_curses
      Curses.init_screen
      Curses.curs_set 0
      Curses.clear
      Curses.refresh
      Curses.start_color
      Curses.use_default_colors
      available_colors.each do |name|
        Curses.init_pair color_constant(name), color_constant(name), -1
      end
      @width = `tput cols`.to_i
      @height = `tput lines`.to_i
      Curses.resizeterm @height, @width
    end

    def self.width
      @width
    end

    def add_section(*args, &block)
      @root_section.add_section(*args, &block)
    end

    def self.color_constant(name)
      Curses.const_get "COLOR_#{name.to_s.upcase}"
    end

    def self.available_colors
      [:blue, :green, :red, :yellow, :white]
    end

    def refresh
      @root_section.refresh
    end
  end

  class TerminalSection
    def initialize(parent = nil, options = {}, &block)
      @content = block || ""
      @parent = parent
      options.each_pair { |key, value| instance_variable_set "@#{key}", value }
      @children = []
    end

    def add_section(options = {}, &block)
      new_section = TerminalSection.new(self, options, &block)
      @children << new_section
      new_section
    end

    def content=(value)
      @content = value.to_s
    end

    def clear
      @content = ""
      @children = []
      refresh
    end

    def refresh
      if @parent
        @parent.refresh
      else
        Curses.clear
        Curses.setpos 0, 0
        draw
        Curses.refresh
      end
    end

    def draw
      Curses.addstr "\n" if @display == :block
      if @color
        Curses.attron(color_attribute @color) { draw_content }
      else
        draw_content
      end
      @children.each(&:draw)
    end

    def draw_content
      text = @content.is_a?(Proc) ? @content.call : @content
      bullet = @bullet ? "#{@bullet} " : ""
      if @display == :block && @wrap
        text = bullet + wrap_with_margin(text, Terminal.width-1, bullet.length)
      end
      Curses.addstr text
    end

    def wrap_with_margin(text, width, margin_width)
      wrap(text, width - margin_width).split("\n").join("\n" + (" " * margin_width))
    end

    def wrap(text, width)
      text.scan(/\S.{0,#{width-2}}\S(?=\s|$)|\S+/).join("\n")
    end

    private

    def color_attribute(name)
      Curses.color_pair(Terminal.color_constant name) | Curses::A_NORMAL
    end
  end
end
