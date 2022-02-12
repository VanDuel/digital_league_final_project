class RenameActionToActInActions < ActiveRecord::Migration[6.1]
  def change
    rename_column :actions, :action, :act
  end
end
