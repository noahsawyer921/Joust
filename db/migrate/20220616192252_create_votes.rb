class CreateVotes < ActiveRecord::Migration[7.0]
  def change
    create_table :votes do |t|
      t.belongs_to :matchup, null: false, foreign_key: true
      t.integer :choice_id, null: false, foreign_key: true

      t.timestamps
    end
  end
end
