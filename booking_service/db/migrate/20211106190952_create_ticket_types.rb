class CreateTicketTypes < ActiveRecord::Migration[6.1]
  def change
    create_table :ticket_types do |t|
      t.string :t_type
      t.integer :t_init_price
      t.integer :t_init_num
      t.integer :t_now

      t.timestamps
    end
  end
end
