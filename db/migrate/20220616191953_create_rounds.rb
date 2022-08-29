class CreateRounds < ActiveRecord::Migration[7.0]
  def change
    create_table :rounds do |t|
      t.belongs_to :bracket, null: false, foreign_key: true
      t.boolean :active, :default => false
      t.integer :round_num, :default => 0

      t.timestamps
    end
  end
end
