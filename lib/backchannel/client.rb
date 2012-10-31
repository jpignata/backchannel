require "socket"
require "thread"
require "ipaddr"
require "securerandom"

class Client
  MULTICAST_ADDR = "224.6.8.11"
  BIND_ADDR = "0.0.0.0"
  PORT = 6811

  def initialize(handle)
    @handle    = handle
    @client_id = SecureRandom.hex(5)
    @listeners = []
  end

  def add_message_listener(listener)
    listen unless listening?
    @listeners << listener
  end

  def transmit(content)
    message = Message.new(
      "client_id" => @client_id,
      "handle"    => @handle,
      "content"   => content
    )

    socket.send(message.to_json, 0, MULTICAST_ADDR, PORT)
    message
  end

  private

  def listen
    socket.bind(BIND_ADDR, PORT)

    Thread.new do
      loop do
        attributes, _ = socket.recvfrom(1024)
        message = Message.inflate(attributes)

        unless message.client_id == @client_id
          @listeners.each { |listener| listener.new_message(message) }
        end
      end
    end

    @listening = true
  end

  def listening?
    @listening == true
  end

  def socket
    @socket ||= UDPSocket.open.tap do |socket|
      socket.setsockopt(Socket::IPPROTO_IP, Socket::IP_ADD_MEMBERSHIP, bind_address)
      socket.setsockopt(Socket::IPPROTO_IP, Socket::IP_MULTICAST_TTL, 1)
      socket.setsockopt(Socket::SOL_SOCKET, Socket::SO_REUSEPORT, 1)
    end
  end

  def bind_address
    IPAddr.new(MULTICAST_ADDR).hton + IPAddr.new(BIND_ADDR).hton
  end
end
