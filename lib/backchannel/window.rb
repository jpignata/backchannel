require "curses"

class Window
  include Curses

  def initialize(client)
    @client = client
    @messages = []
  end

  def start
    init_screen
    start_color
    init_pair(COLOR_WHITE, COLOR_BLACK, COLOR_WHITE)
    redraw

    @client.add_message_listener(self)

    loop do
      capture_input
    end
  end

  def new_message(message)
    @messages << message
    redraw
  end

  private

  def capture_input
    content = getstr

    if content.length > 0
      message = @client.transmit(content)
      new_message(message)
    end
  end

  def redraw
    draw_text_field
    draw_messages
    cursor_to_input_line
    refresh
  end

  def draw_text_field
    setpos(divider_line, 0)
    attron(color_pair(COLOR_WHITE) | A_NORMAL) do
      addstr(" [backchannel]" + " " * cols)
    end

    cursor_to_input_line
    clrtoeol
  end

  def draw_messages
    @messages.last(window_line_size).inject(0) do |line_number, message|
      setpos(line_number, 0)
      clrtoeol
      addstr("<#{message.handle}> #{message.content}")
      line_number + 1
    end
  end

  def input_line
    lines - 1
  end

  def divider_line
    lines - 2
  end

  def window_line_size
    lines - 2
  end

  def cursor_to_input_line
    setpos(input_line, 0)
  end
end
