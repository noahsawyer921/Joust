class AddAdminToBrackets < ActiveRecord::Migration[7.0]
  def change
    add_column :brackets, :admin_id, :integer, null: true, foreign_key: true, default: 1
  end
end
