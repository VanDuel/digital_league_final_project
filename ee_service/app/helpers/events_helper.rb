module EventsHelper
  def get_ticket(id)
    # JSON.load(
    #   URI.open("events_service:3001/check_ticket?t_id=#{id}")
    # )
    client = HTTPClient.new
    response = client.request(:get, "http://events_service:3001/check_ticket?ticket_id=#{id}")
    JSON.parse(response.body)
    # {
    #   event_id:    1,
    #   ticket_id:   101,
    #   doc_number:  '4545123456',
    #   ticket_type: 'fan'
    # }
  end
end
