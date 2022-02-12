class PublishService 
  def self.return_id(id)
      EventMachine.run do
      connection = Bunny.new('amqp://guest:guest@rabbitmq')
      connection.start

      channel = connection.create_channel
      queue = channel.queue('ticket_id')

      channel.default_exchange.publish({ticket_id: id}.to_json, routing_key: queue.name)
      Signal.trap('INT') do
        puts 'exiting INT'
        connection.close { EventMachine.stop }
      end
    end
  end
end