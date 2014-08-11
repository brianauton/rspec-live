require "curses"

module RSpecLive
  class Terminal
    def initialize
      Curses.init_screen
      Curses.clear
      Curses.refresh
      Curses.start_color
      Curses.use_default_colors
      available_colors.each do |name|
        Curses.init_pair color_constant(name), color_constant(name), -1
      end
    end

    def move_to(x, y, options={})
      Curses.setpos y, x
      Curses.clrtoeol if options[:clear_row]
    end

    def text(text, options)
      move_to(*options[:at], options) if options[:at]
      if options[:color]
        Curses.attron(color_attribute options[:color]) { Curses.addstr text }
      else
        Curses.addstr text
      end
      Curses.refresh
    end

    private

    def color_constant(name)
      Curses.const_get "COLOR_#{name.to_s.upcase}"
    end

    def color_attribute(name)
      Curses.color_pair(color_constant name) | Curses::A_NORMAL
    end

    def available_colors
      [:blue, :green, :red, :yellow, :white]
    end
  end
end
