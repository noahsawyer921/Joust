class AddReasoningToChoices < ActiveRecord::Migration[7.0]
  def change
    add_column :choices, :reasoning, :string, null: true, foreign_key: false
  end
end
