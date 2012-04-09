# encoding: utf-8
class MessageFormatter
  def initialize(message, options)
    @message = message
    @event = options[:event]
    @out = []
  end

  def to_s
    @out << "event:#{@event}" if @event
    @out << format(:data, @message)
    @out.join("\n")
  end

  private

  def format(key, value)
    "#{key}: #{value}\n\n"
  end
end

class Connections
  include Enumerable

  def initialize
    @connections = {}
  end

  def []=(id, connection)
    # Set on_close callback
    connection.callback { leave(id)}
    @connections[id] = connection
  end

  def [](id)
    @connections[id]
  end

  def each(&block)
    @connections.values.each &block
  end

  def delete(id)
    @connections.delete id
  end

  def join(user, connection)
    broadcast "#{user.nickname} joins", event: :join
    self[user.id.to_s] = connection
    send(user, "Hello #{user.nickname}", event: :join)
  end

  def leave(id)
    delete id
    broadcast "#{id} left", event: :leave
  end

  def send(user, message, options = {})
    if self[user.id.to_s]
      self[user.id.to_s] << MessageFormatter.new(message, options).to_s
    end
  end

  def broadcast(message, options = {})
    each {|connection| connection << MessageFormatter.new(message, options).to_s }
  end

  def connected
    @connections.keys
  end
end
