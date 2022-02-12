class RemoveTimeFromActions < ActiveRecord::Migration[6.1]
  def change
    remove_column :actions, :time
  end
end
