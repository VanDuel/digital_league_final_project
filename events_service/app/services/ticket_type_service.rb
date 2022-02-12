class TicketTypeService
  def self.add_ticket_type(ticket_type)
    client = HTTPClient.new
    response = client.request(:get, "http://booking_service:3000/ticket_type/new?event_id=#{ticket_type.event_id}&ticket_type=#{ticket_type.ticket_type}&ticket_count=#{ticket_type.count}&ticket_init_price#{ticket_type.init_price}")
    JSON.parse(response.body)
  end
end