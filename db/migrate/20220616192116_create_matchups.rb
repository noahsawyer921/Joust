class CreateMatchups < ActiveRecord::Migration[7.0]
  def change
    create_table :matchups do |t|
      t.belongs_to :round, null: false, foreign_key: true
      t.integer :first_choice_id, foreign_key: true
      t.integer :second_choice_id, foreign_key: true

      t.timestamps
    end
  end
end
