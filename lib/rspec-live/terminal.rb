require "curses"

module RSpecLive
  class Terminal
    def initialize
      Terminal.reset_curses
      @root_section = TerminalSection.new
      Signal.trap("SIGWINCH", proc { Terminal.reset_curses; @root_section.refresh })
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
    end

    def self.width
      @width
    end

    def add_section(*args)
      @root_section.add_section(*args)
    end

    def self.color_constant(name)
      Curses.const_get "COLOR_#{name.to_s.upcase}"
    end

    def self.available_colors
      [:blue, :green, :red, :yellow, :white]
    end
  end

  class TerminalSection
    def initialize(parent = nil, options = {})
      @content = ""
      @parent = parent
      options.each_pair { |key, value| instance_variable_set "@#{key}", value }
      @children = []
    end

    def add_section(options = {})
      new_section = TerminalSection.new(self, options)
      @children << new_section
      refresh if options[:content]
      new_section
    end

    def content=(value)
      @content = value.to_s
      refresh
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
      Curses.addstr "\n\n" if @display == :block
      draw_left_margin
      if @color
        Curses.attron(color_attribute @color) { draw_content }
      else
        draw_content
      end
      draw_right_margin
      @children.each(&:draw)
    end

    def draw_content
      text = @content
      text = wrap(text, Terminal.width) if @display == :block && @wrap
      Curses.addstr text
    end

    def wrap(text, width)
      text.scan(/\S.{0,#{width-2}}\S(?=\s|$)|\S+/).join("\n")
    end

    def draw_left_margin
      Curses.addstr(("=" * [0, (((Terminal.width - @content.length) / 2) - 1)].max) + " ") if @align == :center
    end

    def draw_right_margin
      Curses.addstr(" " + ("=" * [0, (((Terminal.width - @content.length) / 2) - 2)].max)) if @align == :center
    end

    private

    def color_attribute(name)
      Curses.color_pair(Terminal.color_constant name) | Curses::A_NORMAL
    end
  end
end
