class CreateBrackets < ActiveRecord::Migration[7.0]
  def change
    create_table :brackets do |t|
      t.string :name

      t.timestamps
    end
  end
end
