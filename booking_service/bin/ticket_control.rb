class AnswerMachine
    def return_answer(booking_id)
        EventMachine.run do
            connection = Bunny.new('amqp://guest:guest@rabbitmq')
            connection.start

            channel = connection.create_channel
            queue = channel.queue('waiting_for_ticket_id', auto_delete: true)

            queue.subscribe do |_delivery_info, _metadata, payload|
            BookingTicket.find(booking_id).update(ticket_id: payload)
            connection.close { EventMachine.stop }
            end
            Signal.trap('INT') do
            #puts 'exiting INT'
            connection.close { EventMachine.stop }
            end
        
            Signal.trap('TERM') do
            #puts 'killing TERM'
            connection.close { EventMachine.stop }
            end
        
        end
    end
end