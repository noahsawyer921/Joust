class AddUniqueCodeToBracket < ActiveRecord::Migration[7.0]
  def change
    add_index :brackets, :code, unique: true
  end
end
