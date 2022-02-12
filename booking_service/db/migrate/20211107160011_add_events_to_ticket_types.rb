class AddEventsToTicketTypes < ActiveRecord::Migration[6.1]
  def change
    add_reference :ticket_types, :event, null: false, foreign_key: true
  end
end
