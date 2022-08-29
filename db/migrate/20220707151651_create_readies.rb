class CreateReadies < ActiveRecord::Migration[7.0]
  def change
    create_table :readies do |t|
      t.belongs_to :ready_bracket, null: false, foreign_key: {to_table: :brackets}
      t.belongs_to :ready_user, null: false, foreign_key: {to_table: :users}
      t.timestamps
    end
  end
end
