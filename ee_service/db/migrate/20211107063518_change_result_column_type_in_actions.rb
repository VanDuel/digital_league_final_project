class ChangeResultColumnTypeInActions < ActiveRecord::Migration[6.1]
  def change
    change_column :actions, :result, :boolean
  end
end
