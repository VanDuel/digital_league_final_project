BookingTicket.each do |bt|
    if bt.t_time + 300 <= Time.now
    TicketType.find_by_event_id(bt.event_id)
    .find_by_t_type(bt.t_type).last.t_now += 1
    bt.destroy
    end
end