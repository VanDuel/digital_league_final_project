require 'date'

TicketType.destroy_all
BoughtTicket.destroy_all
Event.destroy_all

ActiveRecord::Base.connection.execute("DELETE from sqlite_sequence where name = '<events>'")
ActiveRecord::Base.connection.execute("DELETE from sqlite_sequence where name = '<ticket_types>'")
ActiveRecord::Base.connection.execute("DELETE from sqlite_sequence where name = '<bought_tickets>'")
# ActiveRecord::Base.connection.reset_pk_sequence!('events')
# ActiveRecord::Base.connection.reset_pk_sequence!('ticket_types')
# ActiveRecord::Base.connection.reset_pk_sequence!('bought_tickets')

5.times do |time|
  Event.create(
      event_name: "Event#{time}",
      event_date: Date.new(2021, 11, 15),
      general_feels: 0
  )
end

Event.all.each do |event|
  TicketType.create(
    ticket_type: "vip",
    count: 100,
    init_price: 2000,
    event_id: event.id
  )
  TicketType.create(
    ticket_type: "common",
    count: 200,
    init_price: 1000,
    event_id: event.id
  )
end

50.times.each do |time|
  type = rand(2)
  event = Event.all.sample
  BoughtTicket.create(
    event_id: event.id,
    booking_id: time,
    ticket_FIO: "FIO_#{time}",
    ticket_age: rand(20) + time,
    ticket_price: [1000, 2000][type],
    ticket_type: ['common', 'vip'][type],
    doc_num: time + 1000,
    doc_type: 'passport'
  )
end