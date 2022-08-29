class AddChoicesToBrackets < ActiveRecord::Migration[7.0]
  def change
    add_reference :choices, :bracket, index: true, foreign_key: true
  end
end
