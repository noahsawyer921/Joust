class AddUserToChoices < ActiveRecord::Migration[7.0]
  def change
    add_reference :choices, :user, index: true, foreign_key: true
  end
end
