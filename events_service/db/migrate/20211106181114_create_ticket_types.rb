class CreateTicketTypes < ActiveRecord::Migration[6.1]
  def change
    create_table :ticket_types do |t|
      t.string :ticket_type
      t.integer :count
      t.integer :init_price

      t.timestamps
    end
  end
end
