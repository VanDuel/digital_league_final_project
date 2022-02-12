require 'eventmachine'
require 'bunny'
require 'httpclient'
require 'json'

EventMachine.run do
  connection = Bunny.new('amqp://guest:guest@rabbitmq')
  connection.start
  channel = connection.create_channel
  queue = channel.queue('buy_ticket', auto_delete: true)
  queue.subscribe do |_delivery_info, _metadata, payload|
    client = HTTPClient.new
    params = JSON.parse(payload)
    response = client.request(:get, "http://events_service:3001/buy_ticket?event_id=#{params['event_id']}&booking_id=#{params['booking_id']}&ticket_FIO=#{params['ticket_FIO']}&ticket_age=#{params['ticket_age']}&ticket_price=#{params['ticket_price']}&ticket_type=#{params['ticket_type']}&doc_num=#{params['doc_num']}&doc_type=#{params['doc_type']}")
    puts response.body
  end

  Signal.trap('INT') do
    puts 'exiting INT'
    connection.close { EventMachine.stop }
  end
end