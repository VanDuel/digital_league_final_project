class EventService 
  def self.add_event(event)
    types = []
    TicketType.where(event_id: event.id).each do |type|
      types << "&ticket_types[]=[#{type.ticket_type}, #{type.count}, #{type.init_price}]"
    end
    client = HTTPClient.new
    response = client.request(:get, "http://booking_service:3000/events/new?event_id=#{event.id}&event_name=#{event.event_name}&event_date=#{event.event_date}&#{types}")
    JSON.parse(response.body)
  end

  def self.add_ticket_types(ticket_type)
    client = HTTPClient.new
    response = client.request(:get, "http://booking_service:3000/ticket_type/new?event_id=#{ticket_type.event_id}&ticket_type=#{ticket_type.ticket_type}&ticket_count=#{ticket_type.count}&ticket_init_price#{ticket_type.init_price}")
    JSON.parse(response.body)
  end

  def self.update_event(event)
    client = HTTPClient.new
    response = client.request(:get, "http://booking_service:3000/events/update?event_id=#{event.id}&event_name=#{event.event_name}&event_date=#{event.event_date}")
    JSON.parse(response.body)
  end
end