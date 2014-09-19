require "rspec-live/formatted_text"
require "curses"

module RSpecLive
  class Screen
    def initialize
      reset_curses
      Signal.trap("SIGWINCH", proc { reset_curses; @update_required = true })
    end

    def update_required?
      @update_required
    end

    def start_frame
      Curses.clear
      Curses.setpos 0, 0
    end

    def end_frame
      Curses.refresh
    end

    def print(text, options = {})
      color = options[:color]
      options[:width] = @width if options[:wrap]
      text = FormattedText.new(text, options).text if options.any?
      if color
        Curses.attron(color_attribute color) { Curses.addstr text }
      else
        Curses.addstr text
      end
    end

    private

    def reset_curses
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

    def available_colors
      [:blue, :green, :red, :yellow, :white]
    end

    def color_constant(name)
      Curses.const_get "COLOR_#{name.to_s.upcase}"
    end

    def color_attribute(name)
      Curses.color_pair(color_constant name) | Curses::A_NORMAL
    end
  end
end
