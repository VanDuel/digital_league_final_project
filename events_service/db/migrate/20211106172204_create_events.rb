class CreateEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :events do |t|
      t.string :event_name
      t.date :event_date
      t.integer :general_feels

      t.timestamps
    end
  end
end
