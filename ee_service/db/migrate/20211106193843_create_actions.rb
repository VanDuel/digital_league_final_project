class CreateActions < ActiveRecord::Migration[6.1]
  def change
    create_table :actions do |t|
      t.integer :ticket_id
      t.string :ticket_type
      t.integer :event_id
      t.string :terminal_type
      t.datetime :time
      t.string :full_name
      t.string :doc_number
      t.integer :action
      t.integer :result

      t.timestamps
    end
  end
end
