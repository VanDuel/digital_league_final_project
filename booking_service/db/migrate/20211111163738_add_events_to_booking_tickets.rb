class AddEventsToBookingTickets < ActiveRecord::Migration[6.1]
  def change
    add_reference :booking_tickets, :event, null: false, foreign_key: true
  end
end
