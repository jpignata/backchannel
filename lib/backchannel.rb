require_relative "backchannel/client"
require_relative "backchannel/window"
require_relative "backchannel/message"

class Backchannel
  def self.start(handle)
    client = Client.new(handle)
    window = Window.new(client)

    window.start
  end
end
