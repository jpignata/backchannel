require "json"

class Message
  attr_reader :client_id, :handle, :content

  def self.inflate(json)
    attributes = JSON.parse(json)
    new(attributes)
  end

  def initialize(attributes={})
    @client_id = attributes.fetch("client_id")
    @handle = attributes.fetch("handle")
    @content = attributes.fetch("content")
  end

  def to_json
    { client_id: client_id, handle: handle, content: content }.to_json
  end
end
