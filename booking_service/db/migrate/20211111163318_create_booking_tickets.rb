class CreateBookingTickets < ActiveRecord::Migration[6.1]
  def change
    create_table :booking_tickets do |t|
      t.string :t_type
      t.integer :t_price
      t.datetime :t_time
      t.integer :ticket_id

      t.timestamps
    end
  end
end
