class CreateBoughtTickets < ActiveRecord::Migration[6.1]
  def change
    create_table :bought_tickets do |t|
      t.integer :booking_id
      t.string :ticket_FIO
      t.integer :ticket_age
      t.integer :ticket_price
      t.string :ticket_type
      t.integer :doc_num
      t.string :doc_type

      t.timestamps
    end
  end
end
