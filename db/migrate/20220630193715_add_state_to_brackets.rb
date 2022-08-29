class AddStateToBrackets < ActiveRecord::Migration[7.0]
  def change
    add_column :brackets, :game_state, :integer, null: false, foreign_key: false, default: -1
  end
end
