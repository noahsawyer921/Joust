class CreateInitialVotes < ActiveRecord::Migration[7.0]
  def change
    create_table :initial_votes do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :choice, null: false, foreign_key: true
      t.belongs_to :bracket, null: false, foreign_key: true

      t.timestamps
    end
  end
end
